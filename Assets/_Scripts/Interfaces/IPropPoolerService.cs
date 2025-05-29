using Addler.Runtime.Core.Pooling;
using Cysharp.Threading.Tasks;

namespace Interfaces
{
    public interface IPropPoolerService
    {
        PooledObject GetRandomBuilding();
        PooledObject GetRandomVegetation();
        PooledObject GetRandomRoadBlock();
        PooledObject GetRandomProp();

        UniTaskCompletionSource<bool> WarmupCompletion { get; }
    }
}
