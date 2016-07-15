package com.sh.game.consts
{
	/**
	 * 方向枚举
	 */
	public class DirectionType
	{
		public static const UP:int = 0;
		public static const RIGHT_UP:int = 1;
		public static const RIGHT:int = 2;
		public static const RIGHT_DOWN:int = 3;
		public static const DOWN:int = 4;
		public static const LEFT_DOWN:int = 5;
		public static const LEFT:int = 6;
		public static const LEFT_UP:int = 7;
		public static const NONE:int = 4;
		/**
		 * 五方向(上，右上，右，右下，下)镜像成八方向后的方向
		 */
		public static const EIGHT_MIRROR_DIRS:Array = [0,1,2,3,4,3,2,1];
		/**
		 * 四方向(上下左右)镜像成八方向后的方向
		 */
		public static const FOUR_MIRROR_DIRS:Array = [0,2,2,2,4,6,6,6];
		/**
		 * 四方向数组
		 */
		public static const FOUR_DIRS:Array = [0,2,4,6];
		/**
		 * 八方向数组
		 */
		public static const EIGHT_DIRS:Array = [0,1,2,3,4,5,6,7];
		
		/**
		 * 单方向
		 */
		public static const ONE_DIRS:Array = [4];
		
		/**
		 * 单方向镜像
		 */
		public static const ONE_MIRROR_DIRS:Array = [4,4,4,4,4,4,4,4];
		
		/**
		 * 两方向
		 */
		public static const TWO_DIRS:Array = [1,3];
		
		/**
		 * 两方向镜像后的方向
		 */
		public static const TWO_MIRROR_DIRS:Array = [1,1,3,3,3,3,3,1];
		/**
		 * 取相反方向
		 */
		public static const OPPOSITE_DIRS:Array = [4,5,6,7,0,1,2,3];
	}
}