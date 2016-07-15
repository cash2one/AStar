package com.rpg.scene.actor.skin.effect
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.entity.AnimalSkinData;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.loader.ActionAssets;
	
	import flash.utils.Dictionary;
	
	public class EffectSkinData extends AnimalSkinData
	{
		public function EffectSkinData(model:String,reader:ActionAssets,action:int,dir:int,sourcename:int, isThread:Boolean=true)
		{
			super(model,reader,action,dir,sourcename,isThread,null);
			var cfgs:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var modelscfg:Object = cfgs[ConfigData.MODELS];
			var cfg:Array;
			if(modelscfg[model] != null && modelscfg[model][action]){
				cfg = modelscfg[model][action];
			}else{
				var _action:Dictionary = SkinConfig.getSkill();
				cfg = _action[action];
			}
			this.createActionClips(action      , dir,cfg,SkinConfig.getLoop(action));
		}
	}
}