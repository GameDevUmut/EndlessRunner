using GameCore.Player;
using GameCore.RandomizedPropSystem;
using Interfaces;
using UnityEngine;
using VContainer;
using VContainer.Unity;

namespace SceneScopes
{
    public class GamesceneLifetimeScope : LifetimeScope
    {
        [SerializeField] private PropPooler propPooler;
        [SerializeField] private PlayerController playerController;
        protected override void Configure(IContainerBuilder builder)
        {
            builder.RegisterInstance(propPooler).As<IPropPoolerService>();
            builder.RegisterInstance(playerController).As<IPlayerService>();
        }
    }
}
