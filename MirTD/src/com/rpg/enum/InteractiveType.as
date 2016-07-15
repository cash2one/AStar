package com.rpg.enum
{
	/**
	 * 人物与其它对象的交互类型 
	 * @author dg
	 * 
	 */	
	public class InteractiveType
	{
		/** 无交互动做 */
		public static const NONE : int          = 0;
		/** 英雄与对话 */
		public static const DIALOGUE : int      = 1;
		/** 英雄技能施放 */
		public static const SKILL : int         = 2;
		/** 英雄转场 */
		public static const TRANSFER : int      = 3;
		/** 英雄与玩家交易 */
		public static const TRANSACTION : int   = 4;
		/** 拾取物品 */
		public static const LOOT : int          = 5;
		/** 任务寻路 */
		public static const TASK : int          = 6;
		/** 双修 */
		public static const MIND_AND_BODY : int = 7;
		/** 采集 */
		public static const GATHER 	      : int = 8;
	}
}