using System;
using DG.Tweening;
using Interfaces;
using TMPro;
using UI.Game.InGamePopups;
using UnityEngine;
using VContainer;
using R3;

namespace UI.Game
{
    public class GameUI : MonoBehaviour
    {
        [SerializeField] private GameOverPopup gameOverPopup;
        [SerializeField] private TMP_Text timerText;
        [SerializeField] private TMP_Text distanceText;
        
        private IGameService _gameService;
        private IPlayerService _playerService;
        private Color _timerOriginalColor;

        [Inject]
        private void Construct(IGameService gameService, IPlayerService playerService)
        {
            _playerService = playerService;
            _gameService = gameService;
        }

        private void Awake()
        {
            _timerOriginalColor = timerText.color;
        }

        private void Start()
        {
            SubscribeToTimer();
            SubscribeToDistanceTravelled();
            SubscribeToGameOver();
        }
        
        private void SubscribeToGameOver()
        {
            _gameService.GameEnded.Subscribe(_ =>
            {
                gameOverPopup.ShowPopup();
            });
        }

        private void SubscribeToDistanceTravelled()
        {
            _playerService.DistanceTravelled.Subscribe(distance =>
            {
                distanceText.text = $"Distance: {distance} m";
            });
        }

        private void SubscribeToTimer()
        {
            _gameService.Timer.Subscribe(timer =>
            {
                var timeSpan = TimeSpan.FromSeconds(timer);
                timerText.text = $"{timeSpan.Minutes:D2}:{timeSpan.Seconds:D2}";

                //red flash
                DOTween.Sequence().Append(timerText.DOColor(Color.red, 0.2f))
                    .Append(timerText.DOColor(_timerOriginalColor, 0.2f)).SetEase(Ease.InOutQuad);
            });
        }
        
        
    }
}
