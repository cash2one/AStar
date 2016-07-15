package com.rpg.scene.actor
{
	import com.mgame.battle.Zone;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.ArmPosType;
	import com.rpg.enum.Constant;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.scene.actor.skin.role.RoleSkin;
	import com.sh.game.global.Config;
	import com.sh.game.util.MColor;
	import com.sh.game.util.TimeDataFormatUtil;
	
	import consts.BufferID;
	
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	public class Role extends RPGAnimal
	{
		private var roleSkin:RoleSkin;
		public var locked:Boolean = false;
		private var _preloadTimeoutId:int;
		
		/**
		 * 野蛮冲撞，客户端僵直 
		 */
		public var ymJiangZhi:Boolean = false;
		
		public function Role(baseObj:Object,zone:Zone,initView:Boolean = false)
		{
			super(baseObj,zone,initView);
			this._skin = this._animalSkin = this.rpgSkin = roleSkin =  new RoleSkin(this);
			if(baseObj.title){
				this.cuttitle = baseObj.title;
			}
			this.enabled = true;
		}
		
		/**
		 * 这是玩家自己
		 */
		public function itsMe():void{
			this._isMe = true;
		}
		

		/**
		 * 攻击后摇到期时间
		 */
		override public function get busy():Boolean
		{
			if(this.locked)
				return true;
			return super.busy;
		}
		
		override public function set dir(value:int):void
		{
			super.dir = value;
		}
		
		protected override function createComponent() : void
		{
			this.enabled = true;
		}
		
		override protected function initView():void{
			var user:Object = this.gameObj.baseObj;
				this._sit = false;
			this.focus = _focus;
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
			if(_myRid == user.id)
				mine = true;
			var hid:int ;
			if(this.dead)
				defaultAction = ActionType.DIE;
			setPkValue(user.pkValue);
			if(user.dir != -1)
				this.dir = int(user.dir);
			else
				this.dir = 0;
			this.mask = this._mask;
			var carelv:int = getCareLevel();
			if(carelv > 0 ){
				this._info.setTexts(RPGAnimalInfos.NameTxt,getName(user),true);
				showName(true);
				showBloodText(true);
			}
			if(user.ability){
				setHp(user.ability.hp);
			}
			if(carelv == 2 || this.mine){
				this._info.showBlood(true);
			}
			checkBuffers();
			if(this.dead){
				this.die(false);
			}
			updateNameColor();
			addTitles();
			
			this.initModels();
			this.setAction(defaultAction,-1,true);
		}
		
		/**
		 * 是否可操作
		 * 40312 麻痹   40240 晕眩 
		 */
		public function get canProcess():Boolean{
			if(this.dead || this.getBuffer(BufferID.DING_SHEN) || this.getBuffer(40240) || this.moveType == 5 || ymJiangZhi){
				return false;
			}
			return true;
		}
		
		private function changeArms():void
		{
			this.updateArms({5:{model:10000},1:{model:20001}},null);
		}
		
		
		/**
		 * 加入称号icons
		 */
		private function addTitles():void{
			if(!this.isMe() ){
				return;
			}
			this._info.setTitle(cuttitle);
		}
		
		/**
		 * 移除称号icons
		 */
		public function removeTitle(id:int):void{
				if(_info){
					_info.removeTitle(id);
				}
		}
		
		override protected function getName(user:Object):String{
			var str:String = user.name;
			return str;
		}
		
		public function hideTitle(hide:int):void
		{
			this.gameObj.baseObj.hidetitle = hide;
			this.updateTitle(this.gameObj.baseObj.title);
		}
		
		/**
		 * 更新称号
		 */
		public function updateTitle(tid:int):void{
			if(this.cuttitle > 0){
				this.removeTitle(this.cuttitle);
			}
			this.gameObj.baseObj.title = tid;
			this.cuttitle = tid;
			if(tid > 0){
				this.addTitle(tid);
			}
		}
		
		public function showTitle(b:Boolean):void{
			if(b){
				this.addTitles();
			}else{
					if(gameObj.baseObj.title > 0){
						this.removeTitle(gameObj.baseObj.title);
					}
			}
		}
		
		/**
		 * 关注此对象，显示名字，血量
		 */
		override public function payAttention():void{
			super.payAttention();
		}
		
		override public function setAction(action:int, dir:int=-1, compulsory:Boolean=false):void{
			super.setAction(action,dir,compulsory);
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
					this.initModels();
					this.setAction(action,-1,true);
					preloadActions();
				}
			}
		}
		
		/**
		 * 增加称号(顶头上)
		 */
		public function addTitle(id:int):void{
			this._info.setTitle(id);
		}
		
		/**
		 * 加个icon
		 * @param icon
		 * @param type
		 */
		public function addIcon(icon:String,type:int):void{
			this._info.setIcon(icon,null,type);
		}
		
		public function removeIcon(icon:String):void{
			this._info.removeIcon(icon);
		}
		
		
		public function bianShenBuff(model:String):void{
			this.gameObj.baseObj.yitian = model;
			this.initModels();
			this.setAction(action,-1,true);
		}
		
		/**
		 * 变身 
		 * @param model
		 * @param daction
		 */
		private function bianshen(model:String):void
		{
			if(model == null)
				bianShen = false;
			else
				bianShen = true;
			if(roleSkin){
				roleSkin.bianShen(model);
			}
			if(model == null){
				initModels();
			}
			this.roleSkin.addCommonShadow();
		}
		
		/**
		 * 更换翅膀
		 */
		override public function setWing(arg:Object):void
		{
			if(this.gameObj == null || this.gameObj.baseObj == null){
				return;
			}
			this.gameObj.baseObj.wing = arg;
			var user:Object = this.gameObj.baseObj;
			var arms:Object = user.arms;
			if(this.updateWing(arg)){
				this.setAction(this.action,-1,true);
			}
		}
		
		
		override public function setHp(hp:int):void{
			if(this.gameObj == null){
				return;
			}
			if(_info){
				setBlood(hp,this.gameObj.maxHp);
			}
			this.gameObj.baseObj.ability.hp = hp;
		}
		
		override public function setMp(mp:int):void{
			if(this.gameObj){
				this.gameObj.baseObj.ability.mp = mp;
			}
		}
		
		override public function initModels():void
		{
			var roleModel:String;
			var user:Object = this.gameObj.baseObj;
			
			if(roleModel != null){
				this.bianshen(roleModel);
			}else{
				this.initNormalModels();
			}
			this.roleSkin.addCommonShadow();
		}
		
		public function addTDEff(gird:int=17, color:uint=0x00ff00):void
		{
			_info.addEclipse(gird,color);
		}
		public function removeTDEff():void
		{
			_info.removeEclipse();
		}
		
		public function initNormalModels():void
		{
			var arms:Object = this.gameObj.baseObj.arms;
			var hand:String;
			var body:String;
			var shadow:String;
			var wing:String;
			var horse:String;
			for each(var pos:int in ArmPosType.roleArms){
				var fpos:int = ArmPosType.armToFashionPos(pos);
				var arm:Object = null;
				if(arms && arms[pos] != null)
					arm = arms[pos];
				if(arm == null )
					continue;
				switch(pos){
					case ArmPosType.PosWeapon:
						hand = getArmModel(arm);
						break;
					case ArmPosType.PosClothes:
						body = getArmModel(arm);
						break;
				}
			}
			var cfg:Object = cfgHorse;
			if(body == null){
				body = this.gameObj.baseObj.model;
			}
			if(hand == null){
				hand = (int(this.gameObj.baseObj.model) + 100 )+ "";
			}
			this.roleOffsetY = 0;
			this.offsetY = 0;
			this._info.setPosition();
			this.changeModels(body,hand,shadow);//装备
			this.updateWing(this.gameObj.baseObj.wing);//羽翼
			//this.onHorse = this.gameObj.baseObj.onhorse;//坐骑
		}
		
		override protected function changeModels(body:String,hand:String,shadow:String):Boolean{
			var hasChange:Boolean = false;
			if(this.rpgSkin.getDataSets(ElementSkinType.CLOTHING_FOOT) == null){
				this.rpgSkin.setSkin(ElementSkinType.CLOTHING_FOOT,body,Config.clothSkinPath);
				hasChange = true;
			}else if(body != this.rpgSkin.getDataSets(ElementSkinType.CLOTHING_FOOT).model){
				this.rpgSkin.removeType(ElementSkinType.CLOTHING_FOOT);
				this.rpgSkin.setSkin(ElementSkinType.CLOTHING_FOOT,body,Config.clothSkinPath);
				hasChange = true;
			}
			if(this.rpgSkin.getDataSets(ElementSkinType.WEAPON_FOOT) == null){
				this.rpgSkin.setSkin(ElementSkinType.WEAPON_FOOT,hand,Config.weaponSkinPath);
				hasChange = true;
			}else	if(hand != this.rpgSkin.getDataSets(ElementSkinType.WEAPON_FOOT).model){
				this.rpgSkin.removeType(ElementSkinType.WEAPON_FOOT);
				if(hand != null)
					this.rpgSkin.setSkin(ElementSkinType.WEAPON_FOOT,hand,Config.weaponSkinPath);
				hasChange = true;
			}
			return hasChange;
		}
		
		override public function onMoveComplete(time:int):void{
			super.onMoveComplete(time);
		}
		
		
		override public function  dispose():void{
			locked = false;
			if(_preloadTimeoutId > 0)
				clearTimeout(_preloadTimeoutId);
			_preloadTimeoutId = 0;
			ymJiangZhi = false;
			this.roleSkin = null;
			super.dispose();
		}
	}
}