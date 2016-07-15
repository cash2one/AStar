package com.mgame.view
{
	import com.core.Facade;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:45:01
	 * 
	 */
	public class MainMenu extends BaseView
	{
		public function MainMenu(container:Object)
		{
			super(container);
			init();
		}
		
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.MainMenu") as Class;
			this._view = new cls();
			initEvents();
		}
		
		private function initEvents():void{
			(this._view.startBtn as SimpleButton).addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(mouseEvent:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.LEVEL_SELECT);
		}
	}
}