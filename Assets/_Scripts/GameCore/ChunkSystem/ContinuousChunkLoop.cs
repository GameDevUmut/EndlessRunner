using System;
using System.Collections.Generic;
using Addler.Runtime.Core.LifetimeBinding;
using Cysharp.Threading.Tasks;
using GameCore.ChunkSystem;
using GameCore.Scriptables;
using UnityEngine;
using UnityEngine.AddressableAssets;
using Utilities;
using VContainer;
using VContainer.Unity;
using Random = UnityEngine.Random;

public class ContinuousChunkLoop : MonoBehaviour
{
    [SerializeField] private LevelData levelData;
    [SerializeField] private int maxActiveChunks = 2;
    [SerializeField] private float activationDistance = 20f;
    [SerializeField] private Transform playerTransform;
    
    private int _poolSize;
    private CircularQueue<ChunkConnector> _chunksPool;
    private List<ChunkConnector> _activeChunks = new List<ChunkConnector>();
    private Vector3 _nextChunkPosition;
    private bool _isInitialized = false;
    private IObjectResolver _resolver;

    private void Awake()
    {
        _poolSize = levelData.LevelPrefabReferences.Length;
        _chunksPool = new CircularQueue<ChunkConnector>(_poolSize);
    }
    private void Start()
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

    [Inject]
    private void Construct(IObjectResolver resolver)
    {
        _resolver = resolver;
    }
    
    private async UniTask InitializeChunkPool()
    {
        for (int i = 0; i < _poolSize; i++)
        {
            GameObject chunkPrefab = await Addressables.LoadAssetAsync<GameObject>(levelData.LevelPrefabReferences[i]).BindTo(gameObject);
            ChunkConnector chunk = _resolver.Instantiate(chunkPrefab).GetComponent<ChunkConnector>();
            chunk.gameObject.SetActive(false);
            _chunksPool.Enqueue(chunk);
        }
        
        _nextChunkPosition = Vector3.zero;
        
        for (int i = 0; i < maxActiveChunks; i++)
        {
            ActivateNextChunk();
        }
        
        _isInitialized = true;
    }
    private void UpdateChunkActivation()
    {
        if (_activeChunks.Count > 0)
        {
            ChunkConnector lastActiveChunk = _activeChunks[_activeChunks.Count - 1];
            float distanceToLastChunk = Vector3.Distance(playerTransform.position, lastActiveChunk.GetNextChunkConnectionPosition());
            
            if (distanceToLastChunk <= activationDistance)
            {
                for (int i = 0; i < 2; i++)
                {
                    ActivateNextChunk();
                }
            }
        }
        
        DeactivateDistantChunks();
    }
    private void ActivateNextChunk()
    {
        if (_chunksPool.Count == 0) return;
        
        ChunkConnector nextChunk = _chunksPool.Dequeue();
        
        nextChunk.PositionChunkAtStart(_nextChunkPosition);
        
        nextChunk.gameObject.SetActive(true);
        
        _activeChunks.Add(nextChunk);
        
        _nextChunkPosition = nextChunk.GetNextChunkConnectionPosition();
        
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
        
        oldestChunk.gameObject.SetActive(false);
        
        _chunksPool.Enqueue(oldestChunk);
    }
    
    private void DeactivateDistantChunks()
    {
        float maxDistanceBehind = 50f;
        
        for (int i = _activeChunks.Count - 1; i >= 0; i--)
        {
            ChunkConnector chunk = _activeChunks[i];
            Vector3 chunkPosition = chunk.transform.position;
            
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
    
    public int GetActiveChunkCount()
    {
        return _activeChunks.Count;
    }
    
    public Vector3 GetNextChunkPosition()
    {
        return _nextChunkPosition;
    }
    
    public void ForceActivateChunk()
    {
        ActivateNextChunk();
    }
}
