package com.rpg.entity.animation
{
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.scene.SceneCacheManager;
	

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-5-8 下午2:27:15
	 * 
	 */
	public class BodySkinDataSet extends AnimationPlayerDataSet
	{
		public function BodySkinDataSet(skinType:String, callback:Function, model:String, defaultCfg:Object, plusType:String=null)
		{
			super(skinType, callback, model, defaultCfg, plusType);
		}
		
		override public function dispose():void{
			_model = null;
			turn = 0;
			for (var key:String in _actions) 
			{
				if(_actions[key] != null){
					for (var i:int = 0; i < 8; i++) 
					{
						var data:AnimationPlayerData = _actions[key][i];
						if(data && data.fileName){
							SceneCacheManager.instance.removeReference(this.skinType,data.fileName);
						}
					}
					_actions[key] = null;
				}
			}
			_cfg = null;
			_actions = null;
			_defaultCfg = null;
			_parentType = null;
			skinType = null;
			skinPath = null;
			this._id = 0;
			visible = false;
			this.callback = null;
		}
	}
}