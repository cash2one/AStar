package com.rpg.entity
{
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.transfer.Tween;
	import com.rpg.framework.utils.Vector2Extension;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * 英雄 平滑移动组件
	 *
	 */
	public class AnimalTween extends Tween
	{
		public var moveNode : Function; 		// 每移动一步
		
		public function AnimalTween(displayObject : DisplayObject, speed : int = 5)
		{
			super(displayObject, speed);
		}
		
		public override function update(gameTime : GameTime) : void
		{				
			// 当前移动距离大于或等于总距离 走了1格
			var direction : int;
			var distance  : Number;		
			
			if (_moveDistance >= _betweenDistance)
			{
				if (_path && _path.length > 0)
				{
					// 再次获取一个目标点
					_start    	   = _end;
					_end     	   = _path.shift();					
					distance	   = Point.distance(_start, _end); 	// 下一节点距离（Ａ＊格横向60，纵向30，斜向33.54)
					direction      = Vector2Extension.directionByTan(_start.x, _start.y, _end.x, _end.y); // 下一节点方向
					_moveIncrement = Vector2Extension.moveIncrement(_start, _end, speed); 			 	  // 转向后要计算新每步偏移量
				
					// 不同方向的计算
					if (_direction == direction) // 同一方向（把要走的距离加上新距离）
					{
						_betweenDistance += distance;
					}
					else 						// 不同方向
					{
						_direction   	 = direction;
						_movePoint.x 	 = _start.x;
						_movePoint.y 	 = _start.y;
						_betweenDistance = Point.distance(_start, _end);
						_moveDistance 	 = 0;
					}
				}

				if (moveNode != null)
				{
					moveNode(_direction);
				}
			}			
			
			//移动完成
			if (_moveDistance >= _betweenDistance)
			{
				_display.x  = _end.x;
				_display.y  = _end.y;
				reset();
				
				if (moveComplete != null)
				{
					moveComplete();
				}
			}
			else
			{
				//计算移动组件此次移动的坐标点
				_moveDistance += speed;
				_movePoint.x  += _moveIncrement.x;
				_movePoint.y  += _moveIncrement.y;
				
				// TODO: 在图抖动是因为人物坐标取整导致地图平移时每次距离不一样
//				_display.x = _movePoint.x | 0;
//				_display.y = _movePoint.y | 0;
				_display.x = Math.floor(_movePoint.x);
				_display.y = Math.floor(_movePoint.y);
				
				if (moveStep != null)
				{
					moveStep(_moveIncrement); // TODO: 经验：移动一步事件放这会有一个行走居中范围的效果
				}
			}
		}
		
		public override function dispose():void
		{
			this.moveNode = null;
			super.dispose();
		}
	}
}