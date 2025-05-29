using GameCore.RandomizedPropSystem;
using Interfaces;
using VContainer;
using VContainer.Unity;

namespace SceneScopes
{
    public class GamesceneLifetimeScope : LifetimeScope
    {
        private PropPooler propPooler;
        protected override void Configure(IContainerBuilder builder)
        {
            builder.RegisterInstance(propPooler).As<IPropPoolerService>();
        }
    }
}
