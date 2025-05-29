using Addler.Runtime.Core.Pooling;

namespace Interfaces
{
    public interface IPropPoolerService
    {
        PooledObject GetRandomBuilding();
        PooledObject GetRandomVegetation();
        PooledObject GetRandomRoadBlock();
        PooledObject GetRandomProp();
    }
}
