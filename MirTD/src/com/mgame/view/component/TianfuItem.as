package com.mgame.view.component
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-8 上午11:07:35
	 * 
	 */
	public class TianfuItem extends Sprite
	{
		private var _lvTxt:TextField;
		private var _nameTxt:TextField;
		private var _descTxt:TextField;
		private var _view:Object;
		private var _tianfu:Object;
		private var _goldTxt:TextField;
		public function TianfuItem(tianfu:Object)
		{
			super();
			this._tianfu = tianfu;
			init();
		}
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.tianfuItem") as Class;
			_view = new cls();
			this._lvTxt = _view.lvTxt;
			this._nameTxt = _view.nameTxt;
			this._descTxt = _view.descTxt;
			this._goldTxt = _view.goldTxt;
			this._nameTxt.text = _tianfu.name;
			this._descTxt.text = _tianfu.desc;
			this._goldTxt.text = "0";
			this.addChild(_view as DisplayObject);
			(this._view.addBtn as SimpleButton).addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		public function setLevel(lv:int):void{
			var cfg:Object = ConfigData.allCfgs[ConfigData.TIANFU];
			var id:int = this._tianfu.id;
			if(cfg[id][lv + 1]){
				this._goldTxt.text = cfg[id][lv + 1].gold;
			}else{
				this._goldTxt.text = "--";
			}
			this._lvTxt.text = "Lv." + lv ;
		}
		
		private function clickHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.TIANFU_VIEW,CMDMain.TIANFU_ADD,this._tianfu);
		}
	}
}