using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace Utilities
{
    public class ShaderVariantLoader : MonoBehaviour
    {
        private async void Start()
        {
            // Load the shader variant collection
            AsyncOperationHandle<ShaderVariantCollection> handle = 
                Addressables.LoadAssetAsync<ShaderVariantCollection>("ShaderVariants");
        
            await handle.Task;
        
            if (handle.Status == AsyncOperationStatus.Succeeded)
            {
                // Warm up the shaders
                handle.Result.WarmUp();
                Debug.Log("Shader variants loaded and warmed up successfully");
            }
            else
            {
                Debug.LogError("Failed to load shader variant collection");
            }
        }
    }
}
