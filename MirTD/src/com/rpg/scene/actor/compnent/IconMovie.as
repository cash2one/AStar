package com.rpg.scene.actor.compnent
{
	import com.rpg.entity.animation.AnimationEventArgs;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IUpdateable;
	import com.rpg.framework.utils.Timer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-5-25 下午4:00:44
	 * 
	 */
	public class IconMovie extends Sprite implements IUpdateable
	{
		private var _bmps: Vector.<BitmapData>;
		protected var _timer      		  : Timer;							// 动画播放速度控制
		protected var _animationArgs      : AnimationEventArgs;				// 事件参数据
		protected var _playMaxCount		  : int;							// 最大已播放次数
		private var _playCount		   	  : int;							// 已播放次数
		private var _rx:int;
		private var _ry:int;
		private var _bitmap:Bitmap;
		public var data:Object;
		private var _enabled:Boolean = false;
		
		public function IconMovie(vector:Vector.<BitmapData>,rx:int,ry:int,intval:int = 100,playMaxCount : int = -1)
		{
			super();
			_playMaxCount 		  = playMaxCount;
			_bmps = vector;
			_animationArgs 		  = new AnimationEventArgs();
			_animationArgs.clipTotalFrameCount = vector.length;
			_timer  			  = new Timer();
			_timer.distanceTime = intval;
			_bitmap = new Bitmap();
			this.addChild(_bitmap);
			_bitmap.x = -rx;
			_bitmap.y = -ry;
			this._rx = rx;
			this._ry = ry;
			if(vector.length > 0)
				this.setFrame(0);
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}

		/** 暂停动画 */
		public function pause() : void
		{
			if (this.enabled == true)
			{
				this.enabled = false;
			}
			else
			{
				this.enabled = true;
			}
		}
		
		/** 动画帧更新新 */
		public function update(gameTime : GameTime) : void
		{
			if (_timer.heartbeat(gameTime))
			{
				if ((_playMaxCount == AnimationPlayer.LOOP || _playCount < _playMaxCount))
				{
					// 当前影片剪辑动画指针递增
					_animationArgs.clipFrameIndex++;
					
					// 判断是否进去下一个动画循环
					if (_animationArgs.clipFrameIndex >= _animationArgs.clipTotalFrameCount)
					{
						_animationArgs.clipFrameIndex = 0;
						_playCount++;
						this.playComplete(_animationArgs);
					}
					
					if (_playMaxCount == AnimationPlayer.LOOP || _playCount < _playMaxCount)
					{
						this.setFrame(_animationArgs.clipFrameIndex);
						//this.playFrame(_animationArgs);
					}
					else
					{
						this.enabled = false;
					}
				}
			}
		}
		
		private function setFrame(clipFrameIndex:int):void
		{
			if(_bitmap){
				_bitmap.bitmapData = this._bmps[clipFrameIndex];
			}
		}
		
		private function playComplete(_animationArgs:AnimationEventArgs):void
		{
			
		}
		
		public function dispose():void{
			if(_bitmap && _bitmap.parent){
				_bitmap.parent.removeChild(_bitmap);
				_bitmap.bitmapData = null;
				_bitmap = null;
			}
			if(_animationArgs)
				_animationArgs = null;
			this._bmps = null;
			this._enabled = false;
		}
	}
}