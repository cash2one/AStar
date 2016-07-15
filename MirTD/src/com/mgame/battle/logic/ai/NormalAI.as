package com.mgame.battle.logic.ai
{
	import com.rpg.enum.Constant;
	import com.rpg.framework.GameTime;
	import com.rpg.scene.model.GameObject;
	
	import consts.BufferID;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-5 上午10:36:12
	 * 
	 */
	public class NormalAI extends AIScriptBase implements IAIScript
	{
		public  static const END_POINT_KEY:int = 1;
		
		
		/**
		 * 状态：移动中 
		 */
		private static const MOVING:int = 1;
		/**
		 * 状态：攻击中
		 */
		private static const ATTACKING:int = 2;
		/**
		 * 状态：等待
		 */
		private static const WAITING:int = 0;
		/**
		 * 状态：死亡
		 */
		private static const DEAD:int = 3;
		private var _state:int = 0;
		
		private var _lastbufferHurt:int = 0;
		
		public function NormalAI()
		{
			super();
		}
		private var _data:Dictionary = new Dictionary();
		private var _lastupdate:int = 0;
		private var _aiintval:int = 1000;
		private var _moveintval:int = 1000;
		private var _removeTime:int = 0;
		public function update(gameTime:GameTime):void
		{
			if(this._enabled){
				checkBuffer(gameTime);
				if(this._state != DEAD && this._monster.dead){
					this.changeState(DEAD);
					_removeTime = gameTime.totalGameTime + 3000;
				}
				if(this._player && !_player.dead){
					if(this._state == MOVING){
						if(_lastupdate < gameTime.totalGameTime - _moveintval){
							if(!this._monster.moving){
								var x:int = int(_monster.x / Constant.CELL_WIDTH);
								var y:int = int(_monster.y / Constant.CELL_HEIGHT);
								this._zone.roleMove({id:_monster.id,x:x + 1,y:y+1});
								var endP:Array = _data[END_POINT_KEY];
								if(x +1 >= endP[0] || y +1 >= endP[1]){
									this.changeState(ATTACKING);
								}
							}
							_lastupdate = gameTime.totalGameTime;
						}
					}else if(this._state == WAITING){
						
					}else if(this._state == ATTACKING){
						if(this._monster.canProcess){
							if(_lastupdate < gameTime.totalGameTime - _aiintval){
								_lastupdate = gameTime.totalGameTime;
								this.attack();
							}
						}
					}else if(this._state == DEAD){//已经挂了，还ai 毛啊
						//this._enabled = false;
						if(_removeTime < gameTime.totalGameTime){
							this._zone.removeElement(_monster.id);
							this._zone.updateElementCount();
							this._enabled = false;
						}
					}
				}
			}
		}
		
		override public function start():void{
			super.start();
			_moveintval = this._monster.monsterCfg.moveInterval;
			this._aiintval = this._monster.monsterCfg.attackSpeed;
			this.changeState(MOVING);
		}
		
		private function checkBuffer(gameTime:GameTime):void{
			var buffs:Object = this._monster.gameObj.baseObj.beBuffers;
			for (var key:String in buffs) 
			{
				var buff:Object = buffs[key];
				if(buff.dispelTime < gameTime.totalGameTime){
					_monster.removeBuffer(int(key));
				}else{
					if(int(key) == BufferID.ZHUO_SHAO){
						if(_lastbufferHurt + 2000 < gameTime.totalGameTime ){//bufferhurt
							this.bufferHurt(BufferID.ZHUO_SHAO,buff.hurt);
							_lastbufferHurt = gameTime.totalGameTime;
						}
					}
				}
			}
		}
		
		private function bufferHurt(buffid:int,hurt:int):void{
			var result:Object = new Object();
			result.hurt = hurt;
			var hurt:int = -hurt;
			var hp:int = _monster.gameObj.realHp + hurt;
			if(hp <= 0){
				result.die =1;
				hp = 0;
			}else{
				result.die =0;
			}
			result.id = this._monster.id;
			result.hp = hp;
			result.killer = this._zone.myRole.gameObj.baseObj.name;
			result.killerid = this._zone.myRole.id;
			result.type = this._monster.type;
			this._zone.bufferHurt(result);
		}
		
		public function attack():void{
			var arg:Object = new Object();
			var gameObj:GameObject = _player.gameObj;
			var hurt:int = -Math.max(1,(this._monster.monsterCfg.phyAtt - _player.gameObj.baseObj.ability.def));
			arg.id = this._player.id;
			arg.hp = hurt;
			arg.type = 1;
			arg.dir = 3;
			arg.curhp = gameObj.realHp = gameObj.realHp + hurt;
			arg.fromid = this._monster.id;
			arg.setvertime = getTimer();
			if(arg.curhp <= 0){
				arg.curhp = 0;
				arg.die = 1;
			}else 
				arg.die = 0;
			this._zone.hurt(arg,true);
		}
		
		/**
		 * 切换状态
		 * @param state
		 */
		public function changeState(state:int):void{
			this._state = state;
		}
		
		public function setData(key:int,value:Object):void{
			_data[key] = value;
		}
	}
}