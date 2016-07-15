package com.mgame.view
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 上午9:36:00
	 * 
	 */
	public class BaseView
	{
		protected var _container:Object;
		protected var _view:Object;
		protected var _visible:Boolean = false;
		public function BaseView(container:Object)
		{
			this._container = container;
		}
		
		
		public function get container():Object
		{
			return _container;
		}

		public function set container(value:Object):void
		{
			_container = value;
		}

		public function show():void{
			if(_view)
				this._container.addChild(_view);
			_visible = true;
		}
		
		public function hide():void{
			if(_view && _view.parent)
				this._container.removeChild(_view);
			_visible = false;
		}
	}
}