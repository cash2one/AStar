package com.sh.game.util
{
	import flash.utils.Dictionary;

	/**
	 * 秒表
	 * @author Administrator
	 * 
	 */
	public class SecondTimerUtil
	{
		public function SecondTimerUtil()
		{
			_tasks = new Dictionary();
		}
		
		private static var _instance:SecondTimerUtil = null;
		
		public static function get instance():SecondTimerUtil{
			if(_instance == null){
				_instance = new SecondTimerUtil();
			}
			return _instance;
		}
		
		private var _tasks:Dictionary;
		private var _lastTime:Number;
		private var __id:int = 0;
		
		public function addSecondTask(func:Function):int{
			__id++;
			this._tasks[__id] = func;
			return __id;
		}
		
		public function removeTask(id:int):void{
			if(id in this._tasks){
				this._tasks[id] = null;
				delete this._tasks[id];
			}
		}
		
		public function length():int{
			var count:int = 0;
			for each (var o:Object in _tasks) 
			{
				count++;
			}
			return count;
		}
		
		public function update():void{
			var now:Number = new Date().getTime();
			if(!_lastTime){
				_lastTime = now;
				return;
			}
			var passed:Number = now - _lastTime ;
			var count:int = 10;//卡住一次执行不超过10次,放到下次执行。。防止崩溃
			while(passed > 1000 && count > 0){
				for each(var task:Object in _tasks){
					if(task != null)
						task();
				}
				passed -= 1000;
				count--;
			}
			_lastTime = now - passed;
		}
	}
}