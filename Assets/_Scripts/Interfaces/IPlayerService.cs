using R3;
using UnityEngine;

namespace Interfaces
{
    public interface IPlayerService
    {
        Transform PlayerTransform { get; }
        
        ReactiveProperty<int> DistanceTravelled { get; }
    }
}
