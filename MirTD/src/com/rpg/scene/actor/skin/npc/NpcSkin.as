package com.rpg.scene.actor.skin.npc
{
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationMovieClip;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.enum.ElementSkinSort;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.actor.Npc;
	import com.rpg.scene.actor.skin.RPGAnimalSkin;
	import com.sh.game.global.Config;
	
	import flash.display.BlendMode;
	
	import util.FilterSet;
	
	public class NpcSkin extends RPGAnimalSkin
	{
		private var _npc:Npc;
		private var _bianShen:String;
		private var _model:String;
		public function NpcSkin(element:ElementBase,model:String)
		{
			super(element);
			this._npc = Npc(element);
			_mouseFilter = FilterSet.mouseGlowFilter3;
			_model = model;
		}
		
		override public function setAction(compulsory:Boolean=false):void{
			super.setAction(compulsory);
		}
		
		override public function setSkin(skinType : String,model:String,path:String):void{
			switch(skinType){
				case ElementSkinType.NPC:
					addType(skinType, showNpc, path,model,SkinConfig.getNpc());
					break;
				case ElementSkinType.SHADOW:
					addType(skinType, addShadow, path,model);
					break;
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
				this.setSkin(ElementSkinType.NPC,model,Config.npcPath);
				//this.setSkin(ElementSkinType.SHADOW,model,Config.npcPath);
			}
		}
		
		
		private function addShadow(data :AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.SHADOW, data);
		}
		private function showNpc(data : AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.NPC, data);
		}
		
		override protected function getDefaultData() : CacheCollection
		{
			return SceneCacheManager.instance.defaultSkin;
		}
		
		override protected function getCacheData(skinType : String = null) : CacheCollection
		{
			return SceneCacheManager.instance.npcSkin;
		}
		
		override public function dispose():void{
			this._npc = null;
			this._bianShen = null;
			_model = null;
			super.dispose();
		}
		/** 设置皮肤的层次**/
		override protected function setSkinIndex() : void 
		{
			//super.setSkinIndex();
			var sorts:Array = ElementSkinSort.Npc_sort;
			var index:int = 0;
			if(this._shadow)
				index ++;
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
			if (this.enabled)
				this.play(_currentActionType,_currentDirection,false); // 经验：考虑是否每次调用些方些要运行play方法
		}
		
		/**
		*	选中 
		* @param i
		* 
		*/
		override public function setFocus(i:int,type:int = 0):void
		{
			if(i == 1){
			}else if(i == 2){
				if(!this._focus_2){
					/*_focus_2 = new AnimationMovieClip(RoleEmbed.getFocus2(),75,50,100);
					this._animal.components.add(_focus_2);
					_focus_2.display.filters = [FilterSet.greenFocusFilter];
					_focus_2.display.blendMode = BlendMode.ADD;
					if(!_shadow)
						this.addChildAt(_focus_2,0);
					else
						this.addChildAt(_focus_2,1);*/
				}
			}else{
				if(this._focus_2){
					this._animal.components.remove(_focus_2);
					_focus_2 = null;
				}
			}
		}
	}
}