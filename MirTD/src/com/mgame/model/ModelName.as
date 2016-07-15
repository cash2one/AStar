package com.mgame.model
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 上午10:22:19
	 * 
	 */
	public class ModelName
	{
		/**
		 * 当前状态
		 * 1 主界面
		 * 2 关卡选择
		 * 3 战斗中
		 * consts.ViewName
		 */
		public static const STATE:int = 1;
		
		/** 游戏配置数据	 */
		public static const GAME_CONFIG:int = 2;
		
		/**当前选中关卡*/
		public static const CUR_SELECT_LEVEL:int = 3;
		
		/** 玩家角色数据 */
		public static const PLAYER_ROLE_DATA:int = 4;
		
		/**当前关卡*/
		public static const CUR_MAPID:int = 5;
		
		/**选中技能*/
		public static const SELECT_SKILL:int = 6;
		
		/**技能冷却*/
		public static const SKILL_CDS:int = 7;
		
		/**金币*/
		public static const 	GOLD:int = 8;
		/**玩家属性*/
		public static const 	PLAYER_DATA:int = 9;
	}
}