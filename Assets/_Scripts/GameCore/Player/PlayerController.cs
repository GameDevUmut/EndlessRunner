using System;
using System.Collections;
using Interfaces;
using R3;
using UnityEngine;
using VContainer;

namespace GameCore.Player
{
    public class PlayerController : MonoBehaviour, IPlayerService
    {
        private const int LEFT_LANE_INDEX = -1;
        private const int CENTER_LANE_INDEX = 0;
        private const int RIGHT_LANE_INDEX = 1;

        #region Serializable Fields

        [SerializeField] private float moveSpeed = 5f;
        [SerializeField] private float laneMoveMargin = 3f; // Defines how far left/right a lane is from center
        [SerializeField] private float jumpDistance = 5f;   // How high the character jumps relative to its starting Y
        [SerializeField] private CharacterController characterController;
        [SerializeField] private float laneChangeSpeed = 10f; // Speed of smoothly changing lanes
        [SerializeField]
        private float jumpApexTime = 0.4f; // Time to reach the peak of the jump (and also time to fall back)
        [SerializeField] private float gravityValue = -19.62f; // Custom gravity, e.g., 2 * Physics.gravity.y

        #endregion

        #region Fields

        private int _currentLaneIndex = CENTER_LANE_INDEX;
        private bool _isJumping = false;
        private int _lastDistanceMilestone = 0; // Track last distance milestone to update DistanceTravelled
        private float _originalYPosition;
        private Vector3 _playerVelocity;
        private float _targetXPosition;
        private bool _isDead = false;
        private IGameService _gameService;

        #endregion

        #region Unity Methods

        void Start()

        {
            if (characterController == null)
            {
                characterController = GetComponent<CharacterController>();
            }

            _originalYPosition = transform.position.y;
            _targetXPosition = GetXPositionForLane(_currentLaneIndex);
            _playerVelocity.y = -2f;
        }        void Update()
        {
            // Stop all movement if player is dead
            if (_isDead) return;
            
            bool groundedPlayer = characterController.isGrounded;
            Vector3 forwardDisplacement = transform.forward * moveSpeed * Time.deltaTime;
            float currentX = transform.position.x;
            float desiredXThisFrame = Mathf.Lerp(currentX, _targetXPosition, laneChangeSpeed * Time.deltaTime);
            float horizontalDisplacementX = desiredXThisFrame - currentX;
            float verticalDisplacementY = 0f;
            if (_isJumping)
            {
            }
            else
            {
                if (groundedPlayer)
                {
                    if (_playerVelocity.y < 0)
                    {
                        _playerVelocity.y = -0.5f;
                    }
                }
                else
                {
                    _playerVelocity.y += gravityValue * Time.deltaTime;
                }

                verticalDisplacementY = _playerVelocity.y * Time.deltaTime;
            }

            Vector3 totalDisplacement = new Vector3(horizontalDisplacementX, verticalDisplacementY, 0);
            totalDisplacement += forwardDisplacement;
            characterController.Move(totalDisplacement);

            // Update distance travelled based on distance from origin
            UpdateDistanceTravelled();
        }

        private void OnControllerColliderHit(ControllerColliderHit hit)
        {
            if(!_isDead && hit.gameObject.CompareTag("Obstacle"))
            {
                _isDead = true;
                
                _gameService.EndGame();
                Debug.Log("Player hit an obstacle and died!");
            }
        }

        #endregion

        #region Public Methods

        public void Jump()
        {
            if(_isDead) return;
            
            if (characterController.isGrounded && !_isJumping)
            {
                StartCoroutine(PerformJumpCoroutine());
            }
        }

        public void Run()
        {
        }        public void MoveLeft()
        {
            if (_isDead) return;
            
            if (_currentLaneIndex > LEFT_LANE_INDEX)
            {
                _currentLaneIndex--;
                _targetXPosition = GetXPositionForLane(_currentLaneIndex);
            }
        }

        public void MoveRight()
        {
            if (_isDead) return;
            
            if (_currentLaneIndex < RIGHT_LANE_INDEX)
            {
                _currentLaneIndex++;
                _targetXPosition = GetXPositionForLane(_currentLaneIndex);
            }
        }

        #endregion

        #region Private Methods

        [Inject]
        private void Construct(IGameService gameService)
        {
            _gameService = gameService;
        }
        

        private float GetXPositionForLane(int laneIndex)
        {
            if (laneIndex == LEFT_LANE_INDEX) return -laneMoveMargin;
            if (laneIndex == RIGHT_LANE_INDEX) return laneMoveMargin;
            return 0f;
        }

        private IEnumerator PerformJumpCoroutine()
        {
            _isJumping = true;
            float jumpStartY = transform.position.y;
            float peakY = jumpStartY + jumpDistance;
            float elapsedTime = 0f;
            while (elapsedTime < jumpApexTime)
            {
                float desiredY = Mathf.Lerp(jumpStartY, peakY, elapsedTime / jumpApexTime);
                float deltaYThisFrame = desiredY - transform.position.y;
                characterController.Move(new Vector3(0, deltaYThisFrame, 0));
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            characterController.Move(new Vector3(0, peakY - transform.position.y, 0));
            elapsedTime = 0f;
            float fallStartY = transform.position.y;
            while (elapsedTime < jumpApexTime)
            {
                float desiredY = Mathf.Lerp(fallStartY, _originalYPosition, elapsedTime / jumpApexTime);
                float deltaYThisFrame = desiredY - transform.position.y;
                characterController.Move(new Vector3(0, deltaYThisFrame, 0));
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            characterController.Move(new Vector3(0, _originalYPosition - transform.position.y, 0));
            _isJumping = false;
            _playerVelocity.y = -0.5f;
        }

        private void UpdateDistanceTravelled()
        {
            // Calculate distance from origin (0, 0, 0)
            float currentDistance = Vector3.Distance(transform.position, Vector3.zero);
            int currentDistanceInt = Mathf.FloorToInt(currentDistance);

            // Update DistanceTravelled every meter
            if (currentDistanceInt > _lastDistanceMilestone)
            {
                DistanceTravelled.Value = currentDistanceInt;
                _lastDistanceMilestone = currentDistanceInt;
            }
        }

        #endregion

        #region IPlayerService Members

        public Transform PlayerTransform => transform;
        public ReactiveProperty<int> DistanceTravelled { get; private set; } = new ReactiveProperty<int>(0);

        #endregion
    }
}
