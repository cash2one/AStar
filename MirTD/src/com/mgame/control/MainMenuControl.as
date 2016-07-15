package com.mgame.control
{
	import com.core.control.ViewControl;
	import com.core.inter.IControl;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:52:35
	 * 
	 */
	public class MainMenuControl extends ViewControl
	{
		public function MainMenuControl(view:Object)
		{
			super(view);
		}
		
		override public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.MAIN_MENU){
				switch(cmd){
					case CMDMain.SHOW:
						this._view.show();
						break;
					case CMDMain.HIDE:
						this._view.hide();
						break;
				}
			}
		}
	}
}