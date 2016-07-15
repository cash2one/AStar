package com.core.control
{
	import com.core.inter.IControl;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:56:21
	 * 
	 */
	public class ViewControl implements IControl
	{
		protected var _view:Object;
		public function ViewControl(view:Object)
		{
			_view = view;
		}
		
		public function update(group:int, cmd:int, data:*):void
		{
		}
	}
}