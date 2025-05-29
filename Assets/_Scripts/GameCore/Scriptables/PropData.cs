using UnityEngine;
using UnityEngine.AddressableAssets;

namespace GameCore.Scriptables
{
    [CreateAssetMenu(fileName = "PropData", menuName = "Scriptable Objects/Prop Data", order = 1)]
    public class PropData : ScriptableObject
    {
        public AssetReferenceGameObject[] BuildingReferences;
        public AssetReferenceGameObject[] VegetationReferences;
        public AssetReferenceGameObject[] RoadBlockReferences;
        public AssetReferenceGameObject[] PropReferences;
    }
}
