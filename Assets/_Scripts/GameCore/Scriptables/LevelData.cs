using UnityEngine;
using UnityEngine.AddressableAssets;

namespace GameCore.Scriptables
{
    [CreateAssetMenu(fileName = "LevelData", menuName = "Scriptable Objects/Level Data", order = 0)]
    public class LevelData : ScriptableObject
    {
        public AssetReferenceGameObject[] LevelPrefabReferences;
    }
}
