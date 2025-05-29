using System;
using System.Threading;
using Cysharp.Threading.Tasks;
using Interfaces;
using R3;
using UnityEngine;

namespace Managers
{
    public class GameManager : MonoBehaviour, IGameService
    {
        #region Fields

        private bool _gameEnded;

        private CancellationTokenSource _tokenSource;

        #endregion

        #region Unity Methods

        private void Start()
        {
            OnGameStart(_tokenSource.Token).Forget();
        }

        
        private void OnDestroy()
        {
            _tokenSource?.Cancel();
        }
        #endregion

        #region Private Methods

        private async UniTask OnGameStart(CancellationToken token)
        {
            GameStarted.OnNext(Unit.Default);

            while (!_gameEnded && !_tokenSource.Token.IsCancellationRequested)
            {
                try
                {
                    await UniTask.Delay(TimeSpan.FromSeconds(1), cancellationToken: token);
                    Timer.Value++;
                }
                catch (OperationCanceledException e)
                {
                    //on cancel
                    Debug.Log("Timer cancelled");
                    break;
                }
            }
        }

        #endregion

        #region IGameService Members

        public ReactiveProperty<int> Timer { get; private set; } = new ReactiveProperty<int>(0);

        public Subject<Unit> GameEnded { get; } = new Subject<Unit>();
        public Subject<Unit> GameStarted { get; } = new Subject<Unit>();

        public void EndGame()
        {
            _gameEnded = true;
            _tokenSource?.Cancel();
            GameEnded.OnNext(Unit.Default);
        }

        #endregion
    }
}
