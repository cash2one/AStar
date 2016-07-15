package com.rpg.scene.actor.skin.role
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.entity.AnimalSkinData;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.loader.ActionAssets;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.scene.SceneCacheManager;
	
	import flash.utils.Dictionary;
	
	public class RoleSkinClothData extends AnimalSkinData
	{
		public function RoleSkinClothData(model:String,reader:ActionAssets, action:int,dir:int,sourcename:int,isThread:Boolean=true,bshadow:Array = null)
		{
			super(model,reader,action,dir,sourcename,isThread,bshadow);
			var cfgs:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var modelscfg:Object = cfgs[ConfigData.MODELS];
			var cfg:Array;
			if(modelscfg[model] != null && modelscfg[model][action]){
				cfg = modelscfg[model][action];
			}else{
				var _action:Dictionary = SkinConfig.getPlayer();
				cfg = _action[action];
			}
			this.createActionClips(action      , dir,cfg,SkinConfig.getLoop(action));
		}
		
	}
}