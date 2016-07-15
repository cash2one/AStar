package com.rpg.entity
{
	import com.rpg.framework.DrawableGameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IUpdateable;
	import com.rpg.framework.collections.ArrayCollection;
	

	public class GameSprite extends DrawableGameComponent
	{
		public var parent : GameSprite; // 父级游戏精灵
		private var _components : ArrayCollection; // 图层实体元件集合(GameElement)
		private var _currentlyUpdatingComponents : Array; // 绘制元件集合
		
		/**
		 * 游戏组件列表
		 *
		 */
		public function get components() : ArrayCollection
		{
			return _components;
		}

		public function GameSprite()
		{
			_components = new ArrayCollection();
			_components.added = onAdded;
		}

		private function onAdded(item : *) : void
		{
			item.initialize();
		}

		/**
		 * 添加一个可视化子组件
		 *
		 */
		public function addChild(item : GameSprite) : void
		{
			this.addChildAt(item, this.display.numChildren);
		}

		public function addChildAt(item : GameSprite, index : int) : void
		{
			item.parent = this;
			this.display.addChildAt(item.display, index);
			_components.add(item);
		}

		public function contains(item:GameSprite):Boolean{
			for each (var i:GameSprite in _components) 
			{
				if(i == item)
					return true;
			}
			return false;
		}
		
		/**
		 * 删除一个可视化子组件
		 *
		 */
		public function removeChild(item : GameSprite) : void
		{
			_components.remove(item);
			item.parent = null;
		}

		public override function update(gameTime : GameTime) : void
		{
			//_components.updateing = true;
			//_currentlyUpdatingComponents = _components.concat();
			for each (var updateable : IUpdateable in _components)
			{
				if (updateable.enabled)
				{
					updateable.update(gameTime);
				}
			}
		/*	if(_components)
				_components.updateing = false;*/
			//_currentlyUpdatingComponents = null;
		}

		/**
		 * 删除所有游戏子组件
		 *
		 */
		public function clear() : void
		{
			_components.clear();
		}

		public override function dispose() : void
		{
			_currentlyUpdatingComponents = null;
			if(_components != null){
				_components.dispose();
				_components = null;
			}
			parent = null;
			super.dispose();
		}

		public function get x() : Number
		{
			return this.display.x;
		}

		public function set x(value : Number) : void
		{
			this.display.x = value;
		}

		public function get y() : Number
		{
			return this.display.y;
		}

		public function set y(value : Number) : void
		{
			this.display.y = value;
		}

		public function get name() : String
		{
			return this.display.name;
		}

		public function set name(value : String) : void
		{
			this.display.name = value;
		}
	}
}
