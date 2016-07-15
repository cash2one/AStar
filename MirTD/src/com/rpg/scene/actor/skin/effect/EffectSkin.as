package com.rpg.scene.actor.skin.effect
{
	import com.rpg.entity.AnimalSkinData;
	import com.rpg.entity.BodySkin;
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationEventArgs;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.entity.animation.AnimationPlayerDataSet;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.actor.Effect;
	import com.sh.game.global.Config;
	import com.sh.game.util.ModelName;
	
	
	public class EffectSkin extends BodySkin
	{
		private var _effect:Effect;
		
		public function EffectSkin(element:ElementBase,randomFrame:Boolean)
		{
			super(element);
			_randomFrame = randomFrame;
			this._effect = element as Effect;
		}
		
		public function set randomFrame(random:Boolean):void{
			this._randomFrame = random;
		}
		
		override public function setSkin(skinType : String,model:String,path:String):void{
			addType(skinType, showEffect, path,model,SkinConfig.getSkill());
		}
		
		private function showEffect(data:AnimationPlayerData):void
		{
			this.processComplete(ElementSkinType.SKILL, data);
			if(data)this._effect.stopEnd();
		}
		
		override protected function getCacheData(skinType : String = null) : CacheCollection
		{
			return SceneCacheManager.instance.skillSkin;
		}
		
		override protected function loadSkin(skinType:String,action:int,dir:int):void
		{
			var skinTypeData : AnimationPlayerDataSet = this._dataList[skinType];
			
			if (skinTypeData && skinTypeData.enabled)
			{
				var o:Object = this.getCacheData(skinType);
				var cache : * = o != null?this.getCacheData(skinType).getData(ModelName.getSource(skinTypeData.model,action,dir)):null;
				if (cache)
				{
					skinTypeData.callback(cache);
					
					// 皮肤添加事件
					//SceneCacheManager.instance.addReference(skinType,cache.fileName);
				}
				else
				{
					if(this._effect.loadshow || this._playMaxCount == -1)
						ActionLoader.instance.load(Config.bodySkinPath,skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,0,skinTypeData.id);
					else{
						ActionLoader.instance.load(Config.bodySkinPath,skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,0,skinTypeData.id);
						this._effect.endLater();
					}
				}
			}
		}
		
		override public function setChildByIndex(clipType : String , index : int = 0):void{
			this._effect.display.addChildAt(_animation[clipType], index);
		}
		
		/**
		 * 人物动做动画播放完成
		 * 
		 */		
		protected override function playComplete(e : AnimationEventArgs) : void
		{
			if(_effect){
				_effect.playComplete();
			}
		}
		
		/**
		 * 强制修改帧率
		 * @param value
		 */
		public function setIntval(value:int):void{
			this._changedIntval = value;
		}
		
		public function reset():void{
			for (var key : String in _dataList)
			{
				this.removeSkin(key, true);
			}
			if(_animationArgs)
				_animationArgs.clipFrameIndex = 0;
			this.inView = false;
			this.enabled = false;
			this._skinVisible = false;
			this._playCount = 0;
			this._timer.reset();
			this._lastIndex = 0;
			this.x = 0;
			this.y = 0;
		}
		
		public function relive():void{
			if(_animationArgs)
				_animationArgs.clipFrameIndex = 0;
			this._timer.reset();
			this._lastIndex = 0;
		}
	}
}