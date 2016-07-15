package com.rpg.scene.actor.skin.monster
{
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.entity.animation.AnimationPlayerDataSet;
	import com.rpg.enum.ElementSkinSort;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.skin.RPGAnimalSkin;
	import com.sh.game.global.Config;
	
	import flash.display.Bitmap;
	
	import util.FilterSet;
	
	
	public class MonsterSkin extends RPGAnimalSkin
	{
		private var _monster:Monster;
		
		private var _bianShen:String;
		private var _sex:int;
		/**默认的model*/		
		private var _model:String;
		public function MonsterSkin(element:ElementBase,model:String)
		{
			super(element);
			this._monster = Monster(element);
			this._sex = this._monster.gameObj.baseObj.sex;
			_model = model;
			if(this._monster.mine)
				_mouseFilter = FilterSet.mouseGlowFilter3;
			else
				_mouseFilter = FilterSet.mouseGlowFilter;
		}
		
		override public function setSkin(skinType : String,model:String,path:String):void{
			switch(skinType){
				case ElementSkinType.MONSTER:
					addType(skinType, showMonster, path,model,SkinConfig.getMonster());
					break;
				case ElementSkinType.SHADOW:
					addType(skinType, addShadow, path,model);
					break;
				case ElementSkinType.SHADOW_OUT:
					addType(skinType, addShadow2, path,model,SkinConfig.getPlayer());
					break;
				case ElementSkinType.WEAPON_FOOT:
					addType(skinType, addWeapon, path,model);
					break;
				case  ElementSkinType.CLOTHING_FOOT:
					addType(skinType, showCloth, path,model,SkinConfig.getPlayer());
					break;
				case  ElementSkinType.WING:
					addType(skinType, showWing, path,model,SkinConfig.getPlayer());
					break;
			}
		}
		
		/**
		 * 添加一个皮肤类型
		 * @param skinType	皮肤类型
		 * @param callback  皮肤显示回调函数
		 */
		override public function addType(skinType : String, callback : Function, skinPath : String, model:String = null,defaultCfg:Object = null) : void
		{
			if(skinType == ElementSkinType.SHADOW && this._monster.playerModel)
				this._dataList[skinType] = new AnimationPlayerDataSet(skinType,callback,model,defaultCfg,skinPath,ElementSkinType.CLOTHING_FOOT);
			else
				this._dataList[skinType] = new AnimationPlayerDataSet(skinType,callback,model,defaultCfg,skinPath);
		}
		
		override protected function getShadowCache():CacheCollection{
			if(this._monster.playerModel){
				return SceneCacheManager.instance.playerShadowSkin;
			}else{
				return SceneCacheManager.instance.shadowSkin;
			}
		}
		
		private function showWing(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.WING, data);
		}
		private function addWeapon(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.WEAPON_FOOT, data);
		}
		private function addShadow(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.SHADOW, data);
		}
		private function addShadow2(data :AnimationPlayerData):void{
			this.processComplete(ElementSkinType.SHADOW_OUT, data);
		}
		private function showMonster(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.MONSTER, data);
		}
		
		private function showCloth(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.CLOTHING_FOOT, data);
		}
		
		override protected function getDefaultData() : CacheCollection
		{
			return SceneCacheManager.instance.defaultSkin;
		}
		
		override protected function getCacheData(skinType : String = null) : CacheCollection
		{
			//带武器的怪物
			if(skinType == ElementSkinType.CLOTHING_FOOT || skinType == ElementSkinType.WING || skinType == ElementSkinType.WEAPON_FOOT)
				return SceneCacheManager.instance.playerSkin[skinType];
			return SceneCacheManager.instance.monsterSkin;
		}
		
		
		override public function dispose():void{
			this._monster = null;
			_bianShen = null;
			_model = null;
			this._sex = 0;
			super.dispose();
		}
		
		override protected function setAnimalSkinY(clipType : String,bitmap:Bitmap,y:int):void{
			y = y - this._monster.roleOffsetY;
			if(clipType == ElementSkinType.WING && _sex == 0){
				bitmap.y 		    = y + 5;
			}else
				bitmap.y 		    = y;
		}
		
		/** 设置皮肤的层次**/
		override protected function setSkinIndex() : void 
		{
			//super.setSkinIndex();
			var index:int = 0;
			if(_shadow){
				index++;
			}
			var sorts:Array;
			if(this._monster.playerModel){
				sorts = ElementSkinSort.Monster_sort2;
			}else{
				sorts = ElementSkinSort.Monster_sort;
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
		}
		
		
		/**
		 *变身 
		 * @param model
		 */
		public override function changeModel(model:String):void
		{
			if(_bianShen == model)
				return;
			_bianShen = model;
			for (var key:String in this._dataList) 
			{
				this.removeType(key);
			}
			if(model != null){
				this.setSkin(ElementSkinType.MONSTER,model,Config.monsterPath);
				//this.setSkin(ElementSkinType.SHADOW,model,Config.monsterPath);
			}
		}
	}
}