package com.rpg.framework.system.timer
{
	import com.rpg.pool.IPoolItem;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-3 下午5:59:45
	 * 
	 */
	/**定时处理器*/
	public class TimerHandler implements IPoolItem {
		/**执行间隔*/
		public var delay:int;
		/**执行时间*/
		public var exeTime:int;
		/**处理方法*/
		public var method:Function;
		/**参数*/
		public var args:Array;
		
		/**清理*/
		public function clear():void {
			method = null;
			args = null;
		}
		
		public function reset():void{
			clear();
		}
		public function dispose():void{
			clear();
		}
	}
}