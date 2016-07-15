package com.rpg.framework
{
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.IDrawable;
	
	import flash.display.Sprite;
	
	//import oops.framework.content.provider.BulkLoaderResourceProvider;

	/** 游戏可视组件模板 */
	public class DrawableGameComponent extends GameComponent implements IDrawable
	{
		//protected var _resourceProviderEntity : BulkLoaderResourceProvider; 	// 资源提供器
		protected var _initialized		      : Boolean; 						// 是否初始化完成
		private var _visible     			  : Boolean;
		private var _display    			  : Sprite;
		
		public function DrawableGameComponent()
		{
			_display = new Sprite();
			_display.mouseEnabled  = false;
			_display.mouseChildren = false;
		}
		
		public override function initialize() : void
		{
			if (!_initialized)
			{
				//this.loadContent();
				this.loadContent();
				/*if (_resourceProviderEntity == null) // 没有需要加载的资源
				{
					this.loadContent();
				}
				else
				{
					_resourceProviderEntity.loadComplete = loadContent;
					_resourceProviderEntity.load();
				}*/
			}
			_initialized = true;
		}
		
		/** 资源加载完成 */
		protected function loadContent() : void
		{
			this.enabled = true; 	// 资原加载完成后，逻辑更新在主游戏循环中执行
		}
		
		public override function dispose() : void
		{
			_visible = false;

			/*if (_resourceProviderEntity != null)
			{
				_resourceProviderEntity.dispose();
				_resourceProviderEntity = null;
			}*/
			super.dispose();
			if(_display != null){
				if(_display.parent)
					_display.parent.removeChild(_display);
				_display = null;
			}
		}

		/** 游戏组件是否可见 */
		public function get visible() : Boolean
		{
			return _display.visible;
		}

		public function set visible(value : Boolean) : void
		{
			_display.visible = value;
		}
		
		public function get display() : Sprite
		{
			return _display;
		}
	}
}
