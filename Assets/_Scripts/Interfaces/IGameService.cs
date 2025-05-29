using R3;

namespace Interfaces
{
    public interface IGameService
    {
        ReactiveProperty<int> Timer { get; }

        Subject<Unit> GameEnded { get; }
        Subject<Unit> GameStarted { get; }

        void EndGame();

    }
}
