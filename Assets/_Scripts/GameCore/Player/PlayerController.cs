using UnityEngine;
using System.Collections; // Required for Coroutines

namespace GameCore.Player
{
    public class PlayerController : MonoBehaviour
    {
        [SerializeField] private float moveSpeed = 5f;
        [SerializeField] private float laneMoveMargin = 3f; // Defines how far left/right a lane is from center
        [SerializeField] private float jumpDistance = 5f; // How high the character jumps relative to its starting Y
        [SerializeField] private CharacterController characterController;
        [SerializeField] private float laneChangeSpeed = 10f; // Speed of smoothly changing lanes
        [SerializeField] private float jumpApexTime = 0.4f; // Time to reach the peak of the jump (and also time to fall back)
        [SerializeField] private float gravityValue = -19.62f; // Custom gravity, e.g., 2 * Physics.gravity.y

        private float originalYPosition; // Cached Y position from Start
        private float targetXPosition;   // Current target X position for lane movement
        private bool isJumping = false;
        private Vector3 playerVelocity;  // Used for managing Y velocity (gravity)

        // Lane definitions
        private const int LEFT_LANE_INDEX = -1;
        private const int CENTER_LANE_INDEX = 0;
        private const int RIGHT_LANE_INDEX = 1;
        private int currentLaneIndex = CENTER_LANE_INDEX;

        void Start()
        {
            if (characterController == null)
            {
                characterController = GetComponent<CharacterController>();
            }
            originalYPosition = transform.position.y;
            targetXPosition = GetXPositionForLane(currentLaneIndex);
            // Initialize playerVelocity to ensure grounded state if starting slightly above ground
            playerVelocity.y = -2f;
        }

        void Update()
        {
            bool groundedPlayer = characterController.isGrounded;

            // --- Forward Movement (applied at the end) ---
            Vector3 forwardDisplacement = transform.forward * moveSpeed * Time.deltaTime;

            // --- Horizontal Movement ---
            float currentX = transform.position.x;
            // Smoothly interpolate towards the target X position
            float desiredXThisFrame = Mathf.Lerp(currentX, targetXPosition, laneChangeSpeed * Time.deltaTime);
            float horizontalDisplacementX = desiredXThisFrame - currentX;

            // --- Vertical Movement ---
            float verticalDisplacementY = 0f;
            if (isJumping)
            {
                // Y movement is exclusively handled by the PerformJumpCoroutine via its own characterController.Move calls.
                // No gravity or playerVelocity.y from Update loop during the jump's controlled phase.
            }
            else // Not in the controlled jump sequence
            {
                if (groundedPlayer)
                {
                    // If grounded and moving downwards (or just landed), reset Y velocity to a small negative value.
                    if (playerVelocity.y < 0)
                    {
                        playerVelocity.y = -0.5f; // Helps stick to the ground
                    }
                }
                else
                {
                    // Apply gravity if in the air and not jumping
                    playerVelocity.y += gravityValue * Time.deltaTime;
                }
                verticalDisplacementY = playerVelocity.y * Time.deltaTime;
            }

            // Combine all displacement components
            Vector3 totalDisplacement = new Vector3(horizontalDisplacementX, verticalDisplacementY, 0);
            totalDisplacement += forwardDisplacement; // Add forward movement (which is along Z for a non-rotated character)
                                                      // If character rotates, transform.TransformDirection for forward might be needed.
                                                      // Assuming character's local Z is world Z for simplicity here.

            characterController.Move(totalDisplacement);
        }

        private float GetXPositionForLane(int laneIndex)
        {
            if (laneIndex == LEFT_LANE_INDEX) return -laneMoveMargin;
            if (laneIndex == RIGHT_LANE_INDEX) return laneMoveMargin;
            return 0f; // Center lane (X position 0)
        }

        public void Jump()
        {
            // Only allow jumping if grounded and not already in a jump coroutine
            if (characterController.isGrounded && !isJumping)
            {
                StartCoroutine(PerformJumpCoroutine());
            }
        }

        private IEnumerator PerformJumpCoroutine()
        {
            isJumping = true;
            // playerVelocity.y is not set here; the coroutine directly controls Y position.

            float jumpStartY = transform.position.y; // Y position at the moment of starting the jump
            float peakY = jumpStartY + jumpDistance;

            // Ascent phase
            float elapsedTime = 0f;
            while (elapsedTime < jumpApexTime)
            {
                // Calculate desired Y based on smooth interpolation to peak
                float desiredY = Mathf.Lerp(jumpStartY, peakY, elapsedTime / jumpApexTime);
                // Calculate the delta Y movement for this frame for CharacterController
                float deltaYThisFrame = desiredY - transform.position.y;
                characterController.Move(new Vector3(0, deltaYThisFrame, 0));
                elapsedTime += Time.deltaTime;
                yield return null;
            }
            // Ensure character is exactly at peak Y (accounts for potential float inaccuracies)
            characterController.Move(new Vector3(0, peakY - transform.position.y, 0));

            // Descent phase (back to originalYPosition)
            elapsedTime = 0f;
            float fallStartY = transform.position.y; // Current Y at peak, should be peakY

            while (elapsedTime < jumpApexTime)
            {
                // Calculate desired Y based on smooth interpolation to originalYPosition
                float desiredY = Mathf.Lerp(fallStartY, originalYPosition, elapsedTime / jumpApexTime);
                // Calculate the delta Y movement for this frame
                float deltaYThisFrame = desiredY - transform.position.y;
                characterController.Move(new Vector3(0, deltaYThisFrame, 0));
                elapsedTime += Time.deltaTime;
                yield return null;
            }
            // Ensure character is exactly at originalYPosition
            characterController.Move(new Vector3(0, originalYPosition - transform.position.y, 0));

            isJumping = false;
            // After jump, ensure playerVelocity.y is reset to allow normal grounding/gravity behavior
            playerVelocity.y = -0.5f; // Helps ensure isGrounded becomes true quickly
        }

        public void Run()
        {
            // Character continuously runs via the Update method.
            // This method can be left empty or used for other run-related logic if needed in the future.
        }

        public void MoveLeft()
        {
            // Allow lane change only if not at the leftmost lane and preferably grounded (or allow mid-air change if desired)
            if (currentLaneIndex > LEFT_LANE_INDEX) // && characterController.isGrounded)
            {
                currentLaneIndex--;
                targetXPosition = GetXPositionForLane(currentLaneIndex);
            }
        }

        public void MoveRight()
        {
            // Allow lane change only if not at the rightmost lane
            if (currentLaneIndex < RIGHT_LANE_INDEX) // && characterController.isGrounded)
            {
                currentLaneIndex++;
                targetXPosition = GetXPositionForLane(currentLaneIndex);
            }
        }
    }
}
