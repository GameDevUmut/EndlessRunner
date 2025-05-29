using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using R3;

namespace Interfaces
{
    public interface IGameService
    {
        ReactiveProperty<int> Timer { get; }

        Subject<Unit> GameEnded { get; }
        Subject<Unit> GameStarted { get; }
        
        void WaitForTask(UniTask task);
        
        void WaitForTasks(List<UniTask> tasks);

        void EndGame();

    }
}
