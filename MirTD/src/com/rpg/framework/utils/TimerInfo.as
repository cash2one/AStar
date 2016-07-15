package com.rpg.framework.utils
{
	import com.sh.game.pool.IPoolItem;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-6-15 下午4:08:39
	 * 
	 */
	public class TimerInfo implements IPoolItem
	{
		public function TimerInfo()
		{
		}
		public var id:uint;
		public var func:Function;
		public var arg:Array;
		
		public function init(id:int,func:Function,arg:Array):void{
			this.id = id;
			this.arg = arg;
			this.func = func;
		}
		
		public function doit():void{
			if(func != null){
				func.apply(null,arg);
				TimeOutManager.getInstance().clearTimer(this.id);
			}
		}
		
		public function reset():void{
			this.clear();
		}
		
		public function dispose():void{
			this.clear();
		}
		
		public function clear():void{
			if(id > 0){
				clearTimeout(id);
				id = 0;
				this.arg = null;
				func = null;
			}
		}
	}
}