using System;
using System.Collections.Generic;
using Addler.Runtime.Core.LifetimeBinding;
using Cysharp.Threading.Tasks;
using GameCore.ChunkSystem;
using GameCore.Scriptables;
using UnityEngine;
using UnityEngine.AddressableAssets;
using Utilities;
using Random = UnityEngine.Random;

public class ContinuousChunkLoop : MonoBehaviour
{
    [SerializeField] private LevelData levelData;
    [SerializeField] private int maxActiveChunks = 2; // Maximum number of active chunks at any time
    [SerializeField] private float activationDistance = 20f; // Distance threshold to activate new chunks
    [SerializeField] private Transform playerTransform; // Reference to the player's transform
    
    private int _poolSize;
    private CircularQueue<ChunkConnector> _chunksPool;
    private List<ChunkConnector> _activeChunks = new List<ChunkConnector>();
    private Vector3 _nextChunkPosition; // Position where the next chunk should be placed
    private bool _isInitialized = false;

    private void Awake()
    {
        _poolSize = levelData.LevelPrefabReferences.Length;
        _chunksPool = new CircularQueue<ChunkConnector>(_poolSize);
    }    private void Start()
    {
        InitializeChunkPool().Forget();
    }

    private void Update()
    {
        if (_isInitialized && playerTransform != null)
        {
            UpdateChunkActivation();
        }
    }
    
    private async UniTask InitializeChunkPool()
    {
        // Pre-instantiate all chunks for object pooling
        for (int i = 0; i < _poolSize; i++)
        {
            GameObject chunkPrefab = await Addressables.LoadAssetAsync<GameObject>(levelData.LevelPrefabReferences[i]).BindTo(gameObject);
            ChunkConnector chunk = Instantiate(chunkPrefab).GetComponent<ChunkConnector>();
            chunk.gameObject.SetActive(false);
            _chunksPool.Enqueue(chunk);
        }
        
        // Initialize the first set of chunks
        _nextChunkPosition = Vector3.zero; // Start at world origin
        
        // Activate initial chunks
        for (int i = 0; i < maxActiveChunks; i++)
        {
            ActivateNextChunk();
        }
        
        _isInitialized = true;
    }
      private void UpdateChunkActivation()
    {
        // Check if we need to activate new chunks based on player distance
        if (_activeChunks.Count > 0)
        {
            ChunkConnector lastActiveChunk = _activeChunks[_activeChunks.Count - 1];
            float distanceToLastChunk = Vector3.Distance(playerTransform.position, lastActiveChunk.GetNextChunkConnectionPosition());
            
            // If player is close to the connection point, activate new chunks
            if (distanceToLastChunk <= activationDistance)
            {
                // Activate 2 new chunks as specified
                for (int i = 0; i < 2; i++)
                {
                    ActivateNextChunk();
                }
            }
        }
        
        // Deactivate chunks that are too far behind the player
        DeactivateDistantChunks();
    }
      private void ActivateNextChunk()
    {
        if (_chunksPool.Count == 0) return;
        
        // Get the next chunk from the circular queue
        ChunkConnector nextChunk = _chunksPool.Dequeue();
        
        // Position the chunk at the next connection point using the improved positioning method
        nextChunk.PositionChunkAtStart(_nextChunkPosition);
        
        // Activate the chunk
        nextChunk.gameObject.SetActive(true);
        
        // Add to active chunks list
        _activeChunks.Add(nextChunk);
        
        // Update the next chunk position to the end of this chunk
        _nextChunkPosition = nextChunk.GetNextChunkConnectionPosition();
        
        // Limit the number of active chunks
        while (_activeChunks.Count > maxActiveChunks)
        {
            DeactivateOldestChunk();
        }
    }
    
    private void DeactivateOldestChunk()
    {
        if (_activeChunks.Count == 0) return;
        
        ChunkConnector oldestChunk = _activeChunks[0];
        _activeChunks.RemoveAt(0);
        
        // Deactivate the chunk
        oldestChunk.gameObject.SetActive(false);
        
        // Return it to the circular queue for reuse
        _chunksPool.Enqueue(oldestChunk);
    }
    
    private void DeactivateDistantChunks()
    {
        // Only keep chunks that are within a reasonable distance behind the player
        float maxDistanceBehind = 50f; // Adjust as needed
        
        for (int i = _activeChunks.Count - 1; i >= 0; i--)
        {
            ChunkConnector chunk = _activeChunks[i];
            Vector3 chunkPosition = chunk.transform.position;
            
            // Calculate if chunk is too far behind the player
            Vector3 toPlayer = playerTransform.position - chunkPosition;
            float distanceBehind = Vector3.Dot(toPlayer, playerTransform.forward);
            
            if (distanceBehind > maxDistanceBehind && _activeChunks.Count > maxActiveChunks)
            {
                _activeChunks.RemoveAt(i);
                chunk.gameObject.SetActive(false);
                _chunksPool.Enqueue(chunk);
            }
        }
    }
    
    /// <summary>
    /// Get the current number of active chunks
    /// </summary>
    public int GetActiveChunkCount()
    {
        return _activeChunks.Count;
    }
    
    /// <summary>
    /// Get the position where the next chunk will be placed
    /// </summary>
    public Vector3 GetNextChunkPosition()
    {
        return _nextChunkPosition;
    }
    
    /// <summary>
    /// Manually trigger chunk activation (useful for testing)
    /// </summary>
    public void ForceActivateChunk()
    {
        ActivateNextChunk();
    }
}
