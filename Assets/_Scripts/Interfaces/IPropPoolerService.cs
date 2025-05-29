using UnityEngine;

namespace Interfaces
{
    public interface IPropPoolerService
    {
        GameObject GetRandomBuilding();
        GameObject GetRandomVegetation();
        GameObject GetRandomRoadBlock();
        GameObject GetRandomProp();
    }
}
