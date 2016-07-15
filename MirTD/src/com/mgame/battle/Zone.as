package com.mgame.battle
{
	import com.core.Facade;
	import com.core.utils.goem.Vector2D;
	import com.mgame.battle.logic.LevelManager;
	import com.mgame.control.ProcessControl;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.entity.Animal;
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationMovieClip;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.Constant;
	import com.rpg.enum.EffectType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.utils.TimeOutManager;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneBase;
	import com.rpg.scene.actor.Effect;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.RPGAnimal;
	import com.rpg.scene.actor.Role;
	import com.rpg.scene.actor.compnent.Eclipse;
	import com.rpg.scene.control.DisposeManager;
	import com.rpg.scene.map2.MapTiles;
	import com.rpg.scene.model.CmdVO;
	import com.rpg.scene.model.GameObject;
	import com.sh.game.util.DirectionUtil;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	import consts.SkillID;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import util.FilterSet;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 下午2:57:47
	 * 
	 */
	public class Zone extends SceneBase
	{
		public function Zone()
		{
			this.initElementClass();
		}
		protected var _elementClass : Dictionary;
		private var _minimapBmp:BitmapData;
		public var _myRid:int = 0;
		public var myRole:RPGAnimal;
		private var _removedList:Vector.<RPGAnimal> = new Vector.<RPGAnimal>();
		public var servertime:int = 0;
		public var _playSkillMovie:Dictionary = new Dictionary();
		private var _effectCfg:Object;
		private var _myHurtList:Array = new Array();
		private var _lastChosseId:Number;
		public var viewRect:Rectangle = new Rectangle();
		public var zoneItems:Array = new Array();
		private var _levelManager:LevelManager;
		private var _processControl:ProcessControl;
		public var eclipse:Eclipse;
		
		override public function initialize():void{
			this.loadContent();
		}
		
		/**
		 * 注册角色类，可重写修改
		 */
		protected function initElementClass():void{ 
			_elementClass 					     = new Dictionary();
			_elementClass[ActorType.Actor]    = Role; 			// 玩家
			_elementClass[ActorType.Monster]    = Monster; 			// 怪物
			_elementClass[ActorType.BOSS] = Monster;
			_elementClass[ActorType.Pet] = Monster;
			_elementClass[ActorType.BigMonster] = Monster;
		}
		
		/**
		 * 初始化地图块与地图物件
		 */
		override public function initZone():void{
			super.initialize();
			resize();
			_zone = {width:800,height:600};
			_mapTiles = new MapTiles(800,600,this._bgLayer);
			var lvcfg:Object = ConfigData.allCfgs[ConfigData.LEVELS][this.mapId];
			if(ApplicationDomain.currentDomain.hasDefinition("png.map"+lvcfg.img)){
				_minimapBmp = Resource.getRes("png.map"+lvcfg.img);
			}
			if(this._minimapBmp){
				_mapTiles.drawMinimap(_minimapBmp);
			}
			var user:Object = Facade.instance.getModel(ModelName.PLAYER_ROLE_DATA);
			
			this.screenX = 0;
			this.screenY = 0;
			_screenRect.x = -screenX;
			_screenRect.y = -screenY;
			_screenRect.width = 800;
			_screenRect.height = 600;
			this.display.scrollRect = _screenRect;
			_myRid = user.id;
			_levelManager = new LevelManager(this);
			_processControl = new ProcessControl(this);
			Facade.instance.addObserver(ControlGroup.KEY_CONTROL,_processControl);
			Facade.instance.addObserver(ControlGroup.BATTLE_PROCESS,_processControl);
			eclipse = new Eclipse();
		}
		
		override public function update(gameTime:GameTime):void{
			removeAnimals();
			TimeOutManager.getInstance().update(gameTime);
			super.update(gameTime);
			if(this.enabled){
				_processControl.render(gameTime);
				renderAnimals(gameTime);
				this._levelManager.update(gameTime);
			}
		}
		
		/**
		 *  所有角色行为更新
		 * @param gameTime
		 */
		private function renderAnimals(gameTime:GameTime):void{
			for each(var roleMc:RPGAnimal in this.elements){
				var gameObj:GameObject = roleMc.gameObj;
				/*if(roleMc.plusType != MonsterType.Ems && (gameObj.baseObj.type == ActorType.Monster || 
					gameObj.baseObj.type == ActorType.BigMonster || 
					gameObj.baseObj.type == ActorType.BOSS) &&  !roleMc.mine ){
					this.enemyList.push(roleMc);
				}else if(gameObj.baseObj.type == ActorType.StaticMonster){
					this.staticList.push(roleMc);
				}*/
				if(!roleMc.moving ){
					if(roleMc.moveType == 5){//野蛮冲撞
						roleMc.moveType = 1;
					}
					if(roleMc.slowDown > 0){
						if(roleMc.slowDown < gameTime.totalGameTime){
							roleMc.stopMoveAction();
							roleMc.slowDown = 0;
						}
					}
					//执行动作队列
					this.doActionList(roleMc);
				}
			}
		}
		
		public function doActionList(roleMc:RPGAnimal):void{
			if(roleMc.actionList.length > 0){
				for each(var cmd:CmdVO in roleMc.actionList){
					switch(cmd.cmd)
					{
						case 0:
						{
							this.hurt(cmd.arg,true);
							break;
						}
						case 1:
						{
							//this.roleDoSkill(cmd.arg,true);
							break;
						}
						case 2:
						{
							this.roleMove(cmd.arg,true);
							break;
						}
						case 3:
						{
							this.die(cmd.arg.id,cmd.arg.killer,true);
							break;
						}
						case 4:
						{
							break;
						}
					}
				}
				roleMc.actionList.length = 0;
			}
		}
		
		public function removeEff(eff:Effect):void{
			if(!eff.reseted)
				DisposeManager.instance.disposeEffectLater(eff);
			delete _effects[eff.id];
		}
		
		public function get lastChosseId():int
		{
			return _lastChosseId;
		}
		
		/**
		 * 添加场景元素 
		 * @param type
		 * @param ele
		 * @param isme
		 * 
		 */
		override public function addElement(type:int,ele:Object,isme:Boolean = false):RPGAnimal{
			if(this._elements[ele.id]){//还没完全移除
				this.removeRole(ele.id,2,false);
			}
			_dataList[ele.id] = ele;
			var animal:RPGAnimal;
			var cls:Class = this._elementClass[type];
			switch(int(ele.type)){
				case ActorType.Actor:
					var role:Role = new cls(ele,this,isme);
					role.x = ele.x * Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5;
					role.y = ele.y * Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5;
					role.id = ele.id;
					this.addChild(role);
					if(isme){
						this.myRole = role;
						this._myRid = ele.id;
						role.itsMe();
					}
					animal = role;
					this.addRoleToView(role,0,true);
					break;
				/*case ActorType.NPC:
					var npc:RPGAnimal = new cls(ele,this);
					npc.x = ele.x* Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5;
					npc.y = ele.y * Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5;
					npc.id = ele.id;
					this._npcs[ele.id] = npc;
					this.addChild(npc);
					break;*/
				case ActorType.Monster:
					animal = new cls(ele,this);
					animal.x = ele.x* Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5;
					animal.y = ele.y* Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5;
					animal.id = ele.id;
					this.addChild(animal);
					this.addRoleToView(animal,0,true);
					break;
				default :
					if(cls)
						animal = new cls(ele,this);
					else
						animal = new Monster(ele,this);
					animal.x = ele.x* Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5;
					animal.y = ele.y* Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5;
					animal.id = ele.id;
					this.addChild(animal);
					break;
			}
			if( ele.id != this._myRid){
				if(!_elements[ele.id].canCross(true))
					this._mapData.addUnwalk(ele.x,ele.y);
			}
			return animal;
		}
		
		/**
		 * 移除一个元素
		 * @param id
		 * 
		 */
		override public function removeElement(rid:Number):void{
			if(this._dataList[rid]){
				if(this._elements[rid]){
					removeRole(int(rid),2,true);
					if(this.lastChosseId == rid){
						_lastChosseId = 0;
					}
				}else{
					delete this._dataList[rid];
				}
			}
			else if(this._effects[rid]){
				var eff:Effect = this._effects[rid];
				delete _effects[rid];
				if(eff.parent){
					eff.parent.removeChild(eff);
				}
				if(!eff.reseted)
					DisposeManager.instance.disposeEffectLater(eff);
			}
		}
		
		/**
		 * @param destory 销毁级别 0:不销毁，只移除 ，1:销毁显示对象，2:销毁显示对象和数据
		 */
		public function removeRole(id:Number,destory:int = 0,hideTween:Boolean = false):void{
			var index:int;
			var mc:RPGAnimal = this._elements[id];
			if(destory == 2){
				mc.removeRole(hideTween,true);
			}else if(destory == 1){
				mc.removeRole(hideTween);
			}else if(destory == 0){
				mc.removeRole(hideTween);
			}
		}
		
		public function addRoleToView(roleM:RPGAnimal,layer:int = 0,alphaTween:Boolean = false):void{
			if(layer == 1){
				roleM.addRoleToView(this._roleLayer,alphaTween);
				_roleLayer.needSort();
			}else if(layer == 2){
				roleM.addRoleToView(this.getLayer(ElementBase.LAYER_EFFECT),alphaTween);
			}else{
				roleM.addRoleToView(this._roleLayer,alphaTween);
				_roleLayer.needSort();
			}
		}
		
		private function removeAnimals():void{
			if(_removedList){
				while(_removedList.length > 0){
					var animal:RPGAnimal = this._removedList.shift();
					animal.removeRole(false,true);
				}
			}
		}
		
		public function removeOnNextFrame(animal:RPGAnimal):void{
			this._removedList.push(animal);
		}
		
		/**
		 * 加入可移动技能特效
		 * @param eid
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 * @param target
		 * @param endFunc
		 */
		public function addMoveSkillEffect(eid:int,startX:int,startY:int,plusY:int,endX:int,endY:int,target:int,cfgtarget:int,skill:Object,endFunc:Function):void{
			if(!this.enabled)
				return;
			var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,this,EffectType.MOVE,true,-1,endFunc);
			mc.init(eid,this,EffectType.MOVE,true,-1,endFunc,0,1,1,false,1,0,skill);
			var dir:int ;
			if(target == 0&&cfgtarget !=3){
				mc.x = startX;
				mc.y = startY +plusY ;
				dir = DirectionUtil.getForwardByPoints(startX,mc.y,endX,endY);
				mc.dir = dir;
				var vector:Vector2D = new Vector2D(endX-startX,endY-mc.y);
				vector.normalize();
				endX = vector.x * 1000 + startX;
				endY = vector.y * 1000 + mc.y;
			}else{
				startY = startY + plusY;
				mc.x = startX;
				mc.y = startY;
				dir = DirectionUtil.getForwardByPoints(startX,startY,endX,endY);
				mc.dir = dir;
				if(target != 0){
					mc.targetPoint = this._elements[target];
					if(mc.targetPoint){
						var p:Point =mc.targetPoint.hitPoint;
						endY =  endY + p.y;					
					}
				}
			}
			mc.moveTo(endX,endY);
			this._skillLayer.addChild(mc);
			this._effects[mc.setAutoid()] = mc;
		}
		
		/**
		 * 加入角色身上的技能特效
		 * @param eid   						cfg_effect表id
		 * @param target						目标
		 * @param pos							层级
		 * @param param						附加参数
		 * @param autorotate				旋转
		 * @param x								坐标x
		 * @param y								坐标y
		 * @param scale						缩放
		 * 
		 */
		public function addRoleEffect(eid:int,target:RPGAnimal,pos:int,sortchange:int = 0,autorotate:int = 0,x:int = 0,y:int = 0,scale:Number = 1):void{
			if(!this.enabled)
				return;
			if(target&&target.enabled){
				var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,null,EffectType.NORMAL,false,target.dir,null);
				/*trace("bbb ----- "+ mc.liveid);
				if(_lastskdfal == mc.liveid)
				{
				trace("sfasdfasdf");
				}*/
				mc.init(eid,null,EffectType.NORMAL,false,target.dir,null);
				if(autorotate == 1){
					var rotate:int = DirectionUtil.getRotateByDir2(target.dir);
					mc.rotate = rotate;
					if(rotate < 90 || rotate > 270){
						mc.pos = 0;
					}else
						mc.pos = 1;
				}else if(sortchange == 1){
					if(target.dir == 0){
						mc.pos = 0;
					}else{
						mc.pos = 1;
					}
				}else
					mc.pos = pos;
				mc.setAutoid();
				var index:int = -1;
				if(pos == 0){
					index = 0;
				}
				if(mc.pos == 0)
					target.addEffect(mc,0);
				else
					target.addEffect(mc);
				
				mc.x = x;
				mc.y = y;
			}
		}
		
		public function playSpecialSkill(role:RPGAnimal,id:int):void{
			if(!_effectCfg){
				_effectCfg = ConfigData.allCfgs[ConfigData.SKILL_EFFECT];
			}
			var effects:Array = _effectCfg[id];
			if(effects && effects.length > 0){
				var eff:Object = effects[0];
				if(int(eff.pos) < 2)
					TimeOutManager.getInstance().setTimer(addRoleEffect,eff.delaytime,eff.model,role,eff.pos,eff.sortchange,eff.autorotate);
				else
					TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,role.x + int(eff.x),role.y + int(eff.y),false,false,int(eff.pos - 2),-1,1,1,eff.front == 1);
			}
		}
		
		public function playSkillMovie(skill:Object,from:RPGAnimal,target:RPGAnimal,x:int,y:int,arg:Object):void{
			//trace("技能播放");
			var care:Boolean = false;
			if((from != null && from.isMe()) || (target != null && target.isMe())){
				care = true;
			}
			var dir:int = 7;
			/*if(skill.groupid == 30800){
				dir = DirectionUtil.getForwardByGridXY(from.cellX,from.cellY,int(x / Constant.CELL_WIDTH),int(y / Constant.CELL_HEIGHT));
			}else{
				if(target){
					x = target.x;
					y = target.y;
				}
				if(skill.target == 3)
					dir = from.dir;
				else if(skill.isdirc == 2 || skill.isdirc == 3)
					dir = DirectionUtil.getForwardByPoints(int(from.cellX * Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5),
						int(from.cellY * Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5),x,y);
			}*/
			if(from){
				if(skill.action == 0){
					from.setAction(ActionType.ATTACK,dir,true);
					if(dir >= 0)
						from.dir = dir;
					from.skillBusy(skill);
				}else if(skill.action == 1){
					from.setAction(ActionType.ATTACK_SPECIAL,dir,true);
					if(dir >= 0)
						from.dir = dir;
					from.skillBusy(skill);
				}
			}
			if(!_effectCfg){
				_effectCfg = ConfigData.allCfgs[ConfigData.SKILL_EFFECT];
			}
			var effects:Array = _effectCfg[skill.groupid];
			var maxDelay:int = 0;
			var roleEffs:Array = new Array();
			/*if(skill.skillid == 1003)
			this.earthQuake(skill.groupid);*/
			if(effects && effects.length > 0){
				var effects2:Object;
				var effects3:Array = new Array();
				for each(var eff:Object in effects){
					if(eff.type == 0){//施放者
						if(from){
							maxDelay = Math.max(maxDelay,int(eff.delaytime));
							if(int(eff.pos) < 2)
								TimeOutManager.getInstance().setTimer(addRoleEffect,eff.delaytime,eff.model,from,eff.pos,eff.sortchange,eff.autorotate,eff.x,eff.y,eff.scale);
							else
								TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,from.x + int(eff.x),from.y + int(eff.y),false,false,int(eff.pos - 2),eff.scale,eff.scale,eff.front == 1,0,care);
						}
					}else if(eff.type == 1){//受术者
						//if(target && target.role){
						//setTimeout(addRoleEffect,eff.delaytime,eff.model,target.role);
						effects3.push(eff);
						//}
					}else if(eff.type == 2){//运动轨迹
						effects2 = eff;
					}
				}
				var tid:int = 0;
				if(target){
					tid = target.id;
				}
				if(effects2){
					maxDelay = -1;
					var hitpoint:Point = from.hitPoint;
					TimeOutManager.getInstance().setTimer(addMoveSkillEffect,effects2.delaytime,effects2.model,from.x,from.y,hitpoint.y ,x,y,tid,skill.isdirc,skill,function(effx:int,effy:int):void{
						for each(eff in effects3){
							if(eff.param == 1){
								roleEffs.push(eff);
							}else{
								if(tid > 0){
									if(skill.target != 4 && skill.hurtarea == 1)
										TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,effx + int(eff.x),effy + int(eff.y),false,false,eff.pos,eff.scale,eff.scale,false,tid,care);
									else
										TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,effx + int(eff.x),effy + int(eff.y),false,false,eff.pos,eff.scale,eff.scale,false,0,care);
								}
								else if(skill.isdirc == 3)
								{
									TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,effx + int(eff.x),effy + int(eff.y),false,false,eff.pos,eff.scale,eff.scale,false,tid);
								}
							}
						}
						playHurtList(from,skill.skillid,arg,roleEffs,skill.hurtdelay);
					});
				}else{
					for each(eff in effects3){
						if(eff.param == 1){
							roleEffs.push(eff);
						}else{
							maxDelay = Math.max(maxDelay,int(eff.delaytime));
							if(skill.target != 4 && skill.hurtarea == 1)
								TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,x + int(eff.x),y + int(eff.y),false,false,eff.pos,eff.scale,eff.scale,false,tid,care);
							else
								TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,x + int(eff.x),y + int(eff.y),false,false,eff.pos,eff.scale,eff.scale,false,0,care);
							//setTimeout(addEffectOnTargetPos,eff.delaytime,eff.model,target,x + int(eff.x),y + int(eff.y),eff.action,eff.blendmode,false,false,eff.pos,-1,eff.scale);
						}
					}
				}
			}
			if(maxDelay > 0){
				TimeOutManager.getInstance().setTimer(playHurtList,maxDelay,from,skill.skillid,arg,null,skill.hurtdelay);
			}else if(maxDelay == 0){
				this.playHurtList(from,skill.skillid,arg,roleEffs,skill.hurtdelay);
			}
		}
		
		public function playHurtList(from:RPGAnimal,skillid:int,arg:Object,effects:Array = null,delay:int = 300):void{
			if(!this.enabled)
				return;
			if(arg != null){
				var list:Array = arg.hurtlist;
				var bufflist:Array = arg.bufflist;
				var dieRole:Object = new Object();
				//trace("释放技能" + arg.servertime);
				if(list && list.length > 0){
					for each(var hurt:Object in list){
						var id:int = hurt.id;
						var hp:int = hurt.value;
						//var type:int = hurt.type;   //命中 0 ， 闪避 1
						var targetR:RPGAnimal =  this._elements[id];
						if(!targetR || !targetR.gameObj)
							continue;
						var curhp:int = hurt.curhp;
						var innerPower:int = hurt.innerPower;
						var fromid:int = from != null?from.id : 0;
						var die:int = hurt.die;
						if(die == 1){
							dieRole[id] = true;
							targetR.dead = true;//已经挂了
						}
						playHurt(fromid,targetR,hurt.hit,hp,curhp,targetR.gameObj.maxHp,innerPower,die,arg.servertime,arg.hurtTime,delay);
						for each(var eff:Object in effects)
						TimeOutManager.getInstance().setTimer(addNormalEffectNoSort,eff.delaytime,eff.model,targetR.x,targetR.y,false,false,eff.pos,eff.scale,eff.scale);
					}
				}
				if(bufflist && bufflist.length > 0){
					for each(var buff:Object in bufflist){
						if(buff && buff.targets && buff.targets.length > 0){
							for each(var target:Object in buff.targets){
								if(!dieRole[id]){
									var role:RPGAnimal = this.elements[target];
									if(role){
										role.addBuffer(buff);
									}
								}
							}
						}
					}
				}
			}else if(from == this.myRole){
				_playSkillMovie[skillid] = false;
				if(_myHurtList.length > 0){
					playHurtList(from,skillid,_myHurtList.pop(),null,delay);
					if(_myHurtList.length > 0)
						_myHurtList.length = 0;
				}
			}
		}
		
		private function playHurt(fromid:int,targetR:RPGAnimal,hit:int,hp:int,curhp:int,maxHp:int,innerPower:int,die:int,time:Number,hurtTime:int,delayTotal:int = 300):void{
			var serverTime:Number = servertime + getTimer();
			var delay:int = serverTime - time;
			if(delay < delayTotal)
				TimeOutManager.getInstance().setTimer(dohurt, delayTotal - delay,fromid,targetR,hit,hp,curhp,maxHp,innerPower,die,hurtTime);
			else
				dohurt(fromid,targetR,hit,hp,curhp,maxHp,innerPower,die,hurtTime);
		}
		
		private function dohurt(fromid:int,targetR:RPGAnimal,hit:int,hp:int,curhp:int,maxHp:int,innerPower:int,die:int,time:int):void{
			if(!this.enabled)
				return;
			if(targetR){
				var killer:RPGAnimal = this.elements[fromid];
				targetR.hurt(hp,curhp,maxHp,true,hit,time);
				if(targetR == this.myRole){
					Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.HP,curhp);
				}
				if(die == 1){
					var killername:String = "未知";
					if(killer){
						if(killer is Monster){
							(killer as Monster).autoSay(2);
						}
						killername =  killer.gameObj.baseObj.name;
					}
					if(killer && killer.gameObj.baseObj.type == ActorType.Actor)
						this.die(targetR.id,killername,false,killer.gameObj.baseObj.rid);
					else
						this.die(targetR.id,killername);
				}
			}
		}
		
		public function die(id:int,killer:String = "",direct:Boolean = false,killrid:int = 0):void{
			if(this.elements[id]){
				var animal:RPGAnimal = this.elements[id];
				if(this._myRid != id && !direct && !(animal.busy || animal.moving)){
					animal.actionList.push(new CmdVO(3,{id:id,killer:killer}));
					return;
				}
				animal.die();
				if(this._myRid == id){//挂了
					//_dropsLayer.clearMouse();
					/*	if (Starling.current.context.driverInfo != Config.LostContext) {
					_root.filter = new ColorMatrixFilter(_matrix);
					}*/
					this.display.filters = [FilterSet.GrayFilter];
					gameOver();
				}else{
					this._levelManager.clearOne(id,animal.gameObj.baseObj.gold);
				}
				cancelTarget(id);
			}
		}
		
		private function gameOver():void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.GAME_OVER);
		}
		
		public function end():void{
			this._levelManager.end();
			this.enabled = false;
		}
		
		/**
		 * 取消当前攻击目标
		 */
		public function cancelTarget(id:int):void{
			
		}
		
		/**
		 * 加入非指向角色型无排序技能特效
		 * @param eid 					cfg_effect表id
		 * @param x						坐标	x
		 * @param y						坐标 y
		 * @param loop				是否循环
		 * @param randomFrame 随机起始帧
		 * @param pos					层级
		 * @param scaleX				
		 * @param scaleY
		 * @param front				最上层
		 * @param target				目标id
		 *  @param myEff				我的特效，必须播放
		 * @return 
		 */
		public function addNormalEffectNoSort(eid:int,x:int,y:int,loop:Boolean = true,randomFrame:Boolean = false,pos:int = 1,scaleX:Number = 1,scaleY:Number = 1,front:Boolean = false,target:int = 0,myEff:Boolean = true):Effect{
			if(!this.enabled)
				return null;
			if(!myEff ){
				if(this._roleLayer.eleCount > 100)
					return null;
				if(!viewRect.contains(x,y)){
					return null;	
				}
			}
			var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,this,EffectType.NORMAL,loop,-1,null,0,scaleX,scaleY,randomFrame);
			
			//trace("aaa ----- "+ mc.liveid);
			//_lastskdfal= mc.liveid;
			
			mc.init(eid,this,EffectType.NORMAL,loop,-1,null,0,scaleX,scaleY,randomFrame);
			mc.x = x ;
			mc.y = y;
			if(front)
				this._frontMcLayer.addChild(mc);	
			else if(pos == 1)
				this._skillLayer.addChild(mc);
			else
				this._skillLayer2.addChild(mc);
			if(target > 0){
				if(this._elements[target]){
					mc.targetPoint = this._elements[target];
					mc.x = this._elements[target].x;
					mc.y = this._elements[target].y;
					//mc.setPath([new Point(mc.x,mc.y)]);
					//_skillMc.push(mc);
				}
			}
			this._effects[mc.setAutoid()] = mc;
			return mc;
		}
		
		/**
		 * 加入非指向角色型技能特效(这个类型的每个特效都有id)
		 * @param id
		 * @param eid
		 * @param x
		 * @param y
		 * @param action
		 * @param loop
		 * @param randomFrame
		 * @param nohide
		 * @return 
		 * 
		 */
		public function addNormalEffect(id:int,eid:int,x:int,y:int,action:int = 1,loop:Boolean = true,randomFrame:Boolean = false,nohide:Boolean = false,scale:Number = 1):Effect{
			if(!this.enabled)
				return null;
			var offset:Boolean = false;
			if(scale == 99){
				offset = true;
				scale =  0.7*Math.random();
			}
			var delay:int = 250;
			var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,this,EffectType.NORMAL,loop,-1,null,0,scale,scale,randomFrame,1,delay);
			mc.init(eid,this,EffectType.NORMAL,loop,-1,null,0,scale,scale,randomFrame,1,delay);
			if(offset){
				mc.x = Constant.CELL_WIDTH * x + Constant.CELL_WIDTH * Math.random() ;
				mc.y = Constant.CELL_HEIGHT * y + Constant.CELL_HEIGHT * Math.random();
			}else{
				mc.x = Constant.CELL_WIDTH * x + Constant.CELL_WIDTH/2;
				mc.y = Constant.CELL_HEIGHT * y + Constant.CELL_HEIGHT/2 - 1;
			}
			
			mc.id = id;
			this._roleLayer.addChild(mc);
			_effects[mc.id] = mc;
			return mc;
		}
		
		/**
		 * 角色移动（服务端）
		 */
		public function roleMove(data:Object,direct:Boolean = false):void{
			if(!this.enabled || !myRole)
				return;
			var role:RPGAnimal = this._elements[data.id];
			if(role == null)
				return;
			if(role == this.myRole){
				role.setPositionXY(data.x,data.y);
			}else{
				if((role.moving || role.busy)&& !direct){
					role.actionList.push(new CmdVO(2,data));
					return;
				}
				role.moveType = data.move;
				role.setPositionXY(data.x,data.y);
				role.setPath([new Point((data.x <<4 )*3 + Constant.CELL_WIDTH*0.5,(data.y<<5) + Constant.CELL_HEIGHT*0.5)]);
			}
		}
		
		/**
		 *	攻击流程消息
		 */
		public function hurt(arg:Object,direct:Boolean = false):void{
			var id:int = arg.id;
			var hp:int = arg.hp;
			var type:int = arg.type;   //闪避 0 ， 命中 1
			var targetR:RPGAnimal =  this._elements[id];
			var curhp:int = arg.curhp;
			var fromid:int = arg.fromid;
			var die:int = arg.die;
			arg.hurtTime = getTimer();
			if(fromid != this._myRid){
				var role:RPGAnimal =  this._elements[fromid];
				if(role == null)
					return;
				if(role.moving && !direct){
					role.actionList.push(new CmdVO(0,arg));
					return;
				}
				var dir:int = arg.dir;
				if(role){
					if(dir == -1)
						dir = role.dir;
					if(!role.dead){
						role.setAction(ActionType.ATTACK,dir,true);
						role.dir = dir;
					}
				}
			}else{
				
			}
			if(targetR)
				playHurt(fromid,targetR,arg.type,hp,curhp,targetR.gameObj.maxHp,arg.innerPower,die,arg.servertime,arg.hurtTime);
		}
		
		public function roleDoSkill(arg:Object,direct:Boolean = false):void{
			if(!this.enabled || !myRole)
				return;
			var _skillCfg :Object = ConfigData.allCfgs[ConfigData.SKILL];
			var roleMg:RPGAnimal = this._elements[arg.id];
			if(roleMg != null)
			{
				roleMg.setMp(arg.mp);
				var skill:Object = _skillCfg[arg.skillid];
				arg.hurtTime = getTimer();
				if(arg.id != this._myRid){
					if(roleMg.moving && !direct){
						roleMg.actionList.push(new CmdVO(1,arg));
						return;
					}else {
					}
					var x:int = arg.x;
					var y:int = arg.y;
					var target:RPGAnimal = this._elements[arg.toid];
					if(roleMg is Monster){
						(roleMg as Monster).autoSay(1);
					}
					if(arg.id == this._myRid){
						_playSkillMovie[arg.skillid] = true;
						this.playSkillMovie(_skillCfg[arg.skillid],roleMg,target,x  * Constant.CELL_WIDTH + Constant.CELL_WIDTH / 2, y * Constant.CELL_HEIGHT +Constant.CELL_HEIGHT/2 ,null);
					}else
						this.playSkillMovie(_skillCfg[arg.skillid],roleMg,target,x  * Constant.CELL_WIDTH + Constant.CELL_WIDTH / 2, y * Constant.CELL_HEIGHT +Constant.CELL_HEIGHT/2 ,arg);
					
				}
				if(arg.id == this._myRid){
					//ModelProxy.change("fastlist","cd",arg.skillid);
					var weapskill:Boolean;
					//this.process.clearSkillTempCd(arg.skillid);
					//this.process.startCd(arg.skillid);
					var list:Array = arg.hurtlist;
					var bufflist:Array = arg.bufflist;
					var dieRole:Object = new Object();
					if(list && list.length > 0){
						for each(var hurt:Object in list){
							var id:int = hurt.id;
							var hp:int = hurt.value;
							var curhp:int = hurt.curhp;
						}
					}
					if(!_playSkillMovie[arg.skillid]){
						playHurtList(roleMg,arg.skillid,arg,null,_skillCfg[arg.skillid].hurtdelay);
					}else{
						_myHurtList.push(arg);
					}
				}
			}else{
				playHurtList(null,arg.skillid,arg,null,_skillCfg[arg.skillid].hurtdelay);
			}
		}
		
		/**
		 * buff伤害
		 * @param arg
		 */
		public function bufferHurt(arg:Object):void{
			var id:int = arg.id;
			var role:RPGAnimal = this._elements[id];
			if(role){
				arg.hurtTime = getTimer();
				if(arg.killerid == this._myRid || id == this._myRid){
					var changed:int =0-int(arg.hurt);
					if(arg.type == 1)
						dohurt(arg.killerid,role,3,changed,arg.hp,role.gameObj.maxHp,arg.innerPower,arg.die,arg.hurtTime);
					else
						dohurt(arg.killerid,role,1,changed,arg.hp,role.gameObj.maxHp,arg.innerPower,arg.die,arg.hurtTime);
				}else{
					role.setHp(arg.hp);
				}
				if(arg.die){
					this.die(id,arg.killer);
				}
			}
		}
		
		/**
		 * 检测技能碰撞 
		 * @param x
		 * @param y
		 * @param skill
		 * @param eff
		 * 
		 */
		public function hitTestMonsters(x:int,y:int,skill:Object,eff:Effect):void{
			var radio:int = 10;
			var sorts:Array = this.getLayer(ElementBase.LAYER_ROLE).components.source;
			for(var key:int = sorts.length - 1;key >= 0; key--){
				if(sorts[key] is RPGAnimal){
					var role:RPGAnimal = sorts[key];
					if(eff.hited[role.id])
						continue;
					if(role is Monster && !role.dead){
						if(role.hitTestBmp(x - role.x,y - role.y)){
							var hurt:int = -(int(skill.hurtp) + this.myRole.gameObj.baseObj.ability.att);
							role.gameObj.realHp = role.gameObj.realHp + hurt;  
							var die:int = 0;
							if(role.gameObj.realHp <= 0){
								role.gameObj.realHp = 0;
								die = 1;
							}
							if(skill.buffer > 0){
								var buffinfo:Object = new Object();
								buffinfo.bufferid = skill.buffer;
								buffinfo.dispelTime= getTimer() + int(skill.buffertime);
								buffinfo.hurt = skill.bufferhurt;
								role.addBuffer(buffinfo);
							}
							dohurt(this._myRid,role,1,hurt,role.gameObj.realHp,role.gameObj.maxHp,0,die,getTimer());
							eff.hited[role.id] = true;
							if(skill.groupid == SkillID.NORMAL_ATTACK){
								this.addRoleEffect(9,role,1,0,0,0,role.hitPoint.y);
							}
							if(skill["switch"] == 0){
								this.removeEff(eff);
								break;
							}
						}
					}
				}
			}
		}
		
		override public function dispose():void{
			_removedList.length = 0;
			_removedList = null;
			if(this.eclipse)
			{
				this.eclipse.dispose();
				this.eclipse = null;
			}
			viewRect = null;
			TimeOutManager.getInstance().clearAll();
			Facade.instance.removeObserver(ControlGroup.KEY_CONTROL,_processControl);
			Facade.instance.removeObserver(ControlGroup.BATTLE_PROCESS,_processControl);
			_processControl.dispose();
			_processControl = null;
			_minimapBmp = null;
			_levelManager.dispose();
			_levelManager = null;
			_playSkillMovie = null;
			
			
			if(zoneItems)
				for each (var ani:AnimationMovieClip in zoneItems) 
			{
				if(ani.parent)
					ani.parent.removeChild(ani);
				ani.dispose();
			}
			zoneItems = null;
			myRole = null;
			_myHurtList = null;
			super.dispose();
		}
	}
}