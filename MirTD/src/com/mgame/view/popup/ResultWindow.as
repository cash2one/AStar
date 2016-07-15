package com.mgame.view.popup
{
	import com.core.Facade;
	import com.mgame.view.BaseView;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-6 下午3:04:38
	 * 
	 */
	public class ResultWindow extends BaseView
	{
		public function ResultWindow(container:Object)
		{
			super(container);
			init();
		}
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.result") as Class;
			this._view = new cls();
			_view.x = 260;
			_view.y = 170;
			initEvents();
			(_view.linktxt as TextField).setTextFormat(new TextFormat("宋体",14,0x00ff00,null,null,1));
		}
		
		private function initEvents():void{
			(this._view.backBtn as SimpleButton).addEventListener(MouseEvent.CLICK,backHandler);
		}
		
		private function backHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.LEVEL_SELECT);
			Facade.instance.sendNotification(ControlGroup.RESULT_WINDOW,CMDMain.HIDE);
		}
		
		public function change(i:int):void{
			this._view.gotoAndStop(i);
		}
		
	}
}