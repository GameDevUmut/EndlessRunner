using System.Collections;
using Interfaces;
using UnityEngine;

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

        private int currentLaneIndex = CENTER_LANE_INDEX;
        private bool isJumping = false;
        private float originalYPosition;
        private Vector3 playerVelocity;
        private float targetXPosition;

        #endregion

        #region Unity Methods

        void Start()
        {
            if (characterController == null)
            {
                characterController = GetComponent<CharacterController>();
            }

            originalYPosition = transform.position.y;
            targetXPosition = GetXPositionForLane(currentLaneIndex);
            playerVelocity.y = -2f;
        }

        void Update()
        {
            bool groundedPlayer = characterController.isGrounded;
            Vector3 forwardDisplacement = transform.forward * moveSpeed * Time.deltaTime;
            float currentX = transform.position.x;
            float desiredXThisFrame = Mathf.Lerp(currentX, targetXPosition, laneChangeSpeed * Time.deltaTime);
            float horizontalDisplacementX = desiredXThisFrame - currentX;
            float verticalDisplacementY = 0f;
            if (isJumping)
            {
            }
            else
            {
                if (groundedPlayer)
                {
                    if (playerVelocity.y < 0)
                    {
                        playerVelocity.y = -0.5f;
                    }
                }
                else
                {
                    playerVelocity.y += gravityValue * Time.deltaTime;
                }

                verticalDisplacementY = playerVelocity.y * Time.deltaTime;
            }

            Vector3 totalDisplacement = new Vector3(horizontalDisplacementX, verticalDisplacementY, 0);
            totalDisplacement += forwardDisplacement;
            characterController.Move(totalDisplacement);
        }

        #endregion

        #region Public Methods

        public void Jump()
        {
            if (characterController.isGrounded && !isJumping)
            {
                StartCoroutine(PerformJumpCoroutine());
            }
        }

        public void Run()
        {
        }

        public void MoveLeft()
        {
            if (currentLaneIndex > LEFT_LANE_INDEX)
            {
                currentLaneIndex--;
                targetXPosition = GetXPositionForLane(currentLaneIndex);
            }
        }

        public void MoveRight()
        {
            if (currentLaneIndex < RIGHT_LANE_INDEX)
            {
                currentLaneIndex++;
                targetXPosition = GetXPositionForLane(currentLaneIndex);
            }
        }

        #endregion

        #region Private Methods

        private float GetXPositionForLane(int laneIndex)
        {
            if (laneIndex == LEFT_LANE_INDEX) return -laneMoveMargin;
            if (laneIndex == RIGHT_LANE_INDEX) return laneMoveMargin;
            return 0f;
        }

        private IEnumerator PerformJumpCoroutine()
        {
            isJumping = true;
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
                float desiredY = Mathf.Lerp(fallStartY, originalYPosition, elapsedTime / jumpApexTime);
                float deltaYThisFrame = desiredY - transform.position.y;
                characterController.Move(new Vector3(0, deltaYThisFrame, 0));
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            characterController.Move(new Vector3(0, originalYPosition - transform.position.y, 0));
            isJumping = false;
            playerVelocity.y = -0.5f;
        }

        #endregion

        #region IPlayerService Members

        public Transform PlayerTransform => transform;

        #endregion
    }
}
