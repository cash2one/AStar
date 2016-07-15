package com.rpg.framework.utils
{
	import com.rpg.framework.GameTime;
	
	/** 帧速控制组件 */
	public class Timer
	{
		private var previousHeartbeat : int;							// 上一次心跳记数
		private var currentHeartbeat  : int;							// 当前心跳记数
		private var elapsedRealTime   : int;							// 逝去时间
		private var _frequency        : uint; 							// 动画每秒帧速
		private var _distanceTime     : uint;							// 每次触发间隔时间

		public function Timer(time : int = 1000)
		{
			this.distanceTime = time;
		}
		
		/** 每次触发间隔时间 */
		public function get distanceTime() : uint
		{
			return _distanceTime;
		}
		public function set distanceTime(value : uint) : void
		{
			if (value > 0)
			{
				_distanceTime = value;
			}
			else
			{
				_distanceTime = 1;
			}
		}

		/** 每秒多少次（默认12次）*/
		public function get frequency() : uint
		{
			return _frequency;
		}

		public function set frequency(value : uint) : void
		{
			_frequency = value;
			distanceTime = 1 / _frequency * 1000;
		}
		
		public function reset():void{
			elapsedRealTime = 0;
		}

		/** 是否心跳一次 */
		public function heartbeat(gameTime : GameTime) : int
		{
			this.elapsedRealTime += gameTime.elapsedGameTime;
			if (this.elapsedRealTime >= this.distanceTime)
			{
				var count : int = this.elapsedRealTime / this.distanceTime;
				/*if(count > 0 && distanceTime == 50){
					trace(this,this.elapsedRealTime , this.distanceTime,count);
				}*/
				this.elapsedRealTime -= this.distanceTime * count;
				return count;
			}
			else
			{
				return 0;
			}
		}
	}
}