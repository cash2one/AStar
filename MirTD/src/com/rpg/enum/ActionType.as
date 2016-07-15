package com.rpg.enum
{
	public class ActionType
	{
		/**
		 * 站立
		 */
		public static const STAND:int =1;
		public static const SHOWSTAND:int = 99;
		/**
		 * 走动
		 */
		public static const WALK:int = 2;
		/**
		 * 跑动
		 */
		public static const RUN:int = 3;
		/**
		 * 攻击
		 */
		public static const ATTACK:int = 4;
		/**
		 * 攻击2
		 */
		public static const ATTACK_SPECIAL:int = 5;
		/**
		 * 坐坐骑待机
		 */
		public static const SIT_STAND:int = 6;
		/**
		 * 坐坐骑走动
		 */
		public static const SIT_WALK:int = 7;
		/**
		 * 坐坐骑移动
		 */
		public static const SIT_RUN:int = 8;
		/**
		 * 挖矿
		 */
		public static const MINING:int = 9;
		/**
		 * 受伤
		 */
		public static const HURT:int = 12;
		/**
		 * 死亡
		 */
		public static const DIE:int = 10;
		/**
		 * 战斗待机
		 */
		public static const BATTLE_STAND:int = 11;
		/**
		 * 飞行
		 */
		public static const FLY:int = 13;
		/**
		 * 跳马
		 */
		public static const JUMP:int = 14;
		/**
		 *倚天辟地
		 */
		public static const YITIAN:int =15;
		/**
		 * 其他1 
		 */
		public static const SPECIAL_1:int = 100;
		/**
		 * 其他2
		 */
		public static const SPECIAL_2:int = 101;
		
		public static function actionStringToInt(str:String):int{
			var ret:int = 0;
			switch(str){
				case "stand":ret = ActionType.STAND;break;
				case "battleStand":ret = ActionType.BATTLE_STAND;break;
				case "walk":ret = ActionType.WALK;break;
				case "run":ret = ActionType.RUN;break;
				case "attack":ret = ActionType.ATTACK;break;
				case "attack2":ret = ActionType.ATTACK_SPECIAL;break;
				case "beattack":ret = ActionType.HURT;break;
				case "die":ret = ActionType.DIE;break;
				case "sit":ret = ActionType.SIT_STAND;break;
				case "sitwalk":
				case "sitWalk":ret = ActionType.SIT_WALK;break;
				case "sitrun":
				case "sitRun":ret = ActionType.SIT_RUN;break;
				case "mining":ret =ActionType.MINING;break;
				case "fly":ret = ActionType.FLY;break;
				case "jump":ret = ActionType.JUMP;break;
				case "yitian":ret = ActionType.YITIAN;break;
				case "showStand":ret = ActionType.SHOWSTAND;break;
			}
			return ret;
		}
		
		public static function typeToString(type:int):String{
			var typeString:String = "";
			switch(type){
				case ActionType.STAND:typeString = "stand";break;
				case ActionType.SHOWSTAND:typeString = "showStand";break;
				case ActionType.BATTLE_STAND:typeString = "battleStand";break;
				case ActionType.WALK:typeString = "walk";break;
				case ActionType.RUN:typeString = "run";break;
				case ActionType.ATTACK:typeString = "attack";break;
				case ActionType.ATTACK_SPECIAL:typeString = "attack2";break;
				case ActionType.HURT:typeString = "beattack";break;
				case ActionType.DIE:typeString = "die";break;
				case ActionType.SIT_STAND:typeString = "sit";break;
				case ActionType.SIT_WALK:typeString = "sitWalk";break;
				case ActionType.SIT_RUN:typeString = "sitRun";break;
				case ActionType.MINING:typeString = "mining";break;
				case ActionType.FLY:typeString = "fly";break;
				case ActionType.JUMP:typeString = "jump";break;
				case ActionType.YITIAN:typeString = "yitian";break;
			}
			return typeString;
		}
	}
}