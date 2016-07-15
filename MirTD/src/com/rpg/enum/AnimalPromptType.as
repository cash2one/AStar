package com.rpg.enum
{
	/**
	 * 动物提示文字类型
	 * 
	 */
	public class AnimalPromptType
	{
		//--------------- 玩家文本颜色提示类型  ---------------
		/** 组队玩家 */	
		public static const PLAYER_TEXT_COLOR_TEAM      : String = "player_text_color_team";
		/** 玩家自己 */	
		public static const PLAYER_TEXT_COLOR_SELF      : String = "player_text_color_self";
		/** 玩家自己 */	
		public static const PLAYER_TEXT_COLOR_OTHER     : String = "player_text_color_other";
		/** 点击其他玩家 */		
		public static const PLAYER_TEXT_COLOR_SELECTED  : String = "player_text_color_selected";
		/** 当前敌对玩家 */	
		public static const PLAYER_TEXT_COLOR_HOSTILITY : String = "player_text_color_hostility";
		
		//--------------- 怪物文本颜色提示类型  ---------------
		/** 低于玩家等级 */	
		public static const MONSTER_TEXT_COLOR_LESS            : String = "monster_text_color_less";
		/** 与玩家等级相近 */	
		public static const MONSTER_TEXT_COLOR_SIMILAR         : String = "monster_text_color_similar";
		/** 比玩家等级高很多 */	
		public static const MONSTER_TEXT_COLOR_MUCH_HIGHER     : String = "monster_text_color_much_higher";
	}
}