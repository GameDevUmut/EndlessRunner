using System.Collections.Generic;
using Addler.Runtime.Core.Pooling;
using Cysharp.Threading.Tasks;
using GameCore.Scriptables;
using Interfaces;
using UnityEngine;
using UnityEngine.AddressableAssets;
using Utilities;

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

        private List<UniTask> _warmupTasks = new List<UniTask>();
        private List<AddressablePool> buildingPools = new List<AddressablePool>();
        private List<AddressablePool> propPools = new List<AddressablePool>();
        private List<AddressablePool> roadBlockPools = new List<AddressablePool>();
        private List<AddressablePool> vegetationPools = new List<AddressablePool>();

        #endregion

        #region Unity Methods

        private void Awake()
        {
            CreateAllPools();
        }

        #endregion

        #region Private Methods

        private void CreateAllPools()
        {
            CreatePool(propData.BuildingReferences, ref buildingPools, perBuildingWarmupCount);
            CreatePool(propData.VegetationReferences, ref vegetationPools, perVegetationWarmupCount);
            CreatePool(propData.RoadBlockReferences, ref roadBlockPools, perRoadBlockWarmupCount);
            CreatePool(propData.PropReferences, ref propPools, perPropWarmupCount);
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

        private GameObject GetRandomFromPool(List<AddressablePool> pools)
        {
            var pool = pools.PickRandom();
            var poolObj = pool.Use();
            return poolObj.Instance;
        }
        
        public GameObject GetRandomBuilding()
        {
            return GetRandomFromPool(buildingPools);
        }
        
        public GameObject GetRandomVegetation()
        {
            return GetRandomFromPool(vegetationPools);
        }
        
        public GameObject GetRandomRoadBlock()
        {
            return GetRandomFromPool(roadBlockPools);
        }
        
        public GameObject GetRandomProp()
        {
            return GetRandomFromPool(propPools);
        }

        #endregion
    }
}
