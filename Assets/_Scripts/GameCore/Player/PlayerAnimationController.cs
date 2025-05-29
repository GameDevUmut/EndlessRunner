using UnityEngine;

namespace GameCore.Player
{
    public class PlayerAnimationController : MonoBehaviour
    {
        [SerializeField] private Animator animator;
        
        public void SetJumpState(bool isJumping)
        {
            if (animator == null) return;
            animator.SetBool("Grounded", !isJumping);
        }
            
    }
}
