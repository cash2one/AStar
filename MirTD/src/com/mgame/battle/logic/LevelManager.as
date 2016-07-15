package com.mgame.battle.logic
{
	import com.core.Facade;
	import com.mgame.battle.Zone;
	import com.mgame.battle.logic.ai.AIScriptBase;
	import com.mgame.battle.logic.ai.IAIScript;
	import com.mgame.battle.logic.ai.NormalAI;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.enum.ActorType;
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.utils.TimeOutManager;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.RPGAnimal;
	import com.rpg.scene.actor.Role;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.utils.getTimer;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-4 下午8:03:14
	 * 
	 */
	public class LevelManager extends GameComponent
	{
		private var _zone:Zone;
		private var _sorts:Array = new Array();
		private var _monsterCfg:Object;
		private var _levelCfgs:Object;
		private var _curSort:int = 0;
		private var _nextTime:int = 0;
		private static var __mid:int = 1;
		private var _bornPoints:Array = [[0,6],[1,5],[2,4],[3,3],[4,2]];
		private var _endPoints:Array = [[10,16],[11,15],[12,14],[13,13],[14,12]];
		private var _allCount:int;
		private var _clearCount:int;
		/**
		 * 刷怪间隔
		 */
		private var _monsterIntval:int = 10000;
		/**
		 * 刷怪随机事件
		 */
		private var _randomtime:int = 5000;
		private var AI_Types:Array;
		
		private var _empty:Boolean = false;
		private var _dieEle:Object = new Object();
		
		public function LevelManager(zone:Zone)
		{
			this._zone = zone;
			var level:int = Facade.instance.getModel(ModelName.CUR_MAPID);
			var cfgs:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var cfg:Object = cfgs[ConfigData.LEVEL_MONSTER];
			_monsterCfg = cfgs[ConfigData.MONSTER];
			_levelCfgs = cfg[level];
			for (var key:String in _levelCfgs) 
			{
				_sorts.push(int(key));
			}
			_sorts.sort(Array.NUMERIC);
			AI_Types = new Array();
			AI_Types.push(NormalAI);
			var lvcfgs:Object = cfgs[ConfigData.LEVELS][this._zone.mapId];
			_monsterIntval = int(lvcfgs.sortintval) > 0?lvcfgs.sortintval: 10000;
			_randomtime = int(lvcfgs.randomtime) > 0?lvcfgs.randomtime: 5000;
		}
		
		public function start():void{
			_nextTime = getTimer() + 3000;
		}
		
		override public function update(gameTime:GameTime):void{
			super.update(gameTime);
			if(!_empty){
				if(gameTime.totalGameTime > _nextTime){
					if(_levelCfgs){
						nextWave();
						_nextTime = gameTime.totalGameTime + _monsterIntval;
					}
				}
			}else{
			}
		}
		
		/**
		 *下一波 
		 */
		private function nextWave():void{
			var monsters:Array;
			if(_sorts.length > _curSort){
				var key:String = _sorts[_curSort];
				monsters = this._levelCfgs[key];
			}
			this._curSort ++;
			if(monsters){
				for each (var m:Object in monsters)
				{
					var total:int = 1;
					if(m.count > 0)
						total = m.count;
					for(var mc:int = 0;mc < total;mc++){
						_allCount++;
						var obj:Object = new Object();
						obj.id = this.combineGameObjectId(ActorType.Monster,__mid++);
						obj.type = ActorType.Monster;
						obj.model = 1002;
						obj.dir = 3;
						var rand:int = int(Math.random() * _bornPoints.length);
						var point:Array = _bornPoints[rand];
						var endPoint:Array = _endPoints[rand];
						obj.x = point[0];
						obj.y = point[1];
						var mon:Object = this._monsterCfg[m.mid];
						for(var l:* in mon){
							if(!obj.hasOwnProperty(l)){
								obj[l] = mon[l];
							}
						}
						obj.abilityBuf = {maxHp:0};
						obj.ability = {hp:mon.hp,maxHp:mon.hp};
						obj.gold = m.gold;
						var ai:int = int(m.ai);
						TimeOutManager.getInstance().setTimer(delayAddMonster,_randomtime * Math.random(),obj,endPoint,ai);
					}
				}
				if(_sorts.length <= _curSort ){
					_empty = true;
				}
			}else{
				//end();
				_empty = true;
			}
		}
		
		public function clearOne(id:int,gold:int):void{
			if(!_dieEle[id]){
				_dieEle[id] = true;
				_clearCount++;
				if(gold > 0){
					Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.ADD_GOLD,gold);
				}
				if(_clearCount >= this._allCount){
					if(this._empty){
						trace("通关");
						TimeOutManager.getInstance().setTimer(levelClear,5000);
					}
				}
			}
		}
		
		private function levelClear():void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.LEVEL_CLEAR);
		}
		
		private function delayAddMonster(obj:Object,endPoint:Array,ai:int):void{
			var monster:Monster = this._zone.addElement(ActorType.Monster,obj) as Monster;
			
			var cls:Class = this.AI_Types[ai];
			if(cls){
				var aisp:IAIScript = new cls();
				aisp.init(this._zone,monster,this._zone.myRole as Role);
				monster.addAI(aisp as IAIScript);
				aisp.setData(NormalAI.END_POINT_KEY,endPoint)
				aisp.start();
			}
			this._zone.updateElementCount();
		}
		
		public function end():void{
			this._enabled = false;
		}
		
		public function combineGameObjectId(type:int,id:int):int{
			return (type<<27)+(id&0x07FFFFFF);
		}
		
		override public function dispose():void{
			super.dispose();
			_dieEle = null;
			_sorts = null;
			this._zone = null;
			
		}
	}
}