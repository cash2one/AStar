package com.rpg.entity.animation
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.IDisposable;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.scene.SceneCacheManager;
	import com.sh.game.consts.DirectionType;
	import com.sh.game.util.Logger;
	
	import flash.utils.Dictionary;
	
	public class AnimationPlayerDataSet implements IDisposable
	{
		

		public function get id():int
		{
			return _id;
		}

		protected var _actions:Dictionary;
		protected var _model:String;
		public var callback:Function;
		public var enabled:Boolean = true;
		public var visible:Boolean;
		protected static var __id:int;
		protected var _id:int;
		public var skinType:String;
		protected var _defaultCfg:Object;
		public var turn:int = 1;
		private var _isShadow:Boolean;
		protected var _cfg:Object;
		/**
		 * 父类型， 玩家 npc  怪物
		 * 用于区分阴影缓存
		 */
		protected var _parentType:String;
		
		public var skinPath:String;
		
		
		
		public function AnimationPlayerDataSet(skinType:String,callback:Function,model:String,defaultCfg:Object,skinPath:String,plusType:String = null)
		{
			this.callback = callback;
			this.skinType = skinType;
			this.skinPath = skinPath;
			this._parentType = plusType;
			_isShadow = (this.skinType == ElementSkinType.SHADOW_OUT || this.skinType == ElementSkinType.SHADOW);
			this._id = ++__id;
			this._model = model;
			var cfg:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var modelscfg:Object = cfg[ConfigData.MODELS];
			if(modelscfg[model] != null ){
				this._cfg = modelscfg[model];
			}
			this._defaultCfg = defaultCfg;
			_actions = new Dictionary();
		}
		
		public function getActionCfg(action:int):Object{
			if(_cfg == null || _cfg[action] == null){
				if(_defaultCfg != null)
					return this._defaultCfg[action];
				else
					return null;
			}
			return _cfg[action];
		}

		public function get model():String
		{
			return _model;
		}

		/**
		 * 添加动作剪辑单方向数据
		 * @param action			动作
		 * @param dir				方向
		 * @param data			影片数据
		 * @param isEightDir   是否是八方向，如果不是，会去取配置，自动把镜像方向也加入
		 * 
		 */
		public function addData(action:int,dir:int,data:AnimationPlayerData,isEightDir:Boolean = false):void{
			if(_actions[action] == null){
				_actions[action] = [];
			}
			var i:int;
			if(isEightDir){
				addDirData(action,dir,data);
			}else{
				var actionCfg:Object = getActionCfg(action);
				if(this._isShadow){//要么1方向，要么8方向
					if(actionCfg != null && actionCfg[0] == 1){//1方向
						for (i = 0; i < 8; i++) 
						{
							addDirData(action,i,data);
						}
					}else{
						addDirData(action,dir,data);
					}
				}else{
					if(actionCfg != null && actionCfg[0] == 5 && (dir < 5  && dir > 0)){//5方向
						for (i = 0; i < DirectionType.EIGHT_MIRROR_DIRS.length; i++) 
						{
							if(dir == DirectionType.EIGHT_MIRROR_DIRS[i]){
								addDirData(action,i,data);
							}
						}
					}else if(actionCfg != null && actionCfg[0] == 1){//1方向
						for (i = 0; i < 8; i++) 
						{
							addDirData(action,i,data);
						}
					}else{
						addDirData(action,dir,data);
					}
				}
				
			}
		}
		
		private function addDirData(action:int,dir:int,data:AnimationPlayerData):void{
			if(_actions[action][dir] != null)
			{
				throw new Error("action:" + action + " dir:" + dir + "已经存在了");
			}
			_actions[action][dir] = data;
			SceneCacheManager.instance.addReference(skinType,data.fileName,_parentType);
			/*if(Config.Log > LogType.DEBUG)
				Logger.log("addReference  " + skinType + "   " +action  + "  " + dir + "   filename  " + data.fileName);*/
			/*if(skinType == "shadow")
				Logger.log("shadow++   " + data.fileName,1);*/
		}
		
		
		public function removeData(action:int,dir:int):void{
			if(_actions[action] != null && _actions[action][dir] != null){
				_actions[action][dir] = null;
			}
		}
		
		public function getDir(action:int,dir:int):int{
			var actionCfg:Object = getActionCfg(action);
			if(this._isShadow){
				if(actionCfg != null && actionCfg[0] == 1){//如果是1方向影子也是1方向
					dir = 4;
				}
			}else{
				if(actionCfg != null && actionCfg[0] == 5 && dir >= 5){
					dir = DirectionType.EIGHT_MIRROR_DIRS[dir];
				}else if(actionCfg != null && actionCfg[0] == 1){
					dir = 4;
				}
			}
			
			return dir;
		}
		
		public function getData(action:int,dir:int):AnimationPlayerData{
			if(this._actions){
				if(this._actions[action] != null){
					return this._actions[action][dir];
				}
			}
			return null;
		}
		
		public function getDataAndTurn(action:int,dir:int):AnimationPlayerData{
			if(this._actions){
				if(this._actions[action] != null){
					if(!_isShadow){
						if(_actions[action][dir] && (_actions[action][dir].model == AnimationPlayer.DefaultModel1 || _actions[action][dir].model == AnimationPlayer.DefaultModel0))
						{
							turn = 1;
						}else{
							var actionCfg:Object = getActionCfg(action);
							if(actionCfg != null && actionCfg[0] == 5 && dir >= 5){
								turn = -1;
							}else{
								turn = 1;
							}
						}
					}
					return this._actions[action][dir];
				}
			}
			return null;
		}
		
		
		public function dispose():void
		{
			_model = null;
			turn = 0;
			_isShadow = false;
			for (var key:String in _actions) 
			{
				if(_actions[key] != null){
					for (var i:int = 0; i < 8; i++) 
					{
						var data:AnimationPlayerData = _actions[key][i];
						if(data && data.fileName){
							SceneCacheManager.instance.removeReference(this.skinType,data.fileName,_parentType);
							/*if(Config.Log > LogType.DEBUG)
								Logger.log("removeReference  " +  key  + "  " + i + "  filename:" + data.fileName);*/
							/*if(skinType == "shadow")
								Logger.log("shadow--   " + data.fileName,1);*/
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