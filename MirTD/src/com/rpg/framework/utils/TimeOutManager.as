package com.rpg.framework.utils
{
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.timer.SceneTimerManager;
	
	
	import flash.utils.setTimeout;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-6-15 下午4:04:26
	 * 
	 */
	public class TimeOutManager
	{
		public function TimeOutManager()
		{
			_timer2 = new SceneTimerManager();
		}
		
		private static var _instance:TimeOutManager;
		
		private var _timers:Object = new Object();
		private var _timer2:SceneTimerManager;
		
		public static function getInstance():TimeOutManager{
			if(!_instance)
				_instance = new TimeOutManager();
			return _instance;
		}
		
		public function update(gameTime:GameTime):void{
			this._timer2.onEnterFrame(gameTime);
		}
		
		public function setTimer(func:Function,time:Number,...arg):int{
			/*var info:TimerInfo = ObjectPoolManager.getInstance().borrowItem(Constant.TimerClass) as TimerInfo;
			var id:int = setTimeout(info.doit,time);
			info.init(id,func,arg);
			this._timers[info.id] = info;*/
			return _timer2.doOnce(time,func,arg);
			//return info.id;
		}
		
		public function clearTimer(id:int):void{
			_timer2.clearTimer(id);
			/*var info:TimerInfo = this._timers[id];
			if(info != null){
				ObjectPoolManager.getInstance().returnItem(Constant.TimerClass,info);
				delete this._timers[id];
			}*/
		}
		
		public function clearAll():void{
			_timer2.clearAll();
			/*for (var key:String in _timers) 
			{
				clearTimer(int(key));
			}*/
			
		}
	}
}