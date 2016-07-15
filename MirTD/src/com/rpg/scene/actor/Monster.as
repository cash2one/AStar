package com.rpg.scene.actor
{
	import com.core.Facade;
	import com.mgame.battle.Zone;
	import com.mgame.battle.logic.ai.AIScriptBase;
	import com.mgame.battle.logic.ai.IAIScript;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.entity.GameSprite;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.Constant;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.MonsterType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.memory.CacheManager;
	import com.rpg.scene.actor.skin.monster.MonsterSkin;
	import com.sh.game.global.Config;
	import com.sh.game.util.DirectionUtil;
	import com.sh.game.util.MColor;
	
	import consts.BufferID;
	
	import flash.utils.setInterval;
	
	
	public class Monster extends RPGAnimal
	{
		private var monsterSkin:MonsterSkin;
		private var _model:String;
		public var candig:Boolean;
		protected var _killWords:Array;					//杀人的时候说的废话
		protected var _skillWords:Array;					//放技能时说的废话
		protected var _skillrates:Array;					//放技能时说的废话几率
		protected var _killrates:Array;					//杀人时说的废话几率
		protected var _sayrates:Array;					//说的废话几率
		public var dazibao:Boolean = false;
		
		private var _weaponModel:int;
		private var _wingModel:int;
		private var _ai:IAIScript;
		
		public function Monster(baseObj:Object,zone:Zone,initView:Boolean = false)
		{
			//if(baseObj.type == ActorType.Pet){
				if(baseObj.owner == zone._myRid){
					mine = true;
				}
			//}
			super(baseObj,zone,initView);
			if(baseObj.type == ActorType.BigMonster || baseObj.type == ActorType.Guard || baseObj.type == ActorType.BOSS || baseObj.type == ActorType.Monster || baseObj.type == ActorType.Pet || baseObj.type == ActorType.StaticMonster||baseObj.type == ActorType.Ems){
				var cfgs:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
				var mcfg:Object = cfgs[ConfigData.MONSTER];
				if(mcfg){
					_cfg = mcfg[baseObj.mid];
					moveInterval = _cfg.moveInterval;//移动一格的间隔
					playerModel = _cfg.playerModel == 1;
					if(_cfg.clientspeed > 0){
						_speed = int(_cfg.clientspeed) / 100;
					}else{
						if(this.playerModel || (baseObj.type == ActorType.Pet && _cfg.isrun == 1))
							_speed = 48  / Math.min(moveInterval ,1000) * (1/Config.fps * 1000) * 1.1;//怪物移动速度根据配置计算
						else
							_speed = 48  / Math.min(moveInterval ,1000) * (1/Config.fps * 1000) * 1.5 ;//怪物移动速度根据配置计算
					}
					if(_cfg.isrun == 1){
						_speed = _speed * 0.5;
					}
					baseObj.sex = _cfg.sex;
					if(int(_cfg.bloodY) > 0){
						_info.mbloadY = _cfg.bloodY;
						_info.nameY = _info.mbloadY + 35;
					}
				}
			}
			/*var saycfgs:Object = ConfigDictionary.data.monstersay;
			if(saycfgs[baseObj.mid]){
				if(saycfgs[baseObj.mid].say){//随机说话
					_words = saycfgs[baseObj.mid].say;
					_sayrates = saycfgs[baseObj.mid].sayrate;
					if(_words.length > 0){
						addHeartBeats();
					}
				}
				if(saycfgs[baseObj.mid].skillsay){//随机说话
					_skillWords = saycfgs[baseObj.mid].skillsay;
					_skillrates = saycfgs[baseObj.mid].skillrate;
				}
				if(saycfgs[baseObj.mid].killsay){//随机说话
					_killWords = saycfgs[baseObj.mid].killsay;
					_killrates = saycfgs[baseObj.mid].killrate;
				}
			}*/
			_model = _cfg.model;
			this._skin = this._animalSkin = this.rpgSkin = monsterSkin =  new MonsterSkin(this,_model);
			this.enabled = true;
			//new TestMove(this);
		}
		
		/**
		 * 设置行走路线,并开始走动
		 */
		override public function setPath(path:Array,pingyi:Boolean = false):Boolean{
			if(this.canProcess)
				return super.setPath(path,pingyi);
			return false;
		}
		
		public function addAI(ai:IAIScript):void{
			this._ai = ai;
		}
		
		override public function update(gameTime:GameTime):void{
			if(_ai != null){
				_ai.update(gameTime);
			}
			super.update(gameTime);
		}
		
		public function get monsterCfg():Object{
			return this._cfg;
		}
		
		private function addHeartBeats():void{
			_heartId = setInterval(heartBeats,Math.random() * 10000 + 5000);
		}
		
		private function heartBeats():void
		{
			if(this.inView){
				this.autoSay(0);
			}
		}
		/**
		 * 受伤
		 */
		override public function hurt(hp:int,curhp:int,total:int,showTips:Boolean ,hit:int,hurtTime:int):void{
			if(!_zone)
				return;
			if(showTips && curhp > 0){
				this.takeCare();
			}
			if(this.dead){
				curhp = 0;
				_info.showBlood(false);
				_lastUpdateHp = hurtTime;
			}else{
				if(_lastUpdateHp <= hurtTime || hurtTime == 0){
					setHp(curhp);
					if(curhp == 0)
						_info.showBlood(false);
					_lastUpdateHp = hurtTime;
				}else{
					if(gameObj)
						curhp = this.gameObj.hp;
				}
			}
			
			if(rpgSkin){
				if(hp <= 0){
					var dir:int = 0;
					if(this._zone.myRole){
						/*if(this._zone.myRole.cellX < this.cellX){
						dir = 2;
						}else if(this._zone.myRole.cellY > this.cellY){
						dir = 6;
						}*/
						dir = DirectionUtil.getForwardByGridXY(this._zone.myRole.cellX,this._zone.myRole.cellY,this.cellX,this.cellY);
					}
					hurtEffect(hp,curhp,total,showTips,dir,hit);
				}else if(hp > 0){
					this.cure(hp,curhp,total,showTips);
				}
				if(this.gameObj.baseObj.beBuffers){
					if(this.gameObj.baseObj.beBuffers[2981]){//触发魔法盾
						this.bufferPlay(2981);
					}else if(this.gameObj.baseObj.beBuffers[21010]){//触发魔法盾
						this.bufferPlay(21010);
					}
				}
				
			}
		}
		public function autoSay(type:int):void{
			var words:Array;
			var rates:Array;
			switch(type){
				case 0:words = this._words;rates = this._sayrates;break;
				case 1:words = this._skillWords ;rates = this._skillrates;break;
				case 2:words = this._killWords ;rates = this._killrates;break;
			}
			if(words && words.length > 0 && words.length == rates.length){
				var r:int = Math.random() * 10000 + 1;
				var total:int = 0;
				for (var i:int = 0;i < rates.length; i++) 
				{
					total = total + int(rates[i]);
					if(total >= r){
						this.speak(words[i]);
						break;
					}
				}
			}
		}
		
		override protected function getName(user:Object):String{
			var str:String = user.name;
			if(user.showname == 1)
			{
				return "";
			}
			if(user.type == ActorType.Monster ){
				str = str + "[" +user.level+ "级]";
			}
			return str;
		}
		
		protected override function createComponent() : void
		{
			this.enabled = true;
		}
		
		
		override public function initModels():void{
			if(this.playerModel)
				this.monsterSkin.setSkin(ElementSkinType.CLOTHING_FOOT,_model,Config.clothSkinPath);
			else
				this.monsterSkin.setSkin(ElementSkinType.MONSTER,_model,Config.monsterPath);
			if(_cfg&&_cfg.unshandow==1)
			{
				//this.monsterSkin.setSkin(ElementSkinType.SHADOW,_model,null);
			}
			else{
				if(this.playerModel){
					this.monsterSkin.addCommonShadow();
				}else{
					this.monsterSkin.addCommonShadow();
				}
			}
			/*var weaponCfg:Object = ConfigDictionary.data.monsterArms;
			if(weaponCfg[this.gameObj.baseObj.mid] != null){
				this._wingModel = weaponCfg[this.gameObj.baseObj.mid].wing;
				this._weaponModel = weaponCfg[this.gameObj.baseObj.mid].weapon;
				if(_weaponModel > 0)
					this.rpgSkin.setSkin(ElementSkinType.WEAPON_FOOT,_weaponModel + "",Config.weaponSkinPath);
				if(_wingModel > 0){
					this.addWing();
				}
			}*/
		}
		
		private function addWing():void{
			if(_wingModel > 0 && rpgSkin.getDataSets(ElementSkinType.WING) == null)
				this.rpgSkin.setSkin(ElementSkinType.WING,_wingModel + "",Config.wingSkinPath);
		}
		
		/**
		 * 隐藏翅膀 
		 * @param value
		 */
		override public function showWing(value:Boolean):void{
			if(value == false){
				if(this.rpgSkin.getDataSets(ElementSkinType.WING)){
					this.rpgSkin.removeType(ElementSkinType.WING);
				}
			}else{
				if(!this.rpgSkin.getDataSets(ElementSkinType.WING)){
					addWing();
					this.setAction(this.action,-1,true);
				}
			}
		}
		
		/**
		 * 初始化显示对象
		 */
		override protected function initView():void{
			super.initView();
			if(_cfg.aperture == 2)
			{
				//boss脚下光圈
				this.addEffectByEid(Constant.Aperture2,true,0);
				
			}else if(_cfg.aperture == 1)
			{
				//精英怪脚下光圈
				this.addEffectByEid(Constant.Aperture1,true,0);
			}
		}
		
		
		override public function die(play:Boolean = true):void{
			super.die(play);
			this._info.showBlood(false);
		}
		
		override public function addRoleToView(layer:GameSprite, alphaTween:Boolean=false):void{
			super.addRoleToView(layer,alphaTween);
		}
		
		/**
		* 更新名字颜色
		*/
		override public function updateNameColor():void
		{
			if(!rpgSkin)
				return;
			var color:uint ;
			if(this.gameObj.baseObj.type != ActorType.Pet){
				if(int(this._cfg.color)> 0){
					color = MColor.getColorUint(_cfg.color);
					this.setNameColor(color);
					return;
				}
			}
			if(this._zone.myRole.gameObj.baseObj.league > 0){
				if( this.gameObj.baseObj.league != this._zone.myRole.gameObj.baseObj.league)
					this.setNameColor(MColor.UnionOpp);
				else
					this.setNameColor(MColor.UnionFriend);
				return;
			}
			if(int(this._cfg.color)> 0){
				color = MColor.getColorUint(_cfg.color);
				this.setNameColor(color);
				return;
			}
			
		}
		
		override public function dispose():void{
			super.dispose();
			monsterSkin = null;
			_killWords = null;
			_skillWords = null;
			_skillrates = null;
			_killrates = null;
			_sayrates = null;
			candig = false;
			dazibao = false;
			_weaponModel = 0;
			_wingModel = 0;
		}
		
		override public function hitTestBmp(x:int, y:int):Boolean
		{
			if(this._cfg.type == MonsterType.Fashen)
				return false;
			else if(this.mine && this._cfg.type == MonsterType.Pet)
				return false;
			return super.hitTestBmp(x,y);
		}
		
		/**
		* 关心级别 0:不关心
		*/
		override protected function getCareLevel():int{
			return 2;
		}
		
		override protected function playHurt():void{
			if(!this.dead && !this.playerModel &&  this.action == ActionType.STAND && this._cfg.type != MonsterType.Pet && this._cfg.type != MonsterType.Guard){
				this.setAction(ActionType.HURT);
			}
		}
		
		override protected function addBufferEff(eid:int, bufferid:int, loop:Boolean=true, pos:int=-1):void{
			if(_cfg && _cfg.type == MonsterType.Fashen && (eid == 35 || eid == 36))
				return;
			super.addBufferEff(eid,bufferid,loop,pos);
		}
		
		/**
		 * 是否可操作
		 * 40312 麻痹   40240 晕眩 
		 */
		public function get canProcess():Boolean{
			if(this.dead || this.getBuffer(BufferID.DING_SHEN) ){
				return false;
			}
			return true;
		}
		
		/**
		 * 检测是否群攻的对象
		 * @return 
		 */
		override public function get inGroup():Boolean{
			if(_cfg.type == MonsterType.Normal || _cfg.type == MonsterType.BigMonster || _cfg.type == MonsterType.Boss)
				return true;
			return false;
		}
	}
}