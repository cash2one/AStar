package com.rpg.scene.actor
{
	
	import com.core.utils.goem.Vector2D;
	import com.mgame.battle.Zone;
	import com.rpg.entity.Animal;
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.GameSprite;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.ArmPosType;
	import com.rpg.enum.Constant;
	import com.rpg.enum.EffectType;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.transfer.ITweenAble;
	import com.rpg.framework.system.transfer.Tween;
	import com.rpg.framework.utils.TimeOutManager;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneLayer;
	import com.rpg.scene.actor.skin.RPGAnimalSkin;
	import com.rpg.scene.control.DisposeManager;
	import com.rpg.scene.model.CmdVO;
	import com.rpg.scene.model.GameObject;
	import com.sh.game.global.Config;
	import com.sh.game.util.BooleanArray;
	import com.sh.game.util.DirectionUtil;
	import com.sh.game.util.MColor;
	
	import consts.BufferID;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import util.FilterSet;
	
	
	
	public class RPGAnimal extends Animal implements ITweenAble
	{
		/**
		 * 人形
		 */
		public var playerModel:Boolean = false;
		/**
		 *  是否初始化过
		 */
		private var _inited:Boolean = false;
		/**
		 * 特效动画
		 
		private var _effMovies:Dictionary;*/
		//public var inBlock:Point = new Point();
		
		public var _nameLayer:GameSprite;//zone的名字层
		public var _mcLayer:GameSprite;//底层物体层
		
		private static var _rect:Rectangle = new Rectangle(-Constant.CELL_WIDTH/2,-Constant.CELL_HEIGHT,Constant.CELL_WIDTH,Constant.CELL_HEIGHT * 3/2);
		
		
		/**
		 *心跳 
		 */
		protected var _heartId:uint;
		
		/**
		 * 名字的位置
		 */
		protected var _nameY:int = 0;
		
		/**
		 * 羽翼
		 */
		private var _wing:Object;
		/**
		 * 装备
		 */
		private var _arms:Object;
		
		
		
		/** 光武类型 
		 * 1: 普通武器
		 * 2: 扇子武器
		
		private var _weaponEfftype:int = 1; 
		
		private var _armEfftype:int = 1;*/
		
		private var _model:String = "";
		
		private var _disposed:Boolean = false;
		
		private var _stallage:Boolean = false;
		
		/**
		 * Y轴偏移
		 */
		public var offsetY:int = 0;
		
		/**
		 * 角色y轴偏移 
		 */
		public var roleOffsetY:int = 0;
		
		/**时装*/
		protected var _fashions:Object;
		protected var _fashionCfg:Object;
		
		protected var _gameObj:GameObject;
		
		protected var _zone:Zone;
		
		
		protected var _slowDown:Number = 0; 
		
		/**
		 * 平移中，如受到野蛮冲撞
		 */
		public var pingyi:Boolean = false;
		/**
		 * 路径
		 */
		protected var _path:Array;
		/**
		 * 移动目标点
		 */
		public var targetXY:Point = null;
		/**
		 * 当前速度
		 */
		public var vector:Point = null;
		/**
		 * 战斗状态
		 */
		protected var _state:int = 0;
		/**
		 * 移动中
		 */
		public var moving:Boolean = false;
		/**
		 * 是否关心 ，控制血条 、名字显示
		 */
		protected var cared:Boolean = false;
		
		protected var _lastUpdateHp:int = 0;
		
		/**
		 * 是否移动过
		 */
		public var moved:Boolean = true;
		
		/**
		 *  1 : 走路
		 *  2：跑步
		 *  3：坐骑移动
		 *  5：野蛮冲撞
		 */
		public var moveType:int = 0;
		
		/**
		 * 是否是匿名战场
		 */
		protected var _anonymity:Boolean = false;
		/**
		 * 我自己的宠物，或是自己
		 */
		public var mine:Boolean;
		
		protected var _curPoint:Point;
		
		/**
		 * 不可重叠特效
		 */
		protected var _effects:Dictionary = new Dictionary();
		
		/**
		 * 是否被遮挡
		 */
		protected var _mask:Boolean = false;
		protected var _hide:Boolean = false;		//隐身术
		protected var _cfg:Object;						//怪物或npc配置
		protected var _words:Array;					//怪物或npc要说的废话
		
		protected var _onHorse:Boolean = true;	
		public var horseEffect:String;				//坐骑路径特效
		public var fashionEff:String;				//时装足迹特效
		protected var _sit:Boolean = false; //骑乘中
		protected var _speed:Number = 0;
		
		/**变身*/
		public var bianShen:Boolean = false;
		
		/**
		 * 下一击 攻杀剑法
		 */
		public var gongsha:Boolean = true;
		public static var cfgHorse:Object;		//坐骑配置
		/**
		 * 动作消息队列
		 */
		public var actionList:Vector.<CmdVO>;
		protected var _busy:int = 0;
		
		protected var _moveInterval:int = 0;
		public var cuttitle:int = 0;
		protected var _focus:Boolean = false;
		protected var _fashionsShow:BooleanArray;
		
		protected var _tween:Tween;
		
		protected var _info:RPGAnimalInfos;
		
		protected var _dead:Boolean = false;
		
		/**
		 * 幻影 bitmap 
		 */
		private var huanying:Array;
		
		protected var _isMe:Boolean = false;
		
		public function RPGAnimal(baseObj:Object,zone:Zone,initView:Boolean = false)
		{
			//super();
			//this.setValue(ElementValueType.CLOTHING,0);
			this.layer = ElementBase.LAYER_ROLE;
			this.type = baseObj.type;
			this._zone = zone;
			this._nameLayer = _zone.getLayer(ElementBase.LAYER_NAME);
			this._mcLayer = _zone.getLayer(ElementBase.LAYER_EFFECT);
			this.dir = baseObj.dir;
			this.id = baseObj.id;
			this.gameObj = new GameObject(baseObj);
			this._dead = baseObj.death;
			_info = new RPGAnimalInfos(this);

			this.x = gameObj.x;
			this.y = gameObj.y;
			actionList = new Vector.<CmdVO>();
			//this._skin = this._animalSkin = this.rpgSkin =   new RPGAnimalSkin(this);
			_tween = ObjectPoolManager.getInstance().borrowItem(Constant.TweenClass) as Tween;
			_tween.moveComplete = onMoveComplete;
			_tween.moveStep = onMoveStep;
			_tween.display = this;
			this.components.add(_tween);
			this._fashions = baseObj.fashions;
		}
		
		/**
		 *血量最后更新时间 
		 */
		public function get lastUpdateHp():int
		{
			return _lastUpdateHp;
		}

		/**
		 * @private
		 */
		public function set lastUpdateHp(value:int):void
		{
			_lastUpdateHp = value;
		}

		public function get zone():Zone{
			return this._zone;
		}
		
		/*public override function addChild(item : GameSprite) : void
		{
			if (item is ElementBase)
			{
				var element : ElementBase = item as ElementBase;
				_elements[element.id] = item;
			}
			super.addChild(item);
		}
		
		public override function removeChild(item : GameSprite) : void
		{
			if (item is ElementBase)
			{
				var element : ElementBase = item as ElementBase;
				delete _elements[element.id];
			}
			super.removeChild(item);
		}*/
		
		private var stepCount:int = 0;
		//private var hyAlphaCount:int = 0;
		
		protected function onMoveStep():void
		{
			_slowDown= 0;
			if(this.moveType == 5){
				if(stepCount >= 1){
					if(this._skin && _skin.inView){
						var bitmap:Bitmap = this._skin.getChildByName(ElementSkinType.CLOTHING_FOOT) as Bitmap;
						if(bitmap && bitmap.bitmapData){
							var bmd:BitmapData = bitmap.bitmapData;
							var hy:Bitmap = new Bitmap(bmd);
							hy.x = bitmap.x + this.x;
							hy.y = bitmap.y + this.y;
							hy.scaleX = bitmap.scaleX;
							if(this.dir == 3 || dir == 4 || dir == 5){
								this._zone._skillLayer2.display.addChild(hy);
							}else
								this._zone._skillLayer.display.addChild(hy);
							if(huanying == null)
								huanying = new Array();
							huanying.push(hy);
						}
					}
					stepCount=0;
				}else{
					stepCount++;
				}
			}
		}
		
		private function updateHuanying():void
		{
			if(huanying != null && huanying.length > 0){
				//if(hyAlphaCount >= 1){
					var i:int = 0;
					var j:int = 0;
					while(i < huanying.length){
						var bmp:Bitmap = huanying[i];
						bmp.alpha = bmp.alpha - 0.1;
						if(bmp.alpha <= 0){
							huanying.splice(i,1);
							bmp.bitmapData = null;
							if(bmp.parent)
								bmp.parent.removeChild(bmp);
						}else
							i++;
					}
					if(huanying.length == 0)
						huanying = null;
					/*hyAlphaCount=0;
				}else{
					hyAlphaCount++;
				}*/
			}
		}
		
		public function onMoveComplete(time:int):void
		{
			this.endMove();
			if(!this.isMe())
				this.slowDown = time + 100;
			else
				this.slowDown = time;
			var parentLayer:SceneLayer = this._zone.getLayer(this.layer);
			parentLayer.needSort();
			/*switch (direction)
			{
				case DirectionType.UP:
				case DirectionType.LEFT_UP:
				case DirectionType.RIGHT_UP:
					parentLayer.needSort();
					break;
				case DirectionType.DOWN:
				case DirectionType.LEFT_DOWN:
				case DirectionType.RIGHT_DOWN:
					parentLayer.needSort();
					break;
				default:
					break;
			}*/
			
			// 判断是否走到半透明区
			this.setTranslucence();
		}
		
		/**
		 * 文本显色
		 * @param value 状态值
		 * 
		 */			
		public function setTextColor(value : String) : void {}
		
		
		/** 设置人物起启点 */
		public override function setPosition():void
		{
			if (this.parent)
			{
				super.setPosition();
				this.setTranslucence(); // 判断半透明区
			}
		}
		
		private function setTranslucence():void
		{
				this.rpgSkin.alpha = 1;
		}
		
		protected override function createComponent() : void
		{
			/*rpgSkin = new RPGAnimalSkin(this);
			this._skin = this._animalSkin = rpgSkin;
			this.enabled = true;*/
		}
		
		override public function initialize():void{
			//super.initialize();
		}
		
		
		
		//roleManager
		public function get moveInterval():int
		{
			return _moveInterval;
		}
		
		public function set moveInterval(value:int):void
		{
			_moveInterval = value;
		}
		
		/**
		 * 基础属性
		 */
		public function get gameObj():GameObject
		{
			return _gameObj;
		}
		
		/**
		 * @private
		 */
		public function set gameObj(value:GameObject):void
		{
			_gameObj = value;
		}
		
		public function get focus():Boolean
		{
			return _focus;
		}
		
		public function set focus(value:Boolean):void
		{
			_focus = value;
			if(!this.isMe()){
				if(_focus)
					this.rpgSkin.setFocus(2,1);//this._zone.process.checkTarget(this.gameObj.baseObj));
				else
					this.rpgSkin.setFocus(0);
			}
		}
		
		
		/**温泉拥抱*/
		/*public function set hug(trid:int):void{
		if(this._zone.wenquan){
		if(trid>0){
		if(rpgSkin){
		rpgSkin.setAction(ActionType.BATTLE_STAND);
		rpgSkin.removeEffect("11169",1);
		}
		}else{
		if(rpgSkin){
		rpgSkin.setAction(ActionType.STAND);
		rpgSkin.addEffect("11169",true,0,1);
		}
		}
		}
		this.gameObj.baseObj.WQyb = trid;
		}*/
		
		/*public function get hidefilter():Boolean
		{
		return _hidefilter;
		}
		
		public function set hidefilter(value:Boolean):void
		{
		_hidefilter = value;
		if(rpgSkin){
		rpgSkin.hidefilter = value;
		}
		}*/
		
		
		override public function get dead():Boolean
		{
			return _dead;
		}
		
		public function set dead(value:Boolean):void
		{
			if(this.gameObj)
				this.gameObj.baseObj.death = value;
			_dead = value;
		}
		
		/**
		 * 是否是玩家自己
		 */
		public function isMe():Boolean{
			return this._isMe;
		}
		
		/**
		 * 移动停止 切换至站立动作延时
		 */
		public function get slowDown():Number
		{
			return _slowDown;
		}
		
		public function set slowDown(value:Number):void
		{
			_slowDown = value;
		}
		
		
		public function digBusy():void{
			_busy = getTimer() + 2000;
		}
		/**
		 * 攻击后摇
		 */
		public function attackBusy():void{
			_busy = getTimer() + Constant.AttackDelay;
		}
		/**
		 * 自动拾取后摇
		 */
		public function pickUpBusy():void{
			_busy = getTimer() + Constant.PickUpDelay;
		}
		/**
		 * 移动后摇
		 */
		public function moveBusy(speed:int):void{
			_busy = getTimer() + speed;
		}
		/**
		 * 法术后摇
		 */
		public function skillBusy(skill:Object):void{
			if(skill.action ==0||skill.action==1){
				_busy = getTimer() + Constant.AttackDelay;
			}
		}
		/**
		 * 攻击后摇到期时间
		 */
		public function get busy():Boolean
		{
			if(!this.rpgSkin)return false;
			if(_busy > getTimer()){
				return true;
			}
			return false;
			//return this.rpgSkin.curAction == ActionType.ATTACK ||  this.rpgSkin.curAction == ActionType.ATTACK_SPECIAL;
		}
		
		public function get canMove():Boolean{
			return !busy;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			_state = value;
			/*if(rpgSkin){
			rpgSkin.state = value;
			}*/
			if(!this._zone)
				return;
			/*if(value == 0){
			this._zone.clearCared();
			}*/
		}
		
		public function get dir():int
		{
			return direction;
		}
		
		override public function set dir(value:int):void
		{
			if(value >= 8)
				value -= 8;
			if(this.gameObj){
				gameObj.baseObj.dir = value;
			}
			super.dir = value;
		}
		
		
		/**
		 * 人物之间遮挡
		 */
		public function set mask(value:Boolean):void{
			if(this.rpgSkin){
				this.rpgSkin.mask = value;
			}
			_mask = value;
		}
		
		/**
		 * 隐身术
		 */
		public function set hide(value:Boolean):void{
			if(value)
			{
				if(this.rpgSkin){
					this.rpgSkin.alpha = 0.6;
				}
			}else if(!this._zone.mapData.hitTestCover(this.x,this.y)){
				this.rpgSkin.alpha = 1;
				if(this.rpgSkin){
					this.rpgSkin.alpha = 1;
				}
			}
			_hide = value;
		}
		
		public function get hide():Boolean
		{
			return _hide;
		}
		
		
		public function updateArms(arms:Object,fashion:Object):void{
			if(_stallage || this.bianShen){
				return;
			}
			this._arms = arms;
			this._fashions = fashion;
			var hand:String = null;
			var body:String =null ;
			var head:String = null;
			var weaponEff:String = null;
			var armEff:String = null;
			var weaponeffType:int = 1;
			var armeffType:int = 1;
			for each(var pos:int in ArmPosType.roleArms){
				var fpos:int = ArmPosType.armToFashionPos(pos);
				var fmodel:int = 0;
				var arm:Object = null;
				if(arms && arms[pos] != null)
					arm = arms[pos];
				if(arm == null && fmodel < 0)
					continue;
				switch(pos){
					case ArmPosType.PosWeapon:
						if(this._sit)
							break;
						if(fmodel >= 0){
							hand = fmodel + "";
						}else if(arm){
							hand = getArmModel(arm);
							weaponEff = getArmEffect(arm);
							weaponeffType = arm.efftype;
						}
						break;
					case ArmPosType.PosClothes:
						if(fmodel >= 0){
							body = fmodel + "";
						}else if(arm){
							body = getArmModel(arm);
							armEff = getArmEffect(arm,true);
							armeffType = arm.efftype;
						}
						break;
				}
			}
			if(body == null){
				body = this.gameObj.baseObj.model;
			}
			if(hand == null && this.gameObj.baseObj.type == ActorType.Actor){
				hand = (int(this.gameObj.baseObj.model) + 100 )+ "";
			}
			var shadow:String;
			if(this.gameObj.baseObj.sex == 1)
				shadow = Constant.SHADOW_MAN;
			else
				shadow = Constant.SHADOW_WOMAN;
			if(changeModels(body,hand,shadow)){
				this.setAction(this.action,-1,true);
			}
			this.preloadActions();
		}
		
		public function updateWing(wing:Object):Boolean{
			//return false;
			if( this.bianShen){
				return false;
			}
			var model:String = null;
			_wing = wing;
			if(wing){
				model = getWingModel(int(wing));
			}
			//model = "4101";
			if(this.rpgSkin.getDataSets(ElementSkinType.WING) == null){
				if(model != null){
					this.rpgSkin.setSkin(ElementSkinType.WING,model,Config.wingSkinPath);
				}
			}else
			if(model != this.rpgSkin.getDataSets(ElementSkinType.WING).model){
				this.rpgSkin.removeType(ElementSkinType.WING);
				if(model != null){
					this.rpgSkin.setSkin(ElementSkinType.WING,model,Config.wingSkinPath);	
				}
				return true;
			}
			return false;
		}
		
		/**
		 * 隐藏翅膀 
		 * @param value
		 */
		public function showWing(value:Boolean):void{
			
		}
		
		public function getWingModel(wing:int):String{
			var level:int = wing;
			var model:String = null;
			var cfg:Object = ConfigDictionary.data.wing;
			if(cfg[level]){
				model = cfg[level].model;
			}
			return model;
		}
		
		protected function changeModels(body:String,hand:String,shadow:String):Boolean{
			var hasChange:Boolean = false;
			var bodytype:String;
			if(playerModel)
				bodytype = ElementSkinType.CLOTHING_FOOT;
			else
				bodytype = ElementSkinType.MONSTER;
			if(this.rpgSkin.getDataSets(bodytype) == null){
				if(body ==  ElementSkinType.CLOTHING_FOOT)
				{
					this.rpgSkin.setSkin(bodytype,body,Config.clothSkinPath);
					this.rpgSkin.setSkin(ElementSkinType.SHADOW_OUT,shadow,Config.shadowPath);

				}else{
					this.rpgSkin.setSkin(bodytype,body,Config.monsterPath);
					this.rpgSkin.setSkin(ElementSkinType.SHADOW_OUT,shadow,Config.shadowPath);

				}
				hasChange = true;
			}else if(body != this.rpgSkin.getDataSets(bodytype).model){
				this.rpgSkin.removeType(bodytype);
				this.rpgSkin.removeType(ElementSkinType.SHADOW_OUT);
				if(body ==  ElementSkinType.CLOTHING_FOOT)
				{
					this.rpgSkin.setSkin(bodytype,body,Config.clothSkinPath);
					this.rpgSkin.setSkin(ElementSkinType.SHADOW_OUT,shadow,Config.shadowPath);
					
				}else{
					this.rpgSkin.setSkin(bodytype,body,Config.monsterPath);
					this.rpgSkin.setSkin(ElementSkinType.SHADOW_OUT,shadow,Config.shadowPath);
					
				}
				hasChange = true;
			}
			if(this.rpgSkin.getDataSets(ElementSkinType.WEAPON_FOOT) == null){
				if(hand != null){
					this.rpgSkin.setSkin(ElementSkinType.WEAPON_FOOT,hand,Config.weaponSkinPath);
					hasChange = true;
				}
			}else	if(hand != this.rpgSkin.getDataSets(ElementSkinType.WEAPON_FOOT).model){
				this.rpgSkin.removeType(ElementSkinType.WEAPON_FOOT);
				if(hand != null){
					this.rpgSkin.setSkin(ElementSkinType.WEAPON_FOOT,hand,Config.weaponSkinPath);
				}
				hasChange = true;
			}
			return hasChange;
		}
		
		private function addWeaponEff(weaponEff:String, weaponeffType:int, param2:int):void
		{
			
		}
		
		private function removeWeaponEffect():void
		{
			
		}
		
		public function getArmEffect(arm:Object,clothes:Boolean = false):String{
			if(this._sit)
				return null;
			var effs:Array;
			if(arm.effect && arm.effect != ""){
				effs = (String(arm.effect)).split("/");
				if(effs.length == 2){
					if(arm.superlevel < 10){
						if(effs[0] != "0")
							return effs[0];
						else
							return null;
					}else if(arm.superlevel >= 10){
						if(effs[1] != "0")
							return effs[1];
						else
							return null;
					}
				}else
					return null;
				//}
			}else{
				return null;
			}
			return null;
		}
		
		public function getArmModel(arm:Object):String{
			var arr:Array = (arm.model + "").split("/");
			if(arr.length ==2){
				if(this.gameObj.baseObj.model == "0"){
					return arr[0];
				}else{
					return arr[1];
				}
			}
			return arm.model;
		}
		
		/**
		 * 更新装备
		 */
		public function refreshArms(arms:Object):void{
			if(this.rpgSkin){
				this.gameObj.baseObj.arms = arms;
				var tamparms:Object = arms;
				this.updateArms(tamparms,gameObj.baseObj.fashions);
				/*呵呵if(!this.onHorse){
				this.rpgSkin.updateWing(tampwing);
				}
				this.rpgSkin.updateArms(tamparms,gameObj.baseObj.fashions);*/
			}
		}
		
		public function getFashionShow(type:int):Boolean{
			if(!this.gameObj){
				return false;
			}
			if(!_fashionsShow)
				_fashionsShow = new BooleanArray(this.gameObj.baseObj.ytshow);
			return !_fashionsShow.getValue(type);
		}
		
		public function getItemBuffer(id:int):Object{
			if(this.gameObj && this.gameObj.baseObj.itemBuffers && this.gameObj.baseObj.itemBuffers[id]){
				return this.gameObj.baseObj.itemBuffers[id];
			}
			return null;
		}
		
		public function getBuffer(id:int):Object{
			if(this.gameObj && this.gameObj.baseObj.beBuffers && this.gameObj.baseObj.beBuffers[id])
				return this.gameObj.baseObj.beBuffers[id];
			return null;
		}
		
		public function checkBuffers():void{
			return;
			if(this.gameObj.baseObj.beBuffers){
				for (var key:Object in this.gameObj.baseObj.beBuffers){
					if(key == 30610 || key == 40250){
						this.hide = true;
					}else if(key == 30310){//毒
						this.rpgSkin.addFilter(2);
					}else if(key == BufferID.JIAN_SU){//减速
						this.rpgSkin.addFilter(3);
					}else if(key == BufferID.DING_SHEN){//麻痹
						this.rpgSkin.addFilter(1);
					}else if(key == 1104){//麻痹
						this.rpgSkin.addFilter(1);
					}else if(key == BufferID.ZHUO_SHAO){//灼烧
						this.rpgSkin.addFilter(4);
					}
				}
			}
		}
		
		/**
		 * 添加buffer
		 */
		public function addBuffer(arg:Object,showEff:Boolean = true):void{
			var id:int = arg.bufferid;
			if(!this.gameObj.baseObj.beBuffers){
				this.gameObj.baseObj.beBuffers = new Object();
			}
			if(id == 30310){//毒
				if(rpgSkin)
					this.rpgSkin.addFilter(2);
			}else if(id == BufferID.DING_SHEN){//麻痹
				if(rpgSkin)
					this.rpgSkin.addFilter(1);
				this.setAction(ActionType.STAND,-1);
			}else if(id == 1104){//麻痹
				if(rpgSkin)
					this.rpgSkin.addFilter(1);
			}else if(id ==BufferID.JIAN_SU){//冰冻
				if(rpgSkin)
					this.rpgSkin.addFilter(3);
			}else if(id == BufferID.ZHUO_SHAO){//灼烧
				if(rpgSkin)
					this.rpgSkin.addFilter(4);
			}
			/*else if(id == 1101||id == 1102||id == 1103)
			{
				addBufferEff(98,id,false);
			}*/
			var time:Number = this._zone.servertime + getTimer();
			arg.removetime = time +int( arg.dispelTime * 1000);
			this.gameObj.baseObj.beBuffers[id] = arg;
			/*if(showEff && rpgSkin){
				var cfgEffect:Object = ConfigDictionary.data.bufferEffects;
				if(cfgEffect && cfgEffect[id]){
					for each(var eff:Object in cfgEffect[id]){
						if(eff.type == 0){
							TimeOutManager.getInstance().setTimer(addBufferEff,eff.delaytime,eff.model,id,true,eff.pos);
							//setTimeout(addBufferEff,eff.delaytime,eff.model,id,true,eff.pos);
						}
					}
				}
			}*/
		}
		
		protected function addBufferEff(eid:int,bufferid:int,loop:Boolean = true,pos:int = -1):void
		{
			if(!this.enabled)
				return;
			if(!this.buffs[bufferid]){
				var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,null,EffectType.NORMAL,loop);
				mc.init(eid,null,EffectType.NORMAL,loop);
				mc.pos = pos;
				mc.setAutoid();
				var index:int = -1;
				if(pos == 0){
					index = 0;
				}
				this.addEffect(mc,index);
				this.buffs[bufferid] = mc;
				mc.y = -this.offsetY;
			}
		}
		
		private function removeBufferEff(bufferid:int):void{
			if(this.buffs[bufferid]){
				this.removeEffect(this.buffs[bufferid].id);
				this.buffs[bufferid] = null;
			}
		}
		
		public function addEffectByEid(eid:int,loop:Boolean = true,pos:int = -1,dir:int = -1):Effect{
			if(!this._effects[eid]){
				var mc:Effect = ObjectPoolManager.getInstance().borrowItem(Constant.EffectClass) as Effect;//new Effect(eid,null,EffectType.NORMAL,loop,dir);
				mc.init(eid,null,EffectType.NORMAL,loop,dir);
				mc.pos = pos;
				mc.setAutoid();
				var index:int = -1;
				if(pos == 0){
					index = 0;
				}
				this.addEffect(mc,index);
				this._effects[eid] = mc;
				return mc;
			}
			return null;
		}
		
		private function checkYinshenBuffer():void{
			
		}
		
		/**
		 * 移除buffer
		 */
		public function removeBuffer(id:int):void{
			this.gameObj.baseObj.beBuffers[id] = null;
			delete this.gameObj.baseObj.beBuffers[id];
			if(rpgSkin){
				//removeBuffer(id);
				/*_buffers[id] = null;
				delete _buffers[id];*/
				this.removeBufferEff(id);
				if(id == 30610 || id == 40250){
					this.hide = false;
				}else if(id == 30310){//毒
					this.rpgSkin.clearFilter(2);
				}else if(id == BufferID.DING_SHEN){//麻痹
					this.rpgSkin.clearFilter(1);
				}else if(id == 1){//麻痹
					this.rpgSkin.clearFilter(3);
				}else if(id == 1104){//麻痹
					this.rpgSkin.clearFilter(1);
				}else if(id == BufferID.ZHUO_SHAO){//灼烧
					this.rpgSkin.clearFilter(4);
				}
			}
		}
		
		/**
		 * buffer触发动画
		 */
		public function bufferPlay(id:int):void{
			if(rpgSkin){
				var cfgEffect:Object = ConfigDictionary.data.bufferEffects;
				if(cfgEffect && cfgEffect[id]){
					for each(var eff:Object in cfgEffect[id]){
						if(eff.type == 1){
							if(this.buffs[id]){
								(this.buffs[id] as Effect).setAction(ActionType.WALK,-1,true);
								(this.buffs[id] as Effect).endFunc = this.bufferPlayEnd;
							}
							//setTimeout(bufferPlay,eff.delaytime,eff.model,id,eff.pos,eff.action,eff.blendmode);
						}
					}
				}
			}
		}
		
		private function bufferPlayEnd(id:int):void{
			var eff:Effect = this._elements[id];
			if(eff){
				eff.setAction(ActionType.RUN,-1,true);
				eff.endFunc = null;
			}
		}
		
		/**
		 * 在场景中显示角色
		 */
		public function addRoleToView(layer:GameSprite,alphaTween:Boolean = false):void{
			this.addSkin();
			if(!_inited){
				this.initView();
				_inited = true;
			}else{
				if(this.dead && this.rpgSkin)
					this.rpgSkin.playEnd = true;
			}
			if(alphaTween){
				this.rpgSkin.tweenShow();
			}
			//checkTeamer();
		}
		
		protected function initView():void{
			var user:Object = this.gameObj.baseObj;
			
			var arms:Object = user.arms;
			var wing:Object = user.wing;
			
			if(user.dir >= 8){
				user.dir -= 8;
			}
			var defaultAction:int = ActionType.STAND;
			if(this.moving && !user.onhorse){
				if(this.moveType == 1)
					defaultAction = ActionType.WALK;
				else
					defaultAction = ActionType.RUN;
			}
			
			var _myRid:int = _zone._myRid;
			
			var cfgHs:Object;
			var hid:int ;
			if(this.dead)
				defaultAction = ActionType.DIE;
			
			if(user.dir != -1)
				this.dir = int(user.dir);
			else
				this.dir = 0;
			_info.setWords(_words);//  自言自语
			rpgSkin.mask = this._mask;
			var carelv:int = getCareLevel();
			if(carelv > 0 ){
				_info.setTexts(RPGAnimalInfos.NameTxt,getName(user),true);
			}else
				_info.setTexts(RPGAnimalInfos.NameTxt,getName(user),false);
			
			if(user.ability){
				setHp(user.ability.hp);
			}
			if(carelv == 2){
				this._info.showBlood(true);
			}
			checkBuffers();
			if(this.dead){
				this.die(false);
			}
			this.dir = user.dir;
			updateNameColor();
			if(this.isMe())
				this.rpgSkin.setFocus(1);
			else
				this.focus = _focus;
			this.checkBianShen();
			if(!bianShen)
				this.initModels();
			if(user.type == ActorType.Script){
				this.setAction(ActionType.FLY,-1,true);
				rpgSkin.lockAction = true;
			}else
				this.setAction(defaultAction,-1,true);
			preloadActions();
		}
		
		/**
		 * 检测变身
		 * 如果有变身，修改bianShen属性为true
		 */
		public function checkBianShen():void{
		}
		
		public function initModels():void
		{
			/*
			this.changeModels(null,null);//装备
			this.updateWing(this.gameObj.baseObj.wing);//羽翼*/
		}
		
		
		protected function addSkin():void{
			if(rpgSkin){
				this.addChild(this.rpgSkin);
				setPosition();
				for each (var e:ElementBase in this._elements) 
				{
					if(e is Effect){
						var eff:Effect = e as Effect;
						if(eff.pos == 0)
							this.addChildAt(eff,0);
						else
							this.addChild(eff);
					}
				}
				this.setAction(action,-1,true);
			}
		}
		
		protected function removeSkin():void{
			if(rpgSkin && rpgSkin.parent){
				this.removeChild(rpgSkin);
			}
			for each (var e:ElementBase in this._elements) 
			{
				super.removeChild(e);
			}
		}
		
		/**
		 * 显示玩家身上的特效（升级特效、任务提示特效）
		 * @param id	特效编号
		 * @param name	特效资源名
		 *
		 */
		public function addEffect(body:Effect, index : int = -1) : void
		{
			var eff:Effect = this.getElement(body.id) as Effect;
			//trace("roleeffect +   " + body.eid);
			if(eff != null){
				this.removeEffect(eff.id);
			}
			if(this.inView){
				if (index < 0)
				{
					this.addChild(body);
				}
				else
				{
					this.addChildAt(body, index);
				}
			}
			
			if (this.skinVisible == false)
			{
				body.visible = false;
			}
			_elements[body.id] = body;
		}
		
		/**
		 * 删除玩家身上的特效（升级特效）
		 * @param id	特效编号
		 * @param name	特效资源名
		 *
		 */
		public function removeEffect(id : int) : void
		{
			var eff : Effect = this.getElement(id) as Effect;
			if (eff)
			{
				if(_effects[eff.eid])
					delete _effects[eff.eid];
				super.removeChild(eff);
				delete _elements[id];
				if(!eff.reseted)
					DisposeManager.instance.disposeEffectLater(eff);
			}
		}
		
		override public function removeChild(item:GameSprite):void{
			if(item is Effect){
				this.removeEffect((item as Effect).id);
			}else
				super.removeChild(item);
		}
		
		override public function addChild(item:GameSprite):void{
			if(item is Effect){
				super.addChild(item);
			}else
				super.addChild(item);
		}
		
		protected function getName(user:Object):String{
			return user.name;
		}
		
		public function removeByParent():void{
			this.zone.removeOnNextFrame(this);
		}
		
		/**
		 * 移除显示角色
		 */
		public function removeRole(hideTween:Boolean = false,disposeManager:Boolean = false):void{
			if(hideTween){
				if(rpgSkin){
					if(disposeManager){
						this.noCare();
						this._info.hideAll();
					}
					rpgSkin.tweenHide(disposeManager);
				}else{
					if(disposeManager){
						this.removeSkin();
						if(this.parent)
							this.zone.removeOnNextFrame(this);
							/*this._zone.removeChild(this);
						this.dispose();*/
					}
						
				}
			}else{
				this.removeSkin();
				/*if(rpgSkin && dispose){
					rpgSkin.dispose();
					rpgSkin = null;
				}*/
				if(disposeManager){
					if(this.parent)
						this._zone.removeChild(this);
					this.dispose();
				}
			}
		}
		
		
		/**
		 * 设置当前所在格子位置
		 */
		public function setPositionXY(x:int,y:int):void{
			this.gameObj.baseObj.x = x;
			this.gameObj.baseObj.y = y;
			/*if(this._zone.wenquan && this.gameObj.baseObj.type == ActorType.Actor)
			checkLake(x,y);*/
		}
		
		/**
		 * 关心级别 0:不关心
		 */
		protected function getCareLevel():int{
				return 2;
		}
		
		public var lashMoved:Point = new Point();
		
		protected var _lasttime:Number = 0;
		
		public function clearPath():void{
			if(this._path)
				this._path.length = 0 ;
			if(this._tween)
				_tween.stop();
		}
		
		/**
		 * 停止移动，并清理路线
		 */
		public function stopAllMove():void{
			this.vector = null;
			this.targetXY = null;
			this.moving = false;
			this.clearPath();
		}
		
		/**
		 * 是否可穿透
		 * isinSafe 是否在安全区
		 */
		public function canCross(isinSafe:Boolean):Boolean{
			if(gameObj.baseObj.type == ActorType.NPC)
				return false;
			else if(isinSafe)
				return true;
			else if(this.mine || this._zone.mapData.cancross || (gameObj.baseObj.type != ActorType.Actor && gameObj.baseObj.type != ActorType.Pet))
				return true;
			if(gameObj.baseObj.type == ActorType.Script && (gameObj.baseObj.status == "open" || this.dead ))
				return true;
			return false;
		}
		
		/*public function updateDisplay(display:HitDisplayObject):void{
		if(this.rpgSkin)
		this._zone.updateQuadTreeDisplay(this.rpgSkin);
		}*/
		
		/**
		 * 设置行走路线,并开始走动
		 */
		public function setPath(path:Array,pingyi:Boolean = false):Boolean{
			this.pingyi = pingyi;
			var changed:Boolean = true;
			if(targetXY && path && path.length > 0  ){
				if(path[0].x == targetXY.x && path[0].y == targetXY.y)
					changed = false;
			}
			this._path = path;
			moving = true;
			//trace(path);
			if(this._path.length > 0){
				var tostep:Point = this._path.shift();
				walkTo(tostep.x,tostep.y);
			}else{
				moving = false;
			}
			return changed;
		}
		
		public function getPath():Array{
			return this._path;
		}
		
		public function endMove():void{
			moving = false;
		}
		
		private function nextPath():Boolean{
			var roleXY:Point;
			if(this._path.length == 0){
				/*if(this.isMe()){
					roleXY = this._zone.mapData.getBlockCellXY(this.x,this.y);
					this._zone.stepOn(roleXY.x,roleXY.y);
				}*/
				return false;
			}
			var next:Point = _path.shift();
			walkTo(next.x,next.y);
			/*if(this.isMe()){
				roleXY = this._zone.mapData.getBlockCellXY(this.x,this.y);
				this._zone.stepOn(roleXY.x,roleXY.y);
			}*/
			return true;
		}
		
		public static var WALK_SPEED:Number = 4;//走动速度
		public static var RUN_SPEED:Number = 7.5;//跑步速度
		public static var HORSE_SPEED:Number = 10;//坐骑移动速度
		
		public function get speed():Number{
			if( moveType <= 3 &&  _speed > 0){//怪物速度根据配置计算出的速度
				if(moveType == 2)
					return _speed * 2 ;
				else
					return _speed;
			}
			/*if(this.fly > 0)
			return HORSE_SPEED * (Constant.FRAME_SKIP + 1) * 30 / Config.fps;*/
			if(this.moveType == 1)
				return WALK_SPEED * (Constant.FRAME_SKIP + 1) * 0.5;
			else if(this.moveType == 2)
				return RUN_SPEED * (Constant.FRAME_SKIP + 1) * 0.5;
			else if(this.moveType == 3)
				return HORSE_SPEED * (Constant.FRAME_SKIP + 1) * 0.5;
			else if(this.moveType == 4)
				return 20 * (Constant.FRAME_SKIP + 1) * 0.5;
			else if(this.moveType == 5)
				return 24 * (Constant.FRAME_SKIP + 1) * 0.5;
			return 2 * 0.5;
		}
		
		/**
		 * 移动至
		 */
		public function walkTo(x:Number,y:Number):void{
			this.targetXY = new Point(x,y);
			
			var _speedX:Number = 0;
			var _speedY:Number = 0;
			var speed:Number = this.speed;
			if(this.getBuffer(BufferID.JIAN_SU)){
				speed = speed * 0.5;
			}
			var spy:Number = speed * 2/3;
			var toX:Number = this.targetXY.x - this.x;
			var toY:Number = this.targetXY.y - this.y;
			
			var v:Vector2D = new Vector2D(toX,toY);
			if(Math.abs(toX) < speed){
				toX = 0;
			}
			if(Math.abs(toY) < speed*2/3){
				toY = 0;
			}
			v.normalize();
			if(v.x!=0){
				_speedY = Math.abs(v.y*speed/v.x);
				if(Math.abs(toY) < _speedY){
					_speedY = Math.abs(toY);
				}
				if(_speedY > spy){
					_speedY = spy;
					_speedX = Math.abs(v.x*_speedY/v.y);
				}else
					_speedX = speed;	
			}
			else
			{
				_speedY = speed*2/3;
				_speedX = 0;	
			}
			if(v.x < 0){
				_speedX = -_speedX;
			}
			if(v.y < 0){
				_speedY = -_speedY;
			}
			if(toX == 0 && toY == 0){
				this.moving = false;
				return;
			}
			if(_speedX != 0 || _speedY != 0){
				moving = true;
				if(!pingyi){
					var dir:int = DirectionUtil.getForwardByPoints(this.x,this.y,this.targetXY.x,this.targetXY.y);
					//trace("当前方向",dir);
					if(rpgSkin){
						if(this.gameObj && dir != this.direction){
							gameObj.baseObj.dir = dir;
						}
						this.direction = dir;
						if(this.moveType >= 2){
							if(!this.dead)
								this.setAction(ActionType.RUN,dir);
						}else{
							if(!this.dead)
								this.setAction(ActionType.WALK,dir);
						}
					}else
						this.dir = dir;
				}
				if(this.isMe()){
					//trace("下一步:",x , y);
					//this._zone.delayMove();
				}
				_tween.move([targetXY]);
				_tween.setSpeed(Math.sqrt(_speedY * _speedY + _speedX * _speedX));
				//this.vector = new Point(_speedX,_speedY);
			}
		}
		
		/**
		 * 关注此对象，显示名字，血量
		 */
		public function payAttention():void{
			_info.payAttention();
			if(this.gameObj.baseObj.type != ActorType.NPC && this.gameObj.baseObj.type != ActorType.StaticMonster && !this.dead)
				this._info.showBlood(true);
		}
		
		
		/**
		 * 不关心这个单位
		 */
		public function noCare():void{
			var level:int = getCareLevel();
			if(level == 0 ){
				_info.noCare();
			}else if(level == 1){
				_info.showBlood(false);
			}
			
		}
		
		public function levelUp(level:int):void{
			this.gameObj.baseObj.level = level;
			_info.setTexts(RPGAnimalInfos.NameTxt,getName(gameObj.baseObj));
		}
		
		public function showHurtTips(hp:int):void{
				if(hp < 0){
					_info.hurtTips(hp,0);
					if(this.gameObj.baseObj.beBuffers){
						if(this.gameObj.baseObj.beBuffers[2981]){//触发魔法盾
							this.bufferPlay(2981);
						}else	if(this.gameObj.baseObj.beBuffers[21010]){//触发魔法盾
							this.bufferPlay(21010);
						}
					}
				}else if(hp > 0){
					_info.hurtTips(hp,1);
				}
		}
		
		public function takeCare():void{
			cared = true;
			//this.payAttention();
		}
		
		/**
		 * 受伤
		 */
		public function hurt(hp:int,curhp:int,total:int,showTips:Boolean ,hit:int,hurtTime:int):void{
			if(!_zone)
				return;
			if(showTips && curhp > 0){
				this.takeCare();
			}
			if(this.dead||curhp == 0){
				curhp = 0;
				setHp(curhp);
				_lastUpdateHp = hurtTime;
			}else{
				if(_lastUpdateHp <= hurtTime || hurtTime == 0){
					setHp(curhp);
					_lastUpdateHp = hurtTime;
				}else{
					if(gameObj)
						curhp = this.gameObj.hp;
				}
			}
			
			if(rpgSkin){
				if(hp <= 0){
					var dir:int = 0;
					if(this._zone.myRole && this._zone.myRole != this){
						/*if(this._zone.myRole.cellX < this.cellX){
						dir = 2;
						}else if(this._zone.myRole.cellY > this.cellY){
						dir = 6;
						}*/
						dir = DirectionUtil.getForwardByGridXY(this._zone.myRole.cellX,this._zone.myRole.cellY,this.cellX,this.cellY);
					}
					hurtEffect(hp,curhp,total,showTips,dir,hit);
				}else if(hp > 0&&!this.dead){
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
		
		public function die(play:Boolean = true):void{
			this.dead = true;
			this.cared = false;
			if(rpgSkin){
				if(this.gameObj.baseObj.type != ActorType.Pet){
					if(!play)
						this.rpgSkin.playEnd = true;
					this.setAction(ActionType.DIE,4);
				}
				/*if(this.gameObj.baseObj.type == ActorType.EMS){
				this.rpgSkin.removeEffect("11246",4);
				}*/
			}
			noCare();
			/*if( !this._zone.mapData.isSafe(cellX,cellY)){
				var roleXY:Point = this._zone.mapData.getBlockCellXY(this.x,this.y);
				this._zone.mapData.removeUnwalk(roleXY.x,roleXY.y);
			}*/
			
		}
		
		public function setHp(hp:int):void{
			if(this.gameObj == null){
				return;
			}
			if(_info){
				setBlood(hp,this.gameObj.maxHp);
			}
			this.gameObj.baseObj.ability.hp = hp;
		}
		
		public function setMp(mp:int):void{
			if(this.gameObj){
				this.gameObj.baseObj.ability.mp = mp;
			}
		}
		
		public function setInnerPower(innerPower:int):void{
		
		}
		
		/**
		 * 复活
		 */
		public function relive(hp:int,mp:int,innerPower:int):void{
			if(this.rpgSkin)
				rpgSkin.playEnd = false;
			this.dead = false;
			setHp(hp);
			setMp(mp);
			setInnerPower(innerPower);
			if(this.isMe()){
				payAttention();
				//showBlood = true;
			}
			this.setAction(ActionType.STAND);
			this.gameObj.baseObj.ability.hp = hp;
			if( !canCross(this._zone.mapData.isSafe(this.cellX,this.cellY))){
				this._zone.mapData.addUnwalk(this.cellX,this.cellY);
			}
		}
		
		/**
		 * 移动停止，播放站立动作
		 */
		public function stopMoveAction():void{
			if(this == this._zone.myRole)
				//trace("完全停止移动");
				_lasttime = 0;
			if(this.dead)
				return;
			if(this.mine){
				if(rpgSkin && (this.action == ActionType.WALK || this.action == ActionType.RUN || this.action == ActionType.SIT_STAND || this.action == ActionType.SIT_RUN || this.action == ActionType.SIT_WALK ||  this.action  == -1)){
					//if(this.state == 0){
					this.setAction(ActionType.STAND,dir);
					/*}else
					rpgSkin.setAction(ActionType.BATTLE_STAND,dir);*/
				}
			}else{
				if(rpgSkin && (this.action == ActionType.WALK || this.action == ActionType.RUN || this.action == ActionType.SIT_STAND || this.action == ActionType.SIT_RUN || this.action == ActionType.SIT_WALK ||  this.action  == -1)){
					this.setAction(ActionType.STAND,dir);
				}
			}
			pingyi = false;
			this.moveType = 0;
		}
		
		override public function update(gameTime:GameTime):void{
			this._info.sortTxt();
			super.update(gameTime);
			this.updateHuanying();
		}
		
		override public function set x(value:Number):void{
			var roundvalue:int = Math.round(value);
			super.x =roundvalue;
			this.gameObj.x = value;
			this._info.setPositionX(roundvalue);
			moved = true;
		}
		
		override public function set y(value:Number):void{
			var roundvalue:int = Math.round(value);
			super.y = roundvalue;
			this.gameObj.y = value;
			this._info.setPositionY(roundvalue);
			moved = true;
		}
		
		override public function get x():Number{
			if(gameObj)
				return gameObj.x;
			else
				return super.x;
		}
		
		override public function get y():Number{
			if(gameObj)
				return gameObj.y;
			else
				return super.y;
		}
		
		public function get cellX():Number{
			return this.gameObj.baseObj.x;
		}
		
		public function get cellY():Number{
			return this.gameObj.baseObj.y;
		}
		
		override public function dispose():void{
			playerModel = false;
			_nameLayer = null;
			_mcLayer = null;
			offsetY = 0;
			roleOffsetY = 0;
			_model = null;
			_slowDown = 0;
			pingyi = false;
			this._gameObj = null;
			if(this._isDisposed)
				return;
			_lastUpdateHp = 0;
			moving = false;
			if(_heartId > 0){
				clearInterval(_heartId);
				_heartId = 0;
			}
			if(_elements){
				for each (var e:ElementBase in _elements) 
				{
					if(e is Effect){
						if(e.parent)
							removeEffect(e.id);
						//DisposeManager.instance.disposeEffectLater(e as Effect);
						//ObjectPoolManager.getInstance().returnItem(Constant.EffectClass,e as Effect);
					}else
						e.dispose();
				}
				_elements = null;
			}
			super.dispose();
			_nameY = 0;
			_wing = null;
			_arms = null;
			if(huanying){
				for each (var bmp:Bitmap in huanying) 
				{
					bmp.bitmapData = null;
					if(bmp.parent)
						bmp.parent.removeChild(bmp);
				}
				huanying = null;
			}
			_inited = false;
			_effects = null;
			if(_tween)
				ObjectPoolManager.getInstance().returnItem(Constant.TweenClass,this._tween);
			if(_info)
				this._info.dispose();
			_info = null;
			_tween = null;
			if(this.rpgSkin){
				rpgSkin = null;
			}
			actionList = null;
			_busy = 0;
			_moveInterval = 0;
			this.gameObj = null;
			this.targetXY = null;
			_fashionsShow = null;
			this._path = null;
			this._zone = null;
			this.vector = null;
			this.cared = false;
			this._fashions = null;
			moved = false;
			moveType = 0;
			cuttitle = 0;
			_anonymity = false;
			mine = false;
			_curPoint = null;
			this._mask = false;
			_hide = false;
			this._cfg = null;
			this._words = null;
			horseEffect = null;
			fashionEff = null;
			this._speed = 0;
			this.bianShen = false;
			gongsha = false;
			_isMe = false;
			_focus = false;
		}
		
		
		
		/**
		 * 隐身
		 */
		public function setYinShen(arg:Boolean):void
		{
			if(this.id == this._zone._myRid)
				return;
			if(this.gameObj.baseObj.type != ActorType.Pet){
				for each(var rmgr:RPGAnimal in this._zone.elements){
					if(rmgr.gameObj.baseObj.type == ActorType.Pet){
						if(rmgr.gameObj.baseObj.owner == this.id){
							rmgr.setYinShen(arg);
						}
					}
				}
			}
			
			this.gameObj.baseObj.yinsh = arg;
			if(rpgSkin){
				this.rpgSkin.alpha = 0.6;
			}
		}
		
		
		
		protected var _visible:Boolean = true;
		
		/*public function set visible(value:Boolean):void{
			_visible = value;
			if(!this.gameObj.baseObj.yinsh && rpgSkin){
				rpgSkin.show(value);
			}
			
		}*/
		
		/**
		 * 更换翅膀
		 */
		public function setWing(arg:Object):void
		{
			if(this.gameObj == null || this.gameObj.baseObj == null){
				return;
			}
			this.gameObj.baseObj.wing = arg;
			if(rpgSkin){
				var user:Object = this.gameObj.baseObj;
				var arms:Object = user.arms;
				var wing:Object = arg;
				if(updateWing(wing)){
					this.setAction(this.action,-1,true);
				}
			}
		}
		
		public function hideComponent(scaleed:Boolean):void
		{
			this.hideComponent(scaleed);
		}
		
		public function play():void
		{
			if(this.rpgSkin){
			}
		}
		
		/**
		 * 沙巴克攻城结束
		 */
		public function endSBK():void{
			_sbkOpp = false;
			_sbkFri = false;
			updateNameColor();
		}
		
		/**
		 * 设置为沙巴克敌对势力
		 */
		public function setSBKOpp():void
		{
			_sbkFri = false;
			_sbkOpp = true;
			updateNameColor();
		}
		
		/**
		 * 设置为沙巴克友军势力
		 */
		public function setSBKFri():void
		{
			_sbkFri = true;
			_sbkOpp = false;
			updateNameColor();
		}
		
		/**
		 * 设置为公会盟友势力
		 */
		public function setFriUnion():void
		{
			_unionFri = true;
			_unionOpp = false;
			updateNameColor();
		}
		
		/**
		 * 设置为公会敌对势力
		 */
		public function setOppUnion():void
		{
			_unionOpp = true;
			_unionFri = false;
			updateNameColor();
		}
		
		protected var _sbkOpp:Boolean = false;
		protected var _sbkFri:Boolean = false;
		protected var _unionOpp:Boolean = false;
		protected var _unionFri:Boolean = false;
		public var onHorseEff:Boolean = false;
		
		public function get isFriUnion():Boolean{
			return _sbkFri || _unionFri;
		}
		
		/**
		 * 更新名字颜色
		 */
		public function updateNameColor():void
		{
			if(!rpgSkin)
				return;
			if(this.gameObj.baseObj.type == ActorType.Actor && this._zone.myRole.gameObj.baseObj.league > 0){
				if( this.gameObj.baseObj.league != this._zone.myRole.gameObj.baseObj.league)
					this.setNameColor(MColor.UnionOpp);
				else
					this.setNameColor(MColor.UnionFriend);
				return;
			}
		/*	if(this.gameObj.baseObj.type == ActorType.Actor&&UserData.getUserData("pkstate") == 4)
			{
				if(!this.isMe()&&!mine&&( this.gameObj.baseObj.unionid != this._zone.myRole.gameObj.baseObj.unionid||this._zone.myRole.gameObj.baseObj.unionid ==0))
					this.setNameColor(MColor.UnionOpp);
				else
					this.setNameColor(MColor.UnionFriend);
				
				return;
			}*/
			if(!_sbkOpp  && !_sbkFri && !_unionOpp && !_unionFri){
				if(this.gameObj.baseObj.type == ActorType.Pet){
					if(this.rpgSkin){
						var color:uint = MColor.New3;
						switch(int(this.gameObj.baseObj.level)){
							case 1:	color = MColor.PetLv1;break;
							case 2:color = MColor.PetLv2;break;
							case 3:color = MColor.PetLv3;break;
							case 4:color = MColor.PetLv4;break;
							case 5:color = MColor.PetLv5;break;
							case 6:color = MColor.PetLv6;break;
							case 7:color = MColor.PetLv7;break;
						}
						this.setNameColor(color);
					}
				}else{
					setPkValue(this.gameObj.baseObj.pkValue);
					this.setUnionColor(MColor.New4);
				}
				return;
			}
			if(_sbkOpp || _unionOpp){
				if(this.rpgSkin){
					this.setNameColor(MColor.UnionOpp);
					this.setUnionColor(MColor.UnionOpp);
				}
			}else if(_sbkFri || _unionFri){
				if(this.rpgSkin){
					this.setNameColor(MColor.UnionFriend);
					this.setUnionColor(MColor.UnionFriend);
				}
			}
		}
		
		/**
		 * 设置善恶值
		 */
		public function setPkValue(param:int):void
		{
			this.gameObj.baseObj.pkValue = param;
			if(!_sbkOpp  && !_sbkFri && !_unionOpp && !_unionFri){
				if(this.gameObj.baseObj.type == ActorType.Actor && rpgSkin){
					if(param >= 100){
						setNameColor(MColor.New9);
					}else if(param > 0 && param < 100){
						setNameColor(MColor.New5);
					}else if(param == 0){
						setNameColor(MColor.New29);
					}else{
						setNameColor(MColor.New1);
					}
				}
			}
		}
		
		/** 元件深度 */
		override public function get depth() : Number
		{
			if(this.dead)
				return 0;
			return this.display.y;
		}
		
		protected var _isSbk:Boolean = false;
		protected var _hidefilter:Boolean = false;
		public function checkSBK(unionid:int):void{
			if(this.gameObj && this.gameObj.baseObj.unionid == unionid){
				_isSbk = true;
				if(rpgSkin){
					_info.setTexts(RPGAnimalInfos.NameTxt,getName(gameObj.baseObj));
				}
			}else{
				if(_isSbk)
				{
					_info.setTexts(RPGAnimalInfos.NameTxt,getName(gameObj.baseObj));
				}
			}
		}
		
		/**
		 * 清理沙巴克
		 */
		public function clearSBK():void
		{
			this._sbkFri = false;
			this._sbkOpp = false;
			this.updateNameColor();
		}
		
		public function setName(param0:String):void
		{
			this.gameObj.baseObj.name = param0;
			_info.setTexts(RPGAnimalInfos.NameTxt,param0);
		}
		
		
		protected var fpet:int = 0;
		protected var rpgSkin:RPGAnimalSkin;
		
		public function changeModel(model:String):void{
			if(model ==null){
				bianShen = false;
			}else
				bianShen = true;
			if(rpgSkin)
			{
				rpgSkin.changeModel(model);
			}
				
		}
		public function showUnion(bool:Boolean):void
		{
			if(bool)
				this._info.showText(RPGAnimalInfos.UnionTxt);
			else
				this._info.hideText(RPGAnimalInfos.UnionTxt);
		}
		
		public function showName(bool:Boolean):void
		{
			if(bool)
				this._info.showText(RPGAnimalInfos.NameTxt);
			else
				this._info.hideText(RPGAnimalInfos.NameTxt);
		}
		
		public function showBloodText(bool:Boolean):void
		{
			if(bool)
				this._info.showText(RPGAnimalInfos.BloodTxt);
			else
				this._info.hideText(RPGAnimalInfos.BloodTxt);
		}
		
		
		public function setOtherTxt(funcName:String, color:uint, param2:int = 0,guanzhi:Boolean = false):void
		{
			if(funcName){
				this._info.setTexts(RPGAnimalInfos.OtherTxt,funcName,true);
				this._info.setTxtColor(RPGAnimalInfos.OtherTxt,color);
			}else
				this._info.hideText(RPGAnimalInfos.OtherTxt);
		}
		
		
		public function setNameColor(color:uint):void
		{
			_info.setTxtColor(RPGAnimalInfos.NameTxt,color);
		}
		
		public function setUnionColor(color:uint):void
		{
			_info.setTxtColor(RPGAnimalInfos.UnionTxt,color);
		}
		
		public function setEms(id:int):void
		{
			
		}
		
		public function addTag(param0:int):void
		{
			
		}
		
		public function setBlood(hp:int, maxHp:int, show:Boolean = false):void
		{
			_info.setBlood(hp,maxHp,show);
		}
		
		
		public function hurtEffect(hp:int, curhp:int, total:int, showTips:Boolean, dir:int, hit:int):void
		{
			if(showTips){
				this.setBlood(curhp,total);
				if(curhp > 0)
					this._info.showBlood(true);
			}
			if( hit != 0  && hp < 0)
				playHurt();
			if(showTips){
				_info.hurtTips(hp,0,dir,hit);
				if(hp < 0){
					/*if(! _effMovies["10143_4"])
						this.addEffect(10143 + "",false,1,4);*/
				}
			}
		}
		
		protected function playHurt():void{
		}
		
		public function cure(hp:int, curhp:int, total:int, showTips:Boolean):void
		{
			this.setBlood(curhp,total);
			this._info.showBlood(true);
			if(showTips){
				_info.hurtTips(hp,1);
			}
		}
		
		public function get hiding():Boolean{
			if(this.rpgSkin && this.rpgSkin.hiding){
				return true;
			}
			return false;
		}
		
		/**
		 * 行会名字
		 */
		public function setSociaty(param0:String):void
		{
			if(param0 == null)
				_info.removeText(RPGAnimalInfos.UnionTxt);
			else
				_info.setTexts(RPGAnimalInfos.UnionTxt,param0,true);
		}
		
		public function clearFilter(type:int):void
		{
			if(rpgSkin)
				this.rpgSkin.clearFilter(type);
		}
		
		public function hitTestBmp(x:int, y:int):Boolean
		{
			if(this.visible){
				if(rpgSkin && _rect.contains(x,y)){
					return true;
				}
				if(rpgSkin && this.rpgSkin.skinVisible){
					return this.rpgSkin.selectVerify(x,y);
				}else
					return false;
			}
			return false;
		}
		
		public function addFilter(type:int):void
		{
			if(rpgSkin)
				this.rpgSkin.addFilter(type);
		}
		
		public function set mouseFilter(type:int):void{
			if(type == 0){
				this.rpgSkin.mouseFilter = FilterSet.mouseGlowFilter3;
			}else{
				this.rpgSkin.mouseFilter = FilterSet.mouseGlowFilter;
			}
		}
		
		public function get moveNext():Boolean
		{
			if(this.isMe()){
				if((this._path && this._path.length > 0) ){//|| this._zone.process.leftDown || this._zone.process.rightDown){
					return true;
				}
			}
			return false;
		}
		
		public function get uniform():Boolean
		{
			return !this.isMe();
		}
		
		public function get curPoint():Point{
			if(!this._curPoint){
				this._curPoint = new Point();
			}
			_curPoint.x = int(this.x / Constant.CELL_WIDTH);
			_curPoint.y = int(this.y / Constant.CELL_HEIGHT);
			return _curPoint;
		}
		
		public function speak(param0:String):void
		{
			//_info.speak(param0);
		}
		
		public function get endNow():Boolean{
			return this.dead;
		}
		
		/**
		 * 预加载动作 
		 */
		protected function preloadActions():void
		{
			
		}
		
		/**
		 * 检测是否群攻的对象
		 * @return 
		 */
		public function get inGroup():Boolean{
			return false;
		}
	}
}