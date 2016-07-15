package com.rpg.framework.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	public class Vector2Extension
	{
		/**
		 * 转向物体 方向
		 * @param start 目标点
		 * @param end   旋转对象
		 *
		 */
		public static function orientation(start : Point, end : Point) : Number
		{
			var dx : Number = end.x - start.x;
			var dy : Number = end.y - start.y;
			var r : Number  = Math.atan2(dy, dx) * 180 / Math.PI;
			return r;
		}
		
		/**
		 * 击飞效果（绝对坐标点）
		 *
		 */
		public static function blowFlyEffects(x1 : Number, y1 : Number, x2 : Number, y2 : Number, distance : Number) : Point
		{
			var radians : Number = Math.atan((y2 - y1) / (x2 - x1));
			var degrees : Number = radians * 180 / Math.PI;

			var xFlag : int      = x1 > x2 ? -1 : 1;
			var yFlag : int      = y1 > y2 ? -1 : 1;

			var x3 : Number      = Math.abs(Math.cos(degrees * Math.PI / 180)) * distance * xFlag + x2;
			var y3 : Number      = Math.abs(Math.sin(degrees * Math.PI / 180)) * distance * yFlag + y2;
			
			if (x1 == x2)
			{
				x3 = x2;
				y3 = distance * yFlag + y2;
			}
			
			if (y1 == y2)
			{
				x3 = distance * xFlag + x2;
				y3 = y2;
			}
			
			return new Point(x3, y3);
		}
		
		/**
		 * 移动增量计算（以步长折分）
		 * @param startPoint 起点
		 * @param endPoint   终点
		 * @param stepLength 每步步长
		 */
		public static function moveIncrement(startPoint : Point, endPoint : Point, step : Number) : Point
		{
			var seDistance : Number      = Point.distance(startPoint, endPoint); 	// startPoint 到 endPoint 的距离
			var scaleStepLength : Number = step / seDistance;
			var x : Number               = (endPoint.x - startPoint.x) * scaleStepLength;
			var y : Number               = (endPoint.y - startPoint.y) * scaleStepLength;
			
			return new Point(x,y);
		}
		
		/**
		 * 移动A*格距离计算
		 * @param startPoint 起点
		 * @param endPoint   终点
		 * @param stepLength 移动长度
		 */	
		public static function moveDistance(startPoint:Point,endPoint:Point,stepLength:int):Point
		{
			var seDistance:Number	   = Point.distance(startPoint,endPoint);	// startPoint 到 endPoint 的距离
			var scaleStepLength:Number = stepLength / seDistance;
			var x:int 			       = int(startPoint.x + (endPoint.x - startPoint.x) * scaleStepLength);
			var y:int			       = int(startPoint.y + (endPoint.y - startPoint.y) * scaleStepLength);		
			return new Point(x,y);
		}

		/**
		 * 通过正切值获取向量朝向代号（方向代码和小键盘的数字布局一样-8：上、４：左、６：右、２：下等）
		 * @param currentPoint  当前点
		 * @param targetPoint   目标点
		 */
		public static function directionPointByTan(currentPoint : Point, targetPoint : Point) : int
		{
			return directionByTan(currentPoint.x, currentPoint.y, targetPoint.x, targetPoint.y);
		}

		/**
		 * 通过正切值获取向量朝向代号（方向代码和小键盘的数字布局一样-８：上、４：左、６：右、２：下等）
		 * @param targetX  目标点的X值
		 * @param targetY  目标点的Y值
		 * @param currentX 当前点的X值
		 * @param currentY 当前点的Y值
		 */
		public static function directionByTan(currentX : Number, currentY : Number, targetX : Number, targetY : Number) : int
		{
			var tan : Number = (targetY - currentY) / (targetX - currentX);
			if (Math.abs(tan) >= Math.tan(Math.PI * 3 / 8) && targetY <= currentY)
			{
				return 8;
			}
			else if (Math.abs(tan) > Math.tan(Math.PI / 8) && Math.abs(tan) < Math.tan(Math.PI * 3 / 8) && targetX > currentX && targetY < currentY)
			{
				return 9;
			}
			else if (Math.abs(tan) <= Math.tan(Math.PI / 8) && targetX >= currentX)
			{
				return 6;
			}
			else if (Math.abs(tan) > Math.tan(Math.PI / 8) && Math.abs(tan) < Math.tan(Math.PI * 3 / 8) && targetX > currentX && targetY > currentY)
			{
				return 3;
			}
			else if (Math.abs(tan) >= Math.tan(Math.PI * 3 / 8) && targetY >= currentY)
			{
				return 2;
			}
			else if (Math.abs(tan) > Math.tan(Math.PI / 8) && Math.abs(tan) < Math.tan(Math.PI * 3 / 8) && targetX < currentX && targetY > currentY)
			{
				return 1;
			}
			else if (Math.abs(tan) <= Math.tan(Math.PI / 8) && targetX <= currentX)
			{
				return 4;
			}
			else if (Math.abs(tan) > Math.tan(Math.PI / 8) && Math.abs(tan) < Math.tan(Math.PI * 3 / 8) && targetX < currentX && targetY < currentY)
			{
				return 7;
			}
			else
			{
				return RandomExtension.RandomExtract([1, 2, 3, 4, 6, 7, 8, 9]);		// 两点为同一点时，随机返回一个方向
			}
        }
	}
}