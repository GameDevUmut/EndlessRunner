using System;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using Interfaces;
using R3;
using UnityEngine;
using VContainer;

namespace Managers
{
    public class GameManager : MonoBehaviour, IGameService
    {
        #region Fields

        private bool _gameEnded;
        private ISceneLoadService _sceneLoadService;
        private List<UniTask> _tasksBeforeGameStart = new List<UniTask>();
        private CancellationTokenSource _tokenSource;

        #endregion

        #region Unity Methods

        private void Awake()
        {
            _tokenSource = new CancellationTokenSource();
            Timer.Value = 0;
        }

        private async void Start()
        {
            await UniTask.WhenAll(_tasksBeforeGameStart);
            _sceneLoadService.ToggleLoadingScreen(false);
            OnGameStart(_tokenSource.Token).Forget();
        }


        private void OnDestroy()
        {
            _tokenSource?.Cancel();
        }

        #endregion

        #region Private Methods

        [Inject]
        private async void Construct(ISceneLoadService sceneLoadService)
        {
            _sceneLoadService = sceneLoadService;
        }

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

        public void WaitForTask(UniTask task)
        {
            _tasksBeforeGameStart.Add(task);
        }

        public void WaitForTasks(List<UniTask> tasks)
        {
            _tasksBeforeGameStart.AddRange(tasks);
        }

        public void EndGame()
        {
            _gameEnded = true;
            _tokenSource?.Cancel();
            GameEnded.OnNext(Unit.Default);
        }

        #endregion
    }
}
