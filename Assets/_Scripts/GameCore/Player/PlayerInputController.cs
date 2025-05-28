using UnityEngine;
using UnityEngine.InputSystem;

namespace GameCore.Player
{
    public class PlayerInputController : MonoBehaviour
    {
        [SerializeField] private PlayerController playerController;
        [SerializeField] private float swipeSensitivity = 50f;

        private bool _forceMobile = false;
        private PlayerInputActions _playerInputActions;
        private Vector2 _currentPosition;
        private Vector2 _initialPosition;

        private void Awake()
        {
            _forceMobile = true;
            _playerInputActions = new PlayerInputActions();
            _playerInputActions.Player.Enable();
        }

        private void Start()
        {
            _playerInputActions.Player.Jump.performed += ctx => playerController.Jump();
            _playerInputActions.Player.GoLeft.performed += ctx => playerController.MoveLeft();
            _playerInputActions.Player.GoRight.performed += ctx => playerController.MoveRight();
            _playerInputActions.Player.Press.performed += OnTouchPress;
            _playerInputActions.Player.Press.canceled += OnTouchRelease;
        }

        private void OnDestroy()
        {
            _playerInputActions.Dispose();
        }

        private void OnTouchPress(InputAction.CallbackContext context)
        {
            _initialPosition = _playerInputActions.Player.Position.ReadValue<Vector2>();
        }

        private void OnTouchRelease(InputAction.CallbackContext context)
        {
            _currentPosition = _playerInputActions.Player.Position.ReadValue<Vector2>();
            DetectSwipe();
        }

        private void DetectSwipe()
        {
            Vector2 direction = _currentPosition - _initialPosition;
            float swipeDistance = direction.magnitude;

            if (swipeDistance < swipeSensitivity)
            {
                return;
            }

            direction.Normalize();

            if (Mathf.Abs(direction.x) > Mathf.Abs(direction.y))
            {
                if (direction.x > 0)
                {
                    OnSwipeRight();
                }
                else
                {
                    OnSwipeLeft();
                }
            }
            else
            {
                if (direction.y > 0)
                {
                    OnSwipeUp();
                }
                else
                {
                    OnSwipeDown();
                }
            }
        }

        private void OnSwipeLeft()
        {
            playerController.MoveLeft();
        }

        private void OnSwipeRight()
        {
            playerController.MoveRight();
        }

        private void OnSwipeUp()
        {
            playerController.Jump();
        }

        private void OnSwipeDown()
        {
        }
    }
}
