package com.mgame.control
{
	import com.core.control.ViewControl;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-6 下午3:10:26
	 * 
	 */
	public class ResultWinControl extends ViewControl
	{
		public function ResultWinControl(view:Object)
		{
			super(view);
		}
		
		override public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.RESULT_WINDOW){
				switch(cmd){
					case CMDMain.SHOW:
						this._view.show();
						this._view.change(data);
						break;
					case CMDMain.HIDE:
						this._view.hide();
						break;
				}
			}
		}
	}
}