package com.rpg.framework.loader
{
	import com.rpg.entity.AnimalSkinData;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.enum.Constant;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.loader.ActionAssets;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.actor.skin.effect.EffectSkinData;
	import com.rpg.scene.actor.skin.monster.MonsterSkinData;
	import com.rpg.scene.actor.skin.role.RoleSkinClothData;
	import com.sh.game.consts.ResourceType;
	import com.sh.game.util.ModelName;
	
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	

	public class ActionLoader extends GameComponent
	{
		
		private static var _instance:ActionLoader = null;
		private var _datas:Object;
		private var _resDic:Dictionary;
		
		public var cacheCompleteHandler:Function;
		
		public function ActionLoader()
		{
			_datas = Resource.initModelsData();
			_resDic = Resource.initModelsRes();
			this.enabled = true;
		}
		
		public static function get instance():ActionLoader{
			if(_instance == null){
				_instance = new ActionLoader();
			}
			return _instance;
		}
		
		/**
		 * 初始化预加载资源
		 */
		public function initCache(women:Object,men:Object,monsters:Object,npcs:Object):void{
			setTimeout(cacheCompleteHandler,500);
		}
		
		public function load(dic:String,completeFunc:Function,model:String,type:String,action:int,dir:int = 4,addRes:Boolean = true,prority:int =0,id:int = 0,shadowfunc:Function = null):void{
			var sourceName:int  = ModelName.getSource(model,action,dir);
			var assets:ActionAssets = ObjectPoolManager.getInstance().borrowItem(Constant.ActionAssetsClass) as ActionAssets;
			assets.init(this._datas[sourceName],this._resDic[sourceName],sourceName,type);
			switch(type){
				case ElementSkinType.MOUNT:
				case ElementSkinType.MOUNT_PLUS:
				case ElementSkinType.WING:
				case ElementSkinType.CLOTHING_FOOT:
				case ElementSkinType.WEAPON_FOOT:
					var data:RoleSkinClothData = new RoleSkinClothData(model,assets,action,dir,sourceName,false);
					data.process();
					data.select = true;
					SceneCacheManager.instance.playerSkin[type].add(data.id, data);
					if(completeFunc != null)
						completeFunc(data);
					break;
				case ElementSkinType.MONSTER:
					var mdata:MonsterSkinData = new MonsterSkinData(model,assets,action,dir,sourceName,false);
					mdata.process();
					mdata.select = true;
					SceneCacheManager.instance.monsterSkin.add(mdata.id,mdata);
					if(completeFunc != null)
						completeFunc(mdata);
					break;
				case  ElementSkinType.SKILL:
					var edata:EffectSkinData = new EffectSkinData(model,assets,action,dir,sourceName,false);
					edata.process();
					SceneCacheManager.instance.skillSkin.add(edata.fileName, edata);	
					if(completeFunc != null)
						completeFunc(edata);
					break;
			}
		}
		
		
		
		private function onCompleteFunc(sourceName:int,model:String,action:int,dir:int = -1,thread:Boolean  = true,assets:ActionAssets= null):void{
			/*delete _readers[sourceName];
			if(assets != null){
				switch(assets.type){
					case ElementSkinType.MOUNT:
					case ElementSkinType.MOUNT_PLUS:
					case ElementSkinType.WING:
					case ElementSkinType.CLOTHING_FOOT:
						var data:RoleSkinClothData = new RoleSkinClothData(model,assets,action,dir,sourceName,thread,_comShadowFuncs[sourceName]);
						delete _comShadowFuncs[sourceName];
						if(thread)
							SceneCacheManager.instance.skinProcess.add(data.id,data);
						data.analyzeComplete = function onAnalyzeComplete(data : AnimalSkinData) : void
						{
							data.select = true;
							if(thread)
								SceneCacheManager.instance.skinProcess.remove(data.id,false);
							// 添加数据缓存   男女的裸体模型放到默认模型皮肤中
							
							//ObjectPoolManager.getInstance().returnItem(Constant.ActionAssetsClass,assets);
							SceneCacheManager.instance.playerSkin[assets.type].add(data.id, data);
							if(!analyzeComplete(sourceName,data,dir)){
								SceneCacheManager.instance.checkReference(assets.type,data.fileName);
							}
						};
						if(!thread)
							data.process();
						break;
					case  ElementSkinType.SKILL:
						var edata:EffectSkinData = new EffectSkinData(model,assets,action,dir,sourceName,thread);
						edata.fileName = sourceName;
						SceneCacheManager.instance.skinProcess.add(edata.id,edata);
						edata.analyzeComplete = function onAnalyzeComplete(data : AnimalSkinData) : void
						{
							SceneCacheManager.instance.skinProcess.remove(data.id,false);
							SceneCacheManager.instance.skillSkin.add(data.fileName, data);	
							if(!analyzeComplete(sourceName,data,dir)){
								// 添加数据缓存
								SceneCacheManager.instance.checkReference(assets.type,data.fileName);
							}
						};
						if(!thread)
							edata.process();
						break;
				}
			}else{
				analyzeComplete(sourceName,null,dir);
			}
			*/
		}
		
		
	}
}