package com.rpg.scene
{
	import com.core.Facade;
	import com.mgame.battle.Zone;
	import com.mgame.model.ModelName;
	import com.rpg.framework.DrawableGameComponent;
	import com.rpg.framework.GameTime;
	import com.sh.game.consts.ConnectType;
	import com.sh.game.global.Config;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	
	/** 管理不同类型的场影实例 */
	public class SceneManager extends DrawableGameComponent
	{
		private var _scenes		   : Dictionary; // 游戏场影集合
		private var _previousScene : SceneBase;  // 上一个游戏场景
		private var _currentScene  : SceneBase;  // 当前活动的游戏场景
		private var _sceneClass    : Class;		 // 当前使用场景类型
		private var firstConnect:Boolean = true;
		private var _stagePos:Point = new Point();
		private var _rolePos:Point = new Point();
		/**
		 * 玩家数据
		 */
		private var _usersDic:Dictionary;
		private var _myRid:Number;
		
		/** 获取当前场景 */
		public function get current() : SceneBase
		{
			return _currentScene;
		}
		
		public function SceneManager()
		{
			this.display.name = "SceneManager";
			this.display.mouseEnabled = true;
			//ModelProxy.change("data","stagePos",_stagePos);
			//ModelProxy.change("data","rolePos",_rolePos);
			_scenes = new Dictionary();
		}

		protected override function loadContent() : void
		{
			this.enabled = false;
		}
		
		/** 添加一个场景类型 */
		public function add(name :int, c : Class) : void
		{
			_scenes[name] = c;
		}
		
		/** 开启一个指定名称的场景 */
		public function start(type:int) : void
		{
				_sceneClass = _scenes[type];
		}
		
		/** 转场 */
		public function transfer(mapId : int, instanceid : int = -1) : void
		{
			if (_previousScene == null) // 上一个场景没成功卸载之间不可以进行转场操作
			{
				this.enabled 			   = false;
				this.display.mouseEnabled  = false;
				this.display.mouseChildren = false;
				
				/** 通知开始加载场景（删除上一场景加载对列） */
				//Component.engine.sendNotification(SceneNotification.SCENE_LOAD_OPEN, this.current);

				if (_currentScene)
				{
					_currentScene.enabled = false;		// 用于转场时，规避并发导致的寻路问题
					_previousScene = _currentScene;
				}
				_currentScene 			= new _sceneClass();
				_currentScene.mapId	    = mapId; 		// 地图编号（或副本编号）
				//MapLoader.getInstance(true,mapId,Config.mapPath + mapId);
				_currentScene.instanceid = instanceid;
				_currentScene.gameSceneLoadComplete = onGameSceneLoadComplete;
				_currentScene.initialize();
			}
		}
		
		/** 新场景加载完成事件 */
		private function onGameSceneLoadComplete() : void
		{
			if (_previousScene != null)
			{
				_previousScene.dispose();
				_previousScene = null;
				
				// 清理缓存
				SceneCacheManager.instance.clear();
				//return;
			}
			
			this.display.addChild(_currentScene.display);
			
			/** 通知场景加载完成 */
			
			this.enabled 			   = true;
			this.display.mouseEnabled  = true;
			this.display.mouseChildren = true;
			//登陆场景
			
			loginZone();
			
		}
		
		
		private function loginZone():void{
			
			this.enterZone(Facade.instance.getModel(ModelName.PLAYER_ROLE_DATA));
			/*var entersTest:Array = [];
			for (var i:int = 1; i < 600; i++) 
			{
				entersTest.push({mid:monsterArr[int(Math.random() * monsterArr.length)],rid:i,name:"npc121233",serverid:1,model:"50000",x:20 * Math.random()+58,y:20 * Math.random()+92,dir:5,id:i,type:ActorType.Monster,ability:{hp:100,maxHp:100},arms:[],npcid:9});
				//entersTest.push({mid:2,rid:2,name:"npc121233",serverid:1,model:"10000",x:108,y:60,id:2,type:ActorType.NPC,ability:{hp:100,maxHp:100},arms:[],npcid:8});
			}
			this.enterView(entersTest);*/
		}
		
		
		
		public function enterZone(user:Object,instance:Boolean = false):void
		{
			_myRid = user.id;
			this._currentScene.addElement(user.type,user,true);
			this._currentScene.initZone();
			this.BfirstEnter = 0;
			/*for (var i:int = 0; i < 1000; i++) 
			{
				var x:int = Math.random() * 800;
				var y:int = Math.random() * 500;
				user.x = x;
				user.y = y;
				user.id = int(user.id) + 1;
				this.addRole(user,true);
				setTimeout(removeRole,8000,user.id);
			}
			*/
		}
		/**
		 *玩家第一次进入 
		 */		
		public var BfirstEnter:int = 0;
		public function enterView(elements:Object):void{
			if(this._currentScene.enabled){
				for each(var ele:Object in elements){
					//this._usersDic[ele.id] = ele;
					if(ele.id == this._myRid){
						initPlayer(ele);
					}else {
						//trace(ele.name + "进入场景");
						//this.addRole(ele);
						this._currentScene.addElement(ele.type,ele);
					}
				}
				if(BfirstEnter <2)
				{
					BfirstEnter++;
				}
			}
			this._currentScene.updateElementCount();
			
		}
		
		/**离开场景*/
		public function exitView(users:Object):void{
			for each(var rid:Object in users){
				this._currentScene.removeElement(Number(rid));
			}
			this._currentScene.updateElementCount();
		}
		
		private function initPlayer(ele:Object):void
		{
			
		}
		
		
		/**
		 * 移除角色
		 * @param ele
		 * @param isme
		 * 
		 */
		private function removeRole(id:int):void
		{
			_currentScene.removeElement(id);
		}
		
		public override function update(gameTime : GameTime) : void
		{
			if (this.enabled)
			{
				/*try
				{*/
				if(_currentScene.enabled)
					_currentScene.update(gameTime);
				/*} 
				catch(error:Error) 
				{
					if(Config.debug)
					{
						throw error;
//						NbLog.getInstance().checkError(error);
					}
					else
					{
						if(Config.Log > LogType.ERROR)
							NbLog.getInstance().checkError(error,ErrorType.RenderType,"主循环报错");
					}
				}
					*/
			}
		}
		
		public function command(cmd:String,arg:Object):void{
			if(_currentScene)
				this._currentScene.command(cmd,arg);
		}
		
		
		
		public function autoMove(x:int,y:int,stageid:int = -1,standon:Boolean = false,attack:Boolean = false,onhorse:Boolean = false,stoptaskMove:Boolean = false):Boolean{
			return false;//(this._currentScene as Zone).process.autoMove(x,y,stageid,standon,attack,onhorse,stoptaskMove);
		}
		
		public function resize():void
		{
			if(_currentScene)
				_currentScene.resize();
		}
		
		public function stop():void{
			if(_currentScene)
				_currentScene.stop();
		}
		
		public function end():void{
			if(_currentScene)
				(_currentScene as Zone).end();
		}
		
		public function init():void
		{
			var mapid:int = Facade.instance.getModel(ModelName.CUR_MAPID);
			var list:Object = ConfigDictionary.data.maplist;
			var type:int = int(list[mapid].cls);
			start(type);
			this.transfer(mapid);
		}
	}
}
