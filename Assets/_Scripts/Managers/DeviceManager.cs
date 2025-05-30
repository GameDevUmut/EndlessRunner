using UnityEngine;

namespace Managers
{
    public class DeviceManager : MonoBehaviour
    {
        private void Awake()
        {
            SetTargetFrameRate();
        }

        private void SetTargetFrameRate()
        {
            #if UNITY_ANDROID || UNITY_IOS
                Application.targetFrameRate = 60;
            #elif UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX || UNITY_STANDALONE_LINUX || UNITY_EDITOR
                Application.targetFrameRate = 120;
            #else
                Application.targetFrameRate = 60; // Default fallback
            #endif
        }
    }
}
