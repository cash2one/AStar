package com.rpg.framework.system.transfer
{
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.utils.Vector2Extension;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	public class Parabola extends GameComponent
	{
		public var moveStep		: Function; 				 // 每移动完一格 
		public var moveComplete : Function; 				 // 移动完成事件
		public var moveBegin    : Function; 				 // 开始移动
		
		public var height  : int = 100;					 	 // 跳跃高度
		public var time	   : int = 800;						 // 跳跃浮空时间
		
		protected var _moveIncrement   : Point; 			 // 平滑移动增量
		protected var _movePoint 	   : Point; 			 // 要移动到的点
		protected var _start 	 	   : Point; 			 // 起始点
		protected var _end 	  		   : Point;			     // 目标点
		protected var _betweenDistance : Number; 			 // 两点之间的距离
		protected var _display 		   : DisplayObject; 	 // 移动对象

		private var _a : Number;
		private var _b : Number;
		private var _c : Number;
		private var _elapseTime : int;
		private var _isParabola : Boolean;

		/**
		 * 抛物线移动 
		 * @param display		显示对象
		 * @param isParabola	是否抛物线移动
		 * 
		 */		
		public function Parabola(display : DisplayObject = null, isParabola : Boolean = true)
		{
			_display    = display;
			_isParabola = isParabola;
		}
		
		public function move(path : Point) : void
		{
			this.reset();
			
			// 最终必须移动到的点。坐标取整后也要移动到得点
			_movePoint		 = new Point(_display.x, _display.y);
			_start 	   		 = new Point(_display.x, _display.y);
			_end        	 = path;
			_moveIncrement	 = new Point(_end.x - _start.x, _end.y - _start.y);
			_betweenDistance = Point.distance(_start, _end); 	// 两点距离			
			if (_betweenDistance == 0)							// 抛物线两端距离为 0时，默认距离为抛物线的高
			{
				_betweenDistance = this.height;
			}
			
			this.getParabolaABC();
			this.enabled = true;
			
			// 开始移动
			if (moveBegin != null)
			{
				moveBegin(Vector2Extension.directionByTan(_start.x, _start.y, _end.x, _end.y));
			}
		}
		
		public override function initialize():void
		{
			this.enabled = false;
		}

		public override function update(gameTime : GameTime) : void
		{
			_elapseTime += gameTime.elapsedGameTime;
			
			if(_elapseTime < this.time)
			{
				var timeRatio : Number    = _elapseTime / this.time;
				var moveDistance : Number = _betweenDistance * timeRatio;
				var offset : Number       = _a * (moveDistance * moveDistance) + _b * moveDistance + _c - height;
			
				//计算移动组件此次移动的坐标点
				_movePoint.x  = _start.x + _moveIncrement.x * timeRatio;
				_movePoint.y  = _start.y + _moveIncrement.y * timeRatio;
				
				_display.x = _movePoint.x;
				_display.y = _movePoint.y + (_isParabola ? offset : 0);

				if (moveStep != null)
				{
					moveStep(_moveIncrement);
				}
			}
			else
			{
				_movePoint.x = _end.x;
				_movePoint.y = _end.y;
				
				_display.x = _movePoint.x;
				_display.y = _movePoint.y;
				
				this.enabled = false;
				this.reset();
				
				if (moveComplete != null) 
				{
					moveComplete();
				}
			}
		}

		private function getParabolaABC() : void
		{
			var start : Point   = new Point(0, this.height);
			var end : Point     = new Point(_betweenDistance, this.height);
			var highest : Point = new Point(_betweenDistance / 2, 0);
			
			_b = ((start.y - end.y) * (start.x * start.x - highest.x * highest.x) - (start.y - highest.y) * (start.x * start.x - end.x * end.x)) / ((start.x - end.x) * (start.x * start.x - highest.x * highest.x) - (start.x - highest.x) * (start.x * start.x - end.x * end.x));
			_a = ((start.y - highest.y) - _b * (start.x - highest.x)) / (start.x * start.x - highest.x * highest.x);
			_c = start.y - _a * start.x * start.x - _b * start.x;
		}
		
		protected function reset() : void
		{
			_elapseTime      = 0;
			_betweenDistance = 0;
			_moveIncrement   = null;
			_movePoint 		 = null;
			_start			 = null;
			_end 			 = null;			   
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
			_display          = null;
			
			super.dispose();
		}
		
		public function get display() : DisplayObject
		{
			return _display;
		}
		public function set display(value : DisplayObject) : void
		{
			_display = value;
		}
	}
}