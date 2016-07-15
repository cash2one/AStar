package com.rpg.scene.actor.skin.role
{
	
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationEventArgs;
	import com.rpg.entity.animation.AnimationMovieClip;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.entity.animation.AnimationPlayerDataSet;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ElementSkinSort;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.framework.utils.TimeOutManager;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.actor.Role;
	import com.rpg.scene.actor.skin.RPGAnimalSkin;
	import com.sh.game.global.Config;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import util.FilterSet;
	
	
	public class RoleSkin extends RPGAnimalSkin
	{
		private var _role:Role;
		private var _delayStand:uint = 0;
		private var _bianShen:String;
		private var _sex:int;
		
		public function RoleSkin(element:ElementBase)
		{
			super(element);
			this._role = Role(element);
			this._defaultModel = this._role.gameObj.baseObj.sex;
			this._sex = this._role.gameObj.baseObj.sex;
			_mouseFilter = FilterSet.mouseGlowFilter2;
			if(_role.isMe()){
				this._prority = 0;
			}
		}
		
		override public function setSkin(skinType : String,model:String,path:String):void{
			switch(skinType){
				case ElementSkinType.CLOTHING_FOOT:
					addType(skinType, showCloth, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.SHADOW:
					addType(skinType, addShadow, path,model);
					break;
				case ElementSkinType.SHADOW_OUT:
					addType(skinType, addShadow2, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.WING:
					addType(skinType, showWing, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.MOUNT_PLUS:
					addType(skinType, showHorsePlus, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.WEAPON_FOOT:
					addType(skinType, showWeapon, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.MONSTER:
					addType(skinType, showBianshen, path,model,SkinConfig.getMonster());
					break;
			}
		}
		
		/**
		 * 添加一个皮肤类型
		 * @param skinType	皮肤类型
		 * @param callback  皮肤显示回调函数
		 *
		 */
		override public function addType(skinType : String, callback : Function, skinPath : String, model:String = null,defaultCfg:Object = null) : void
		{
			this._dataList[skinType] = new AnimationPlayerDataSet(skinType,callback,model,defaultCfg,skinPath,ElementSkinType.CLOTHING_FOOT);
		}
		
		/**
		 * 修改动做
		 * @param actionType  动做类型
		 * @param isForce  	     是否强制改变动做
		 */
		override public function setAction(compulsory : Boolean = false) : void
		{
			// 此处定义人物方向和美术图布局有关
			if (_currentActionType != _animal.action || _currentDirection != _animal.direction || compulsory)
			{
				_currentActionType = _animal.action;
				_currentDirection  = _animal.direction;
				this.clearDelayStand();
				this.setSkinIndex();
				showAction();
			}
		}
		
		private function addShadow(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.SHADOW, data);
		}
		
		private function addShadow2(data :AnimationPlayerData):void{
			this.processComplete(ElementSkinType.SHADOW_OUT, data);
		}
		
		override protected function getShadowCache():CacheCollection{
			return SceneCacheManager.instance.playerShadowSkin;
		}
		
		private function showWing(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.WING, data);
		}
		
		private function showHorsePlus(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.MOUNT_PLUS, data);
		}
		
		private function showWeapon(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.WEAPON_FOOT, data);
		}
		
		private function showCloth(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.CLOTHING_FOOT, data);
		}
		
		private function showBianshen(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.MONSTER, data);
		}
		
		override protected function setAnimalSkinY(clipType : String,bitmap:Bitmap,y:int):void{
			if(clipType == ElementSkinType.WING && _sex == 0){
				bitmap.y 		    = y + 5;
			}else
				bitmap.y 		    = y;
		}
		
		override protected function getCacheData(skinType : String = null) : CacheCollection
		{
			if(_bianShen != null)
				return SceneCacheManager.instance.monsterSkin;
			return SceneCacheManager.instance.playerSkin[skinType];
		}
		
		override protected function getDefaultData() : CacheCollection
		{
			return SceneCacheManager.instance.defaultSkin;
		}
		
		/*override public function  update(gameTime:GameTime):void{
			super.update(gameTime);
		}*/
		
		override protected function showAction():void{
			this.pause = false;
			super.showAction();
			this._needSort = true;
		}
		
		/** 设置皮肤的层次**/
		override protected function setSkinIndex() : void 
		{
			//super.setSkinIndex();
			
			var sorts:Array;
			if(this._bianShen == null){
				/*if(this._currentActionType == ActionType.STAND || this._currentActionType == ActionType.WALK)
					sorts = ElementSkinSort.stand_type_sort;
				else*/
				if(this._role.action == ActionType.ATTACK || this._role.action == ActionType.ATTACK_SPECIAL){
					sorts = ElementSkinSort.attack_dir_type_sort;
				}else
					sorts = ElementSkinSort.dir_type_sort;
			}else
				sorts = ElementSkinSort.Monster_sort;
			var index:int = 0;
			if(_shadow){
				index++;
			}
			if ((_focus_2 && this.contains(_focus_2)) || (_focus_1 && this.contains(_focus_1)))
			{
				index++;
			}
			for each (var type:String in sorts[this._currentDirection]) 
			{
				if(this._animation.hasOwnProperty(type)){
					this.setChildByIndex(type,index);
					index++;
				}
			}
			/*if (this.enabled)
				this.play(_currentActionType,_currentDirection,false);*/ // 经验：考虑是否每次调用些方些要运行play方法
		}
		
		
		override protected function playComplete(e:AnimationEventArgs):void{
			if (_actionQueue && _actionQueue.length > 0)
			{
				_animal.setAction(_actionQueue.shift(), -1, true);
			}
			else
			{
				// 攻击动做完成时，切换人物行为为休闲状态
				if (_animal.action == ActionType.ATTACK ||
					_animal.action == ActionType.ATTACK_SPECIAL )
				{
					this.setMultipleFrame(0);
					this.pause = true;
					clearDelayStand();
					_delayStand = TimeOutManager.getInstance().setTimer(delayStandHandler,1000);
					/*_delayStand = setTimeout(function():void{
						_animal.setAction(ActionType.STAND);
						if(_role.gameObj.baseObj.digging == -1){
							_role.setAction(ActionType.ATTACK);
							
						}
					},1000);*/
				}else if(_animal.action == ActionType.DIE){
					
				}
			}
		}
		
		private function delayStandHandler():void{
			_animal.setAction(ActionType.STAND);
			if(_role.gameObj.baseObj.digging == -1){
				_role.setAction(ActionType.ATTACK);
			}
			_delayStand = 0;
		}
		
		private function clearDelayStand():void{
			if(_delayStand>0){
				//clearTimeout(_delayStand);
				TimeOutManager.getInstance().clearTimer(_delayStand);
				_delayStand = 0;
			}
		}
		
		override public function dispose():void{
			clearDelayStand();
			this._sex = 0;
			this._needSort = false;
			this._role = null;
			this._bianShen = null;
			super.dispose();
		}
		
		/**
		 *变身 
		 * @param model
		 */
		public function bianShen(model:String):void
		{
			if(_bianShen == model)
				return;
			_bianShen = model;
			if(model != null){
				for (var key:String in this._dataList) 
				{
					this.removeType(key);
				}
				this.setSkin(ElementSkinType.MONSTER,model,Config.monsterPath);
				//this.setSkin(ElementSkinType.SHADOW,model,Config.monsterPath);
			}else{
				this.removeType(ElementSkinType.MONSTER);
			}
		}
		
	}
}