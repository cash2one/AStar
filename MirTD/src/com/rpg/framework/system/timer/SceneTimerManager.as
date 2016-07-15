/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.rpg.framework.system.timer {
	import com.rpg.enum.Constant;
	import com.rpg.framework.GameTime;
	import com.rpg.pool.ObjectPoolManager;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**时钟管理器[同一函数多次计时，默认会被后者覆盖,delay小于1会立即执行]*/
	public class SceneTimerManager {
		private var _handlers:Dictionary = new Dictionary();
		private var _currTimer:int = getTimer();
		private var _count:int = 0;
		private var _index:uint = 0;
		
		public function SceneTimerManager() {
			
		}
		
		public function onEnterFrame(gameTime:GameTime):void {
			_currTimer = gameTime.totalGameTime;
			for (var key:Object in _handlers) {
				var handler:TimerHandler = _handlers[key];
				var t:int = _currTimer;
				if (t >= handler.exeTime) {
					var method:Function = handler.method;
					var args:Array = handler.args;
					clearTimer(key);
					method.apply(null, args);
				}
			}
		}
		
		private function create(useFrame:Boolean, repeat:Boolean, delay:int, method:Function, args:Array = null):int {
			var key:int;
				key = _index++;
			
			//如果执行时间小于1，直接执行
			/*if (delay < 1) {
				method.apply(null, args)
				return -1;
			}*/
			var handler:TimerHandler = ObjectPoolManager.getInstance().borrowItem(Constant.TimerHandlerClass) as TimerHandler;
			handler.delay = delay;
			handler.method = method;
			handler.args = args;
			handler.exeTime = delay + _currTimer;
			_handlers[key] = handler;
			_count++;
			return key;
		}
		
		/**定时执行一次
		 * @param	delay  延迟时间(单位毫秒)
		 * @param	method 结束时的回调方法
		 * @param	args   回调参数
		 * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
		 * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
		public function doOnce(delay:int, method:Function, args:Array = null):int {
			return create(false, false, delay, method, args);
		}
		
		/**定时器执行数量*/
		public function get count():int {
			return _count;
		}
		
		/**清理定时器
		 * @param	method 创建时的cover=true时method为回调函数本身，否则method为返回的唯一ID
		 */
		public function clearTimer(method:Object):void {
			var handler:TimerHandler = _handlers[method];
			if (handler != null) {
				delete _handlers[method];
				handler.clear();
				ObjectPoolManager.getInstance().returnItem(Constant.TimerHandlerClass,handler);
				_count--;
			}
		}
		
		/**
		 * 切换场景，全部清理
		 */
		public function clearAll():void{
			for (var key:Object in _handlers) {
				clearTimer(key);
			}
		}
	}
}

