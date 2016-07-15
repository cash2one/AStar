package com.rpg.framework.utils
{
	import flash.geom.Point;

	public class MathExtension
	{
		/**
		 * 获取雷达范围内的的点（方颖）
		 * @param x1 起点 X 坐标
		 * @param y1 起点 Y 坐标
		 * @param x2 终点 Y 坐标
		 * @param y2 终点 Y 坐标
		 * @return
		 *
		 */
		public static function getRadarRangePoint(x1 : Number, y1 : Number, x2 : Number, y2 : Number, radius : Number) : Point
		{
			var xPot : Number;
			var yPot : Number;

			var bc : Number;
			var ab : Number;

			var sina : Number;
			var cosa : Number;

			// 计算距离
			ab = Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));

			// 有方向
			sina = (y2 - y1) / ab;
			cosa = (x2 - x1) / ab;

			if (ab > radius)
			{
				xPot = radius * cosa + x1;
				yPot = radius * sina + y1;
			}
			else
			{
				xPot = x2;
				yPot = y2;
			}
			return new Point(xPot, yPot);
		}

		/**
		 * 两条线之间夹角
		 * @param p1
		 * @param p2
		 * @return
		 *
		 */
		public static function angle(p1 : Point, p2 : Point) : Number
		{
			var r : Number = Math.PI / 2;
			if (p1.x != p2.x)
			{
				r = Math.atan((p1.y - p2.y) / (p1.x - p2.x));
			}
			return r;
		}

		public static function floor(nNumber : Number, nRoundToInterval : Number = 1) : Number
		{
			return Math.floor(nNumber / nRoundToInterval) * nRoundToInterval;
		}
	}
}
