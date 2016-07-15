
package com.rpg.enum
{
	import flash.utils.Dictionary;

	public class ElementType
	{
		/** 其它类型（场景中没有交互的元件）*/
		public static const OTHER : int     = -1;
		/** 掉落物  */
		public static const LOOT : int      = -2;
		/** 玩家 */
		public static const PLAYER : int    = 0;
		/** 宠物 */
		public static const PET : int       = 1;
		/** 怪物 */
		public static const MONSTER : int   = 2;
		/** NPC */
		public static const NPC : int       = 3;
		/** 采集点 */
		public static const GATHER : int    = 4;
		/** 转场点 */
		public static const TRANSFER : int  = 5;
		/** 风景 */
		public static const LANDSCAPE : int = 6;
		/** 酒宴 */
		public static const BANQUET : int   = 8;
	}
}
