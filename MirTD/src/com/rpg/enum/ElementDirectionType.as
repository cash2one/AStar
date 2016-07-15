package com.rpg.enum
{
	/**
	 * 元件方向类型 
	 * @author dg
	 * 
	 */	
	public class ElementDirectionType
	{
		public static const LIST : Array     = [UP, DOWN, LEFT, RIGHT, LEFT_UP, LEFT_DOWN, RIGHT_UP, RIGHT_DOWN];
		
		/** 方向上 */
		public static const UP         : int = 0;
		/** 方向下 */
		public static const DOWN       : int = 4;
		/** 方向左 */
		public static const LEFT       : int = 4;
		/** 方向右 */
		public static const RIGHT      : int =6;
		/** 方向左上 */
		public static const LEFT_UP    : int = 7;
		/** 方向左下 */
		public static const LEFT_DOWN  : int = 5;
		/** 方向右上 */
		public static const RIGHT_UP   : int = 1;
		/** 方向右下 */
		public static const RIGHT_DOWN : int = 3;
		/** 无方向*/		
		public static const NONE 	   : int = 4;
	}
}