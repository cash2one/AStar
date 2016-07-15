package com.mgame.battle.logic.ai
{
	import com.mgame.battle.Zone;
	import com.rpg.framework.GameTime;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.Role;
	
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-5-13 下午7:17:45
	 * 玩家ai脚本基础类
	 */
	public class AIScriptBase
	{
		/**
		 * 场景
		 */
		protected var _zone:Zone;
		/**
		 * 玩家
		 */
		protected var _player:Role;
		
		/**
		 * 当前AI怪物
		 */
		protected var _monster:Monster;
		
		/**
		 * 是否运行中 
		 */
		protected var _enabled:Boolean = false;
		public function AIScriptBase()
		{
			
		}
		
		public function init(zone:Zone, monster:Monster,player:Role):void
		{
			this._zone = zone;
			this._monster = monster;
			this._player = player;
		}
		
		public function stop():void
		{
			this._enabled = false;
		}
		
		public function start():void
		{
			this._enabled = true;
		}
		
		public function dispose():void
		{
			this._zone = null;
			this._player = null;
			this._monster = null;
		}
	}
}