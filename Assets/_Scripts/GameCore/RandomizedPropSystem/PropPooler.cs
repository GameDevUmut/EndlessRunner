using System.Collections.Generic;
using Addler.Runtime.Core.Pooling;
using Cysharp.Threading.Tasks;
using GameCore.Scriptables;
using Interfaces;
using UnityEngine;
using UnityEngine.AddressableAssets;
using Utilities;
using VContainer;

namespace GameCore.RandomizedPropSystem
{
    public class PropPooler : MonoBehaviour, IPropPoolerService
    {
        #region Serializable Fields

        [SerializeField] private PropData propData;

        [SerializeField] private int perBuildingWarmupCount;
        [SerializeField] private int perVegetationWarmupCount;
        [SerializeField] private int perRoadBlockWarmupCount;
        [SerializeField] private int perPropWarmupCount;

        #endregion

        #region Fields

        private IGameService _gameService;

        private List<UniTask> _warmupTasks = new List<UniTask>();
        private List<AddressablePool> buildingPools = new List<AddressablePool>();
        private List<AddressablePool> propPools = new List<AddressablePool>();
        private List<AddressablePool> roadBlockPools = new List<AddressablePool>();
        private List<AddressablePool> vegetationPools = new List<AddressablePool>();

        private static bool _isDisposing = false;

        #endregion

        #region Unity Methods

        private void Awake()
        {
            _isDisposing = false;
            CreateAllPools();
        }

        private void OnDestroy()
        {
            //we destroy the pool objects, release addressable assets from the memory
            _isDisposing = true;
            ReleasePools();
        }

        #endregion

        #region Private Methods

        [Inject]
        private void Construct(IGameService gameService)
        {
            _gameService = gameService;
        }

        private async UniTask CreateAllPools()
        {
            CreatePool(propData.BuildingReferences, ref buildingPools, perBuildingWarmupCount);
            CreatePool(propData.VegetationReferences, ref vegetationPools, perVegetationWarmupCount);
            CreatePool(propData.RoadBlockReferences, ref roadBlockPools, perRoadBlockWarmupCount);
            CreatePool(propData.PropReferences, ref propPools, perPropWarmupCount);

            await UniTask.WhenAll(_warmupTasks);
            WarmupCompletion.TrySetResult(true);
            _warmupTasks.Clear();
        }

        private void CreatePool(AssetReferenceGameObject[] assetReferences, ref List<AddressablePool> pools,
            int warmupCount)
        {
            foreach (var reference in assetReferences)
            {
                AddressablePool pool = new AddressablePool(reference, "Pool_" + reference.RuntimeKey.ToString());
                _warmupTasks.Add(pool.WarmupAsync(warmupCount));
                pools.Add(pool);
            }
        }

        private PooledObject GetRandomFromPool(List<AddressablePool> pools)
        {
            var pool = pools.PickRandom();
            var poolObj = pool.Use();
            return poolObj;
        }

        private void ReleasePools()
        {
            foreach (var pool in buildingPools)
            {
                pool.Dispose();
            }

            foreach (var pool in propPools)
            {
                pool.Dispose();
            }

            foreach (var pool in roadBlockPools)
            {
                pool.Dispose();
            }

            foreach (var pool in vegetationPools)
            {
                pool.Dispose();
            }
        }

        #endregion

        #region IPropPoolerService Members

        public UniTaskCompletionSource<bool> WarmupCompletion { get; } = new UniTaskCompletionSource<bool>();

        public static bool IsDisposing => _isDisposing;

        public PooledObject GetRandomBuilding()
        {
            return GetRandomFromPool(buildingPools);
        }

        public PooledObject GetRandomVegetation()
        {
            return GetRandomFromPool(vegetationPools);
        }

        public PooledObject GetRandomRoadBlock()
        {
            return GetRandomFromPool(roadBlockPools);
        }

        public PooledObject GetRandomProp()
        {
            return GetRandomFromPool(propPools);
        }

        #endregion
    }
}
