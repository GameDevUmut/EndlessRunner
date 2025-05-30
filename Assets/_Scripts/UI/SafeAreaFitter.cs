using UnityEngine;

namespace UI
{
    /// <summary>
    /// Automatically adjusts a RectTransform to fit within the device's safe area.
    /// Useful for mobile devices with notches, rounded corners, or home indicators.
    /// </summary>
    [RequireComponent(typeof(RectTransform))]
    public class SafeAreaFitter : MonoBehaviour
    {
        [Header("Safe Area Settings")]
        [SerializeField] private bool _applyOnStart = true;
        [SerializeField] private bool _updateOnOrientationChange = true;
        [SerializeField] private bool _debugLog = false;
        
        [Header("Padding (Optional)")]
        [SerializeField] private Vector4 _additionalPadding = Vector4.zero;
        
        private RectTransform _rectTransform;
        private Rect _lastSafeArea = new Rect(0, 0, 0, 0);
        private ScreenOrientation _lastOrientation = ScreenOrientation.Unknown;
        
        #region Unity Lifecycle
        
        private void Awake()
        {
            _rectTransform = GetComponent<RectTransform>();
        }
        
        private void Start()
        {
            if (_applyOnStart)
            {
                ApplySafeArea();
            }
        }
        
        private void Update()
        {
            if (_updateOnOrientationChange)
            {
                CheckForOrientationChange();
            }
        }
        
        #endregion
        
        #region Public Methods
        
        /// <summary>
        /// Manually apply safe area adjustments to the RectTransform
        /// </summary>
        public void ApplySafeArea()
        {
            Rect safeArea = Screen.safeArea;
            
            if (safeArea == _lastSafeArea)
                return;
                
            _lastSafeArea = safeArea;
            
            if (_debugLog)
            {
                Debug.Log($"[SafeAreaFitter] Applying safe area: {safeArea} on screen: {Screen.width}x{Screen.height}");
            }
            
            Vector2 anchorMin = safeArea.position;
            Vector2 anchorMax = safeArea.position + safeArea.size;
            
            anchorMin.x /= Screen.width;
            anchorMin.y /= Screen.height;
            anchorMax.x /= Screen.width;
            anchorMax.y /= Screen.height;
            
            if (_additionalPadding != Vector4.zero)
            {
                Vector2 screenSize = new Vector2(Screen.width, Screen.height);
                Vector2 paddingMin = new Vector2(_additionalPadding.x / screenSize.x, _additionalPadding.y / screenSize.y);
                Vector2 paddingMax = new Vector2(_additionalPadding.z / screenSize.x, _additionalPadding.w / screenSize.y);
                
                anchorMin += paddingMin;
                anchorMax -= paddingMax;
            }
            
            anchorMin.x = Mathf.Clamp01(anchorMin.x);
            anchorMin.y = Mathf.Clamp01(anchorMin.y);
            anchorMax.x = Mathf.Clamp01(anchorMax.x);
            anchorMax.y = Mathf.Clamp01(anchorMax.y);
            
            _rectTransform.anchorMin = anchorMin;
            _rectTransform.anchorMax = anchorMax;
            
            _rectTransform.offsetMin = Vector2.zero;
            _rectTransform.offsetMax = Vector2.zero;
            
            if (_debugLog)
            {
                Debug.Log($"[SafeAreaFitter] Applied anchors - Min: {anchorMin}, Max: {anchorMax}");
            }
        }
        
        /// <summary>
        /// Reset the RectTransform to full screen (ignore safe area)
        /// </summary>
        public void ResetToFullScreen()
        {
            _rectTransform.anchorMin = Vector2.zero;
            _rectTransform.anchorMax = Vector2.one;
            _rectTransform.offsetMin = Vector2.zero;
            _rectTransform.offsetMax = Vector2.zero;
            
            if (_debugLog)
            {
                Debug.Log("[SafeAreaFitter] Reset to full screen");
            }
        }
        
        #endregion
        
        #region Private Methods
        
        private void CheckForOrientationChange()
        {
            if (Screen.orientation != _lastOrientation)
            {
                _lastOrientation = Screen.orientation;
                
                Invoke(nameof(ApplySafeArea), 0.1f);
                
                if (_debugLog)
                {
                    Debug.Log($"[SafeAreaFitter] Orientation changed to: {_lastOrientation}");
                }
            }
        }
        
        #endregion
        
        #region Editor Methods
        
#if UNITY_EDITOR
        [ContextMenu("Apply Safe Area")]
        private void ApplySafeAreaContextMenu()
        {
            if (_rectTransform == null)
                _rectTransform = GetComponent<RectTransform>();
                
            ApplySafeArea();
        }
        
        [ContextMenu("Reset to Full Screen")]
        private void ResetToFullScreenContextMenu()
        {
            if (_rectTransform == null)
                _rectTransform = GetComponent<RectTransform>();
                
            ResetToFullScreen();
        }
        
        private void OnValidate()
        {
            _additionalPadding.x = Mathf.Max(0, _additionalPadding.x);
            _additionalPadding.y = Mathf.Max(0, _additionalPadding.y);
            _additionalPadding.z = Mathf.Max(0, _additionalPadding.z);
            _additionalPadding.w = Mathf.Max(0, _additionalPadding.w);
        }
#endif
        
        #endregion
    }
}
