package com.rpg.enum
{
	import com.rpg.entity.animation.AnimationPlayer;
	
	import flash.utils.Dictionary;
	

	public class SkinConfig
	{
		private static var _player : Dictionary;
		private static var _monster : Dictionary;
		
		private static var _npc : Dictionary;
		
		private static var _skill : Dictionary;
		
		private static var _loops:Dictionary;
		
		/** 玩家时装、武器、武器特效动画规则 */
		public static function getPlayer() : Dictionary
		{
			if (_player == null)
			{
				_player = new Dictionary();
					//									            总方向                  间隔时间             循环次数
					_player[ActionType.STAND]       = [8     ,200		, 320,372];
					_player[ActionType.WALK]   = [8   ,83			, 320,372];
					_player[ActionType.RUN]   	   = [8   ,71			, 320,372];
					_player[ActionType.ATTACK]   	   = [8   ,62			, 320,372];
					_player[ActionType.ATTACK_SPECIAL]   = [8   ,83			, 320,372];
					_player[ActionType.DIE] = [1  ,100			, 320,372];
					_player[ActionType.FLY]    = [8 ,90			, 320,372];
					_player[ActionType.HURT]  	   = [8 ,143			, 320,372];
					_player[ActionType.MINING]     = [8,200		, 320,372];
					_player[ActionType.SIT_RUN]     = [8 ,71			, 320,372];
					_player[ActionType.SIT_STAND]   = [8 ,200			, 320,372];			
					_player[ActionType.SIT_WALK]   = [8 ,83			, 320,372];
					_player[ActionType.SHOWSTAND]   = [8 ,90			, 320,372];
			}
			return _player;
		}
		
		public static function getMonster() : Dictionary
		{
			if (_monster == null)
			{
				_monster = new Dictionary();
				//									            总方向                  间隔时间             循环次数
				_monster[ActionType.STAND]       = [5     ,200		, 320,362];
				_monster[ActionType.WALK]   = [5   ,83			, 320,362];
				_monster[ActionType.RUN]   	   = [5   ,71			, 320,362];
				_monster[ActionType.ATTACK]   	   = [5   ,100			, 320,362];
				_monster[ActionType.ATTACK_SPECIAL]   = [5   ,120			, 320,362];
				_monster[ActionType.DIE] = [1  ,100			, 320,362];
				_monster[ActionType.FLY]    = [5 ,90			, 320,362];
				_monster[ActionType.HURT]  	   = [5 ,143			, 320,362];
				/*_player[ActionType.MINING]     = [8,100		, 320,362];
				_player[ActionType.SIT_RUN]     = [8 ,0			, 320,362];
				_player[ActionType.SIT_STAND]   = [8 ,0			, 320,362];			
				_player[ActionType.SIT_WALK]   = [8 ,0			, 320,362];*/
			}
			return _monster;
		}
		
		public static function getSkill() : Dictionary
		{
			if (_skill == null)
			{
				_skill = new Dictionary();
				//									            总方向                  间隔时间             循环次数
				_skill[ActionType.STAND]       = [1     ,100		, 320,372];
				_skill[ActionType.WALK]   = [1   ,100			, 320,372];
				_skill[ActionType.RUN]   	   = [1   ,105			, 320,372];
				_skill[ActionType.ATTACK]   	   = [1   ,100			, 320,372];
				_skill[ActionType.ATTACK_SPECIAL]   = [1   ,120			, 320,372];
				_skill[ActionType.DIE] = [1  ,100			, 320,372];
				_skill[ActionType.FLY]    = [1 ,0			, 320,372];
				_skill[ActionType.HURT]  	   = [1 ,0			, 320,372];
			}
			return _skill;
		}
		
		public static function getNpc() : Dictionary
		{
			if (_npc == null)
			{
				_npc = new Dictionary();
				//									            总方向                  间隔时间             循环次数
				_npc[ActionType.STAND]       = [1     ,200		, 320,372];
				_npc[ActionType.WALK]   = [1   ,83			, 320,372];
				_npc[ActionType.RUN]   	   = [1   ,71			, 320,372];
				_npc[ActionType.ATTACK]   	   = [1   ,100			, 320,372];
				_npc[ActionType.ATTACK_SPECIAL]   = [1   ,100			, 320,372];
				_npc[ActionType.DIE] = [1  ,100			, 320,372];
				_npc[ActionType.FLY]    = [1 ,0			, 320,372];
				_npc[ActionType.HURT]  	   = [1 ,143			, 320,372];
				/*_player[ActionType.MINING]     = [8,100		, 320,362];
				_player[ActionType.SIT_RUN]     = [8 ,0			, 320,362];
				_player[ActionType.SIT_STAND]   = [8 ,0			, 320,362];			
				_player[ActionType.SIT_WALK]   = [8 ,0			, 320,362];*/
			}
			return _npc;
		}
		public static function getLoop(action:int):int{
			if (_loops == null)
			{
				_loops = new Dictionary();
				//									            总方向                  间隔时间             循环次数
				_loops[ActionType.STAND]       =AnimationPlayer.LOOP;
				_loops[ActionType.WALK]   = AnimationPlayer.LOOP;
				_loops[ActionType.RUN]   	   = AnimationPlayer.LOOP;
				_loops[ActionType.ATTACK]   	   = AnimationPlayer.SINGLE;
				_loops[ActionType.ATTACK_SPECIAL]   = AnimationPlayer.SINGLE;
				_loops[ActionType.DIE] = AnimationPlayer.SINGLE;
				_loops[ActionType.FLY]    = AnimationPlayer.SINGLE;
				_loops[ActionType.HURT]  	   = AnimationPlayer.SINGLE;
				_loops[ActionType.MINING]     = AnimationPlayer.LOOP;
				_loops[ActionType.SIT_RUN]     =AnimationPlayer.LOOP;
				_loops[ActionType.SIT_STAND]   =AnimationPlayer.LOOP;			
				_loops[ActionType.SIT_WALK]   = AnimationPlayer.LOOP;
			}
			return _loops[action];
		}
	}
}