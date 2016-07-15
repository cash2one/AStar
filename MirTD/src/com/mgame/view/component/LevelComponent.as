package com.mgame.view.component
{
	import com.core.Facade;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import util.FilterSet;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 下午1:09:36
	 * 关卡选择组件
	 */
	public class LevelComponent extends Sprite
	{
		private var _view:Object;
		private var _cfg:Object;
		private var _selected:Boolean = false;
		private var _enabled:Boolean = true;
		public function LevelComponent(cfg:Object)
		{
			super();
			_cfg = cfg;
			init();
		}
		
		public function get data():Object{
			return _cfg;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if(this._cfg.open != 1 && value)
				return;
			_enabled = value;
			this._view.lock.visible = !value;
			updateFilter();
		}

		/**
		 *是否选中 
		 * @return 
		 * 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateFilter();
		}

		private function updateFilter():void{
			if(!this._enabled){
				this.filters = [FilterSet.GrayFilter];
			}else if(this._selected){
				this.filters = [FilterSet.lvSelectFilter];
			}else
				this.filters = [];
		}
		
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.LevelEle") as Class;
			this._view = new cls();
			this.addChild(_view as DisplayObject);
			this._view.leveltxt.text = this._cfg.name;
			var bmp:BitmapData = Resource.getRes("png.map" + _cfg.img) ;
			if(bmp){
				while(this._view.mapCon.numChildren > 0){
					this._view.mapCon.removeChildAt(0);
				}
				var bitmap:Bitmap = new Bitmap(bmp);
				this._view.mapCon.addChild(bitmap);
				bitmap.width = 127;
				bitmap.height = 82;
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN,selectHandler);
			if(this._cfg.open != 1)
				this.enabled = false;
		}
		
		/**
		 *选择关卡 
		 * @param e
		 */
		private function selectHandler(e:MouseEvent):void{
			if(this._enabled){
				if(!this._selected)
					Facade.instance.sendNotification(ControlGroup.LEVEL_SELECT,CMDMain.USER_SELECT_LEVEL,_cfg.id);	
			}
		}
		
		public function dispose():void{
			this.enabled = false;
			this.selected = false;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,selectHandler);
			_view = null;
			_cfg = null;
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
	}
}