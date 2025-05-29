using System;
using Addler.Runtime.Core.Pooling;
using Interfaces;
using UnityEngine;
using VContainer;

namespace GameCore.RandomizedPropSystem
{
    public class PropSpawner : MonoBehaviour
    {
        #region PropType enum

        public enum PropType
        {
            Building,
            Vegetation,
            RoadBlock,
            Prop
        }

        #endregion

        #region Serializable Fields

        [SerializeField] private PropType propType;
        [SerializeField] private float despawnDistance = 50f;

        #endregion

        #region Fields

        private PooledObject _currentSpawnedPoolObject;
        private bool _hasSpawned = false;
        private IPlayerService _playerService;
        private IPropPoolerService _propPoolerService;
        private bool _firstSpawn = true;
        private static bool _isApplicationQuitting = false;

        #endregion

        #region Unity Methods

        private void Awake()
        {
            Application.quitting += OnApplicationQuitting;
        }

        private void Start()
        {
            if (_firstSpawn)
            {
                SpawnProp();
                _firstSpawn = false;
            }
        }

        private void OnEnable()
        {
            if (_firstSpawn) return;

            SpawnProp();
        }

        private void Update()
        {
            if (_hasSpawned && _playerService?.PlayerTransform != null && _currentSpawnedPoolObject != null)
            {
                CheckForDespawn();
            }
        }

        private void OnDisable()
        {
            if (_hasSpawned && !_isApplicationQuitting)
            {
                DespawnProp();
            }
        }

        private void OnDestroy()
        {
            Application.quitting -= OnApplicationQuitting;
        }

        #endregion

        #region Private Methods

        private static void OnApplicationQuitting()
        {
            _isApplicationQuitting = true;
        }

        [Inject]
        private void Construct(IPropPoolerService propPoolerService, IPlayerService playerService)
        {
            _playerService = playerService;
            _propPoolerService = propPoolerService;
        }

        private void CheckForDespawn()
        {
            Vector3 playerPosition = _playerService.PlayerTransform.position;
            Vector3 propPosition = transform.position;
            Vector3 playerForward = _playerService.PlayerTransform.forward;
            Vector3 propToPlayer = playerPosition - propPosition;
            float distanceAlongPlayerForward = Vector3.Dot(propToPlayer, playerForward);
            if (distanceAlongPlayerForward >= despawnDistance)
            {
                DespawnProp();
            }
        }

        private void SpawnProp()
        {
            if (_propPoolerService == null)
            {
                Debug.LogError("PropPoolerService is not injected. Please check your dependency injection setup.");
                return;
            }

            switch (propType)
            {
                case PropType.Building:
                    _currentSpawnedPoolObject = _propPoolerService.GetRandomBuilding();
                    break;
                case PropType.Vegetation:
                    _currentSpawnedPoolObject = _propPoolerService.GetRandomVegetation();
                    break;
                case PropType.RoadBlock:
                    _currentSpawnedPoolObject = _propPoolerService.GetRandomRoadBlock();
                    break;
                case PropType.Prop:
                    _currentSpawnedPoolObject = _propPoolerService.GetRandomProp();
                    break;
            }

            if (_currentSpawnedPoolObject != null)
            {
                var gameObj = _currentSpawnedPoolObject.Instance;
                gameObj.transform.position = transform.position;
                gameObj.transform.rotation = transform.rotation;
                _hasSpawned = true;
            }
        }

        private void DespawnProp()
        {
            if (_currentSpawnedPoolObject != null)
            {
                _currentSpawnedPoolObject.Dispose();
                _currentSpawnedPoolObject = null;
                _hasSpawned = false;
            }
        }

        #endregion

#if UNITY_EDITOR
        private Bounds _bounds;
        private PropType _lastPropType;

        private Bounds Bounds
        {
            get
            {
                if (_bounds == default || _lastPropType != propType)
                {
                    UpdateBounds();
                }

                return _bounds;
            }
        }

        private void UpdateBounds()
        {
            Vector3 size = propType switch
            {
                PropType.Building => new Vector3(10f, 10f, 10f),
                PropType.Vegetation => new Vector3(3f, 3f, 3f),
                PropType.RoadBlock => new Vector3(5f, 5f, 5f),
                PropType.Prop => new Vector3(2f, 2f, 2f),
                _ => new Vector3(2f, 2f, 2f)
            };
            _bounds = new Bounds(Vector3.zero, size);
            _lastPropType = propType;
        }

        private void OnValidate()
        {
            // Always update bounds to ensure they're properly initialized
            UpdateBounds();
        }

        private void OnDrawGizmos()
        {
            DrawBoundsGizmo();
        }

        private void OnDrawGizmosSelected()
        {
            DrawBoundsGizmo();
        }

        private void DrawBoundsGizmo()
        {
            // Ensure bounds are properly initialized
            if (_bounds == default)
            {
                UpdateBounds();
            }

            Gizmos.color = GetGizmoColor();
            // Position the cube so its base is at the transform position
            Vector3 center = transform.position + new Vector3(0, _bounds.size.y * 0.5f, 0);
            Gizmos.DrawWireCube(center, _bounds.size);
            Gizmos.color = new Color(Gizmos.color.r, Gizmos.color.g, Gizmos.color.b, 0.2f);
            Gizmos.DrawCube(center, _bounds.size);
            Vector3 basePosition = transform.position;
            Vector3 forwardDirection = transform.forward;
            float arrowLength = Mathf.Min(_bounds.size.x, _bounds.size.z) * 0.5f;
            Gizmos.color = Color.white;
            Vector3 arrowEnd = basePosition + forwardDirection * arrowLength;
            Gizmos.DrawLine(basePosition, arrowEnd);
            Vector3 arrowRight = Vector3.Cross(forwardDirection, Vector3.up) * arrowLength * 0.2f;
            Vector3 arrowUp = Vector3.up * arrowLength * 0.2f;
            Gizmos.DrawLine(arrowEnd, arrowEnd - forwardDirection * arrowLength * 0.3f + arrowRight);
            Gizmos.DrawLine(arrowEnd, arrowEnd - forwardDirection * arrowLength * 0.3f - arrowRight);
            Gizmos.DrawLine(arrowEnd, arrowEnd - forwardDirection * arrowLength * 0.3f + arrowUp);
        }

        private Color GetGizmoColor()
        {
            return propType switch
            {
                PropType.Building => Color.red,
                PropType.Vegetation => Color.green,
                PropType.RoadBlock => Color.yellow,
                PropType.Prop => Color.blue,
                _ => Color.white
            };
        }
#endif
    }
}
