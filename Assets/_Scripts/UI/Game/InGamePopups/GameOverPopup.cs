using System;
using Interfaces;
using TMPro;
using UnityEngine;
using VContainer;

namespace UI.Game.InGamePopups
{
    public class GameOverPopup : MonoBehaviour
    {
        #region Serializable Fields

        [SerializeField] private TMP_Text timeAchievedText;
        [SerializeField] private TMP_Text distanceTravelledText;

        #endregion

        #region Fields

        private IGameService _gameService;

        private ISceneLoadService _sceneLoadService;
        private IPlayerService _playerService;

        #endregion

        #region Public Methods

        public void ShowPopup()
        {
            gameObject.SetActive(true);
            var timeSpan = TimeSpan.FromSeconds(_gameService.Timer.Value);
            timeAchievedText.text = $"{timeSpan.Minutes:D2}:{timeSpan.Seconds:D2}";
            distanceTravelledText.text = $"Distance: {_playerService.DistanceTravelled.Value} m";
        }

        public void OnMainMenuButtonClick()
        {
            _sceneLoadService.UnloadLast();
            _sceneLoadService.Load(ISceneLoadService.SceneName.MainScene);
        }

        #endregion

        #region Private Methods

        [Inject]
        private void Construct(ISceneLoadService sceneLoadService, IGameService gameService, IPlayerService playerService)
        {
            _playerService = playerService;
            _gameService = gameService;
            _sceneLoadService = sceneLoadService;
        }

        #endregion
    }
}
