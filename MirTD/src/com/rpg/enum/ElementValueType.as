package com.rpg.enum
{
	import flash.utils.Dictionary;

	public class ElementValueType
	{
		private static var _attributeNameByKey : Dictionary;

		/**
		 * 通过人物属性键值获取属性名称（与服务端通信用）
		 * @param key ElementValueType属性键值
		 * @return 属性名称
		 */
		public static function getElementAttributeNameByKey(key : int) : String
		{
			if (!_attributeNameByKey)
			{
				_attributeNameByKey = new Dictionary();
			}
			return _attributeNameByKey[key];
		}

		/** 联盟名称 */
		public static const ALLIANCE_NAME : int             = 2013;

		/** 玩家的衣服(怪物,玩家的外观)*/
		public static const CLOTHING : int                  = 2014;

		/** 步战武器(玩家的外观)*/
		public static const WEAPON_FOOT : int               = 2015;

		/** 骑战武器(玩家的外观)*/
		public static const WEAPON_RIDE : int               = 2016;

		/** 坐骑(玩家的外观)*/
		public static const MOUNT : int                     = 2017;

		/** 角色是否已上坐骑. ( {@link Boolean} ) */
		public static const RIDE : int                      = 2018;

		/** X轴坐标*/
		public static const X : int                         = 2019;

		/** Y轴坐标*/
		public static const Y : int                         = 2020;

		/** 基础ID(NPC,传送点,采集物等)*/
		public static const BASE_ID : int                   = 2021;

		
	}
}
