package com.rpg.scene.actor.skin.npc
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.entity.AnimalSkinData;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.loader.ActionAssets;
	
	import flash.utils.Dictionary;
	
	public class NpcSkinData extends AnimalSkinData
	{
		public function NpcSkinData(model:String,reader:ActionAssets,  action:int,dir:int,sourcename:int,isThread:Boolean=true,bshadow:Array = null)
		{
			super(model,reader,action,dir,sourcename,isThread,bshadow);
			var cfg:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var modelscfg:Object = cfg[ConfigData.MODELS];
			var cfg:Array;
			if(modelscfg[model] != null && modelscfg[model][action]){
				cfg = modelscfg[model][action];
			}else{
				var _action:Dictionary = SkinConfig.getNpc();
				cfg = _action[action];
			}
			this.createActionClips(action      , dir,cfg,SkinConfig.getLoop(action));
		}
	}
}