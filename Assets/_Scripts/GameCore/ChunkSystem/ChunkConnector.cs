using UnityEngine;

namespace GameCore.ChunkSystem
{
    public class ChunkConnector : MonoBehaviour
    {
        [SerializeField] private Transform startPoint; // Where this chunk begins
        [SerializeField] private Transform endPoint;   // Where this chunk ends
        [SerializeField] private float chunkLength;    // Cached length for performance
    
        private void Awake()
        {
            // Cache the length between start and end points
            chunkLength = Vector3.Distance(startPoint.position, endPoint.position);
        }
    
        public Vector3 GetConnectionPoint()
        {
            return endPoint.position;
        }
    
        public float GetChunkLength()
        {
            return chunkLength;
        }
    
        public Vector3 GetStartPoint()
        {
            return startPoint.position;
        }
    
        public Vector3 GetEndPoint()
        {
            return endPoint.position;
        }
    
        /// <summary>
        /// Positions this chunk so its start point aligns with the given world position
        /// </summary>
        /// <param name="worldPosition">The world position to align the start point to</param>
        public void PositionChunkAtStart(Vector3 worldPosition)
        {
            Vector3 offset = worldPosition - startPoint.position;
            transform.position += offset;
        }
    
        /// <summary>
        /// Gets the world position where the next chunk should be placed to connect seamlessly
        /// </summary>
        /// <returns>World position for the next chunk's start point</returns>
        public Vector3 GetNextChunkConnectionPosition()
        {
            return endPoint.position;
        }
    
        /// <summary>
        /// Recalculates the chunk length (useful if transforms are modified at runtime)
        /// </summary>
        public void RecalculateLength()
        {
            chunkLength = Vector3.Distance(startPoint.position, endPoint.position);
        }
    }
}
