package com.rpg.enum
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 下午3:44:34
	 * 
	 */
	public class Constant
	{
		public function Constant()
		{
		}
		public static const TweenClass:String = "com.rpg.framework.system.transfer.Tween";
		public static const mapTileUrlClass:String = "com.rpg.scene.map2.MapTileLoadInfo";
		public static const ActionAssetsClass:String = "com.rpg.framework.loader.ActionAssets";
		public static const TimerClass:String = "com.rpg.framework.utils.TimerInfo";
		public static const TimerHandlerClass:String = "com.rpg.framework.system.timer.TimerHandler";
		public static const EffectClass:String = "com.rpg.scene.actor.Effect";
		
		/**
		 * 普通特效，等待加载时间，超过这个时间加载好就不显示了
		 */
		public static const EFFECT_LOAD_WAIT:int = 800;
		
		public static const CELL_WIDTH:int = 48;
		
		public static const CELL_HEIGHT:int = 32;
		
		/**
		 * 跳帧帧数
		 */
		public static const FRAME_SKIP:int =0;
		
		/**
		 * 攻击后摇
		 */
		public static const AttackDelay:int = 100;
		/**
		 * 自动挖矿后摇时间
		 */
		public static const PickUpDelay:int = 800;
		
		/**
		 * 女影子
		 * */
		public static const SHADOW_WOMAN:String = "102";
		
		/**
		 * 男影子
		 * */
		public static const SHADOW_MAN:String = "103";
		
		/**
		 * 怪物光圈1
		 */		
		public static const Aperture1:int = 58;
		
		/**
		 * 怪物光圈2
		 */		
		public static const Aperture2:int = 59;
	}
}