package com.mgame.view
{
	import com.core.Facade;
	import com.mgame.model.PlayerData;
	import com.mgame.view.component.TianfuItem;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-8 上午11:12:04
	 * 
	 */
	public class TianFuView extends BaseView
	{
		
		public function TianFuView(container:Object)
		{
			super(container);
			init();
		}
		private var _items:Dictionary = new Dictionary();
		
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.tianfuView") as Class;
			this._view = new cls();
			//initItems();
			initEvents();
		}
		
		public function setGold(gold:int):void{
			this._view.goldtxt.text = gold;
		}
		
		private function initEvents():void{
			(this._view.backBtn as SimpleButton).addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.LEVEL_SELECT);
		}
		
		public function setItemLv(id:int,lv:int):void{
			var item:TianfuItem = this._items[id];
			if(item)
				item.setLevel(lv);
		}
		
		public function initItems():void{
			var tianfuarr:Array = PlayerData.Tianfu;
			var tianfudata:Object = PlayerData.getTianfu();
			for (var i:int = 0; i < tianfuarr.length; i++) 
			{
				var cfg:Object = tianfuarr[i];
				var item:TianfuItem = new TianfuItem(cfg);
				this._view.addChild(item);
				_items[cfg.id] = item;
				item.setLevel(tianfudata[cfg.id]);
				item.x = int(i / 4) * 350 + 90;
				item.y = int(i%4) * 120 + 50;
			}
		}
	}
}