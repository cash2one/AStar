package com.rpg.framework.system.transfer
{
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.utils.Vector2Extension;
	import com.rpg.pool.IPoolItem;
	import com.rpg.scene.actor.Monster;
	
	import flash.geom.Point;
	
	
	/** 平滑移动组件 */
	public class Tween extends GameComponent implements IPoolItem
	{

		public function get end():Point
		{
			return _end;
		}

		public var moveStep		: Function; 				 // 每移动完一格 
		public var moveComplete : Function; 				 // 移动完成事件
		public var moveBegin    : Function; 				 // 开始移动

		public var speed : Number; 							 // 移动速度	

		protected var _moveIncrement   : Point; 			 // 平滑移动增量
		protected var _movePoint 	   : Point; 			 // 要移动到的点
		protected var _start 	 	   : Point; 			 // 起始点
		protected var _end 	  		   : Point;			     // 目标点
		protected var _betweenDistance : Number; 			 // 两点之间的距离
		protected var _moveDistance    : Number; 			 // 已移动了的距离
		protected var _display 		   : ITweenAble; 	 // 移动对象
		protected var _path 		   : Array;				 // 多点移动路径
		protected var _direction 	   : int; 				 // 方向
		private var _lasttime:Number = 0;

		public function Tween(display :ITweenAble = null, speed : Number = 5)
		{
			_display  = display;
			this.speed = speed;
		}
		
		public function get display() : ITweenAble
		{
			return _display;
		}
		public function set display(value : ITweenAble) : void
		{
			_display = value;
		}

		/**
		 * 动态修改平移速度 
		 * @param speed 速度值
		 * 
		 */		
		public function setSpeed(speed : Number) : void
		{
			if (this.enabled)
			{
				this.speed = speed;
				_moveIncrement = Vector2Extension.moveIncrement(_start, _end, this.speed);
			}
		}
		
		public override function initialize():void
		{
			this.enabled = false;
		}

		/** 开始移动 */
		public function move(path : Array) : void
		{
			this.resetTween();
			// 最终必须移动到的点。坐标取整后也要移动到得点
			_path	   = path;
			_movePoint = new Point(_display.x, _display.y);

			// 获取下一格的目标点
			_start			 = new Point(_display.x, _display.y);
			_end       		 = _path.shift();
			_direction       = Vector2Extension.directionByTan(_start.x, _start.y, _end.x, _end.y); // 方向
			_moveIncrement   = Vector2Extension.moveIncrement(_start, _end, this.speed); 			// 平移偏移向量
			_betweenDistance = Point.distance(_start, _end);										// 两点距离
			this.enabled	 = true;
			
			// 开始移动
			if (moveBegin != null)
			{
				moveBegin(_direction);
			}
		}
		
		/** 平滑移动动画逻辑更新 */
		public override function update(gameTime : GameTime) : void
		{
			if(this.display is Monster){
				var monster:Monster = this.display as Monster;
				if(!monster.canProcess)
					return ;
			}
			/*if(this.display.uniform)
				frameCount = gameTime.elapsedGameTime / (1000 /60);
			else{*/
				var frame:Number = gameTime.elapsedGameTime / (1000 /60);
				//var last:Number = frame - int(frame);	// 超出帧数帧的先保存，+到下一帧计算
				/*var roundFrame:int = Math.max(1,Math.round(frame));
				if(frameCount < roundFrame && (int(_lasttime + frame) >= roundFrame || frameCount == 0)){
					var cost:Number = roundFrame-frame;
					frameCount = roundFrame;
					last = 0;
					_lasttime -= cost;
				}
				*/
				/*if(last > 0)
					_lasttime += last;*/
				if(frame > 2){//这是什么情况。。。这么卡？
					frame = 2;
				}
			//}
			
			
			//计算移动组件此次移动的坐标点
			_moveDistance += this.speed * frame;
			_movePoint.x  += _moveIncrement.x* frame;
			_movePoint.y  += _moveIncrement.y* frame;
			
			//移动完成
			if (this.enabled && (_moveDistance >= _betweenDistance || _display.endNow))
			{
				if(!_display.moveNext){
					_movePoint.x = _end.x;
					_movePoint.y = _end.y;
				}
				
				_display.x = _movePoint.x;
				_display.y = _movePoint.y;
				
				this.enabled = false;
				this.resetTween();
				
				if (moveComplete != null) 
				{
					moveComplete(gameTime.totalGameTime);
				}
			}
			else
			{
				_display.x = _movePoint.x;
				_display.y = _movePoint.y;
				
				if (moveStep != null)
				{
					moveStep();
				}
			}
		}

		protected function resetTween() : void
		{
			this.enabled		 = false;
			_moveDistance		 = 0;
			_betweenDistance 	 = 0;
			_moveIncrement 	     = null;
			_movePoint   	     = null;
			_start   	    	 = null;
			_end     	    	 = null;
			_path		  	     = null;
		}

		public function stop():void{
			resetTween();
		}
		
		public override function dispose() : void
		{
			this.moveBegin 	  = null;
			this.moveStep 	  = null;
			this.moveComplete = null;
			
			_moveIncrement 	  = null;
			_movePoint   	  = null;
			_start   	 	  = null;
			_end     	      = null;
			_path		  	  = null;
			_display          = null;
			
			super.dispose();
		}
		
		public function reset():void
		{
			this.dispose();
		}
		
	}
}
