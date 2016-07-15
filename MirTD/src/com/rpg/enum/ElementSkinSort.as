package com.rpg.enum
{
	public class ElementSkinSort
	{
		/**
		 * 五方向镜像八方向 <br>
		 * 排序动作影片 <br>
		 * 方向 UP 层级从外到内   					翅膀 --> 头盔 --> 衣服 --> 人物 --> 武器 --> 坐骑 <br>
		 * 方向 RIGHT_UP 层级从外到内  		翅膀 --> 武器 --> 头盔 --> 衣服 --> 人物 --> 坐骑 <br>
		 * 方向 RIGHT 层级从外到内  				武器 --> 头盔 --> 衣服 --> 人物 --> 翅膀 --> 坐骑 <br>
		 * 方向 RIGHT_DOWN 层级从外到内  武器 --> 头盔 --> 衣服 --> 人物 --> 翅膀 --> 坐骑 <br>
		 * 方向 DOWN 层级从外到内  			武器 --> 头盔 --> 衣服 --> 人物 --> 翅膀 --> 坐骑 <br>
		 * 方向 LEFT_DOWN 层级从外到内  	武器 --> 头盔 --> 衣服 --> 人物 --> 翅膀 --> 坐骑 <br>
		 * 方向 LEFT 层级从外到内  				武器 --> 头盔 --> 衣服 --> 人物 --> 翅膀 --> 坐骑 <br>
		 * 方向 LEFT_UP 层级从外到内  			翅膀 --> 武器 --> 头盔 --> 衣服 --> 人物 --> 坐骑 
		 */
		public static const dir_type_sort:Array = [
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
		];
		
		public static const attack_dir_type_sort:Array = [
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
		];
		
		public static const dir_type_mount_sort:Array = [
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS],
			[ElementSkinType.CLOTHING_FOOT,ElementSkinType.MOUNT_PLUS]
		];
		
		public static const Monster_sort:Array = [
			[ElementSkinType.SHADOW,ElementSkinType.WEAPON_FOOT,ElementSkinType.MONSTER],
			[ElementSkinType.SHADOW,ElementSkinType.MONSTER,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW,ElementSkinType.MONSTER,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW,ElementSkinType.MONSTER,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW,ElementSkinType.MONSTER,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW,ElementSkinType.WEAPON_FOOT,ElementSkinType.MONSTER],
			[ElementSkinType.SHADOW,ElementSkinType.WEAPON_FOOT,ElementSkinType.MONSTER],
			[ElementSkinType.SHADOW,ElementSkinType.WEAPON_FOOT,ElementSkinType.MONSTER],
		];
		
		/**
		 * 人形怪 
		 */
		public static const Monster_sort2:Array = [
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
		];
		
		public static const stand_type_sort:Array = [
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WING,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.WING,ElementSkinType.CLOTHING_FOOT],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
			[ElementSkinType.SHADOW_OUT,ElementSkinType.WEAPON_FOOT,ElementSkinType.WEAPON_EFFECT,ElementSkinType.CLOTHING_FOOT,ElementSkinType.WING],
		];
		
		public static const Npc_sort:Array = [
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
			[ElementSkinType.SHADOW,ElementSkinType.NPC],
		];
		
	}
}