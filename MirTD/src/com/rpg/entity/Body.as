package com.rpg.entity
{
	import com.rpg.enum.ActionType;
	
	public class Body extends ElementBase
	{
		/** 人物当前动做状态 */
		public var action     : int = ActionType.STAND;
		protected var _bodySkin:BodySkin;
		
		public function Body()
		{
			super();
			_bodySkin =  _skin as BodySkin;
		}
		
		/**
		 * 修改人物外貌行为
		 * @param action 动作类型
		 * @param force  是否强制转换动做
		 *
		 */
		public function setAction(action :int, dir:int = -1,compulsory : Boolean = false) : void
		{
			this.action = action;
			if(dir != -1)
				this.direction = dir;
			if (_bodySkin)
			{
				_bodySkin.setAction(compulsory);
			}
		}
		
		public function set dir(value:int):void{
			if(this.direction != value){
				this.direction = value;
				this.setAction(action,direction);
			}
		}
	}
}