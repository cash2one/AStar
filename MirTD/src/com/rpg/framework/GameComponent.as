package com.rpg.framework
{
	/** 游戏逻辑组件模板 */
	public class GameComponent implements IGameComponent, IUpdateable, IDisposable
	{
		public var disposed  : Function;
		
		protected var _enabled : Boolean = false;

		public function GameComponent()
		{
			//_game = Game.instance;
		}

		public function initialize() : void
		{
			_enabled = true;
		}

		public function update(gameTime : GameTime) : void
		{
			
		}

		public function dispose() : void
		{
			_enabled = false;
			//_game = null; // 经验：在删除此对象引用时，有可能别的对象正在引用它而报错，所以在开发时要注意这点。

			if (disposed != null)
			{
				disposed();
				this.disposed = null;
			}
		}

		/*public function get game() : Game
		{
			return _game;
		}*/

		/** 是否启用游戏更新 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
		}
	}
}
