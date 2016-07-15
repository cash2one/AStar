package
{
	
	import com.core.Facade;
	import com.mgame.battle.Zone;
	import com.mgame.model.ModelName;
	import com.mgame.model.PlayerData;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.Constant;
	import com.rpg.framework.Fps;
	import com.rpg.framework.FpsManager;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IDrawable;
	import com.rpg.framework.IGameComponent;
	import com.rpg.framework.IUpdateable;
	import com.rpg.framework.collections.ArrayCollection;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.framework.system.memory.CacheManager;
	import com.rpg.framework.system.thread.ThreadManager;
	import com.rpg.framework.system.timer.RendersManager;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneCacheManager;
	import com.rpg.scene.SceneManager;
	import com.rpg.scene.control.DisposeManager;
	import com.sh.game.global.Config;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	[SWF(backgroundColor = "#0",frameRate="60",  width = "1000", height = "580")]
	public class sctjZoneNew extends Sprite
	{
		
		private var _gameTime 				     : GameTime = new GameTime();								// 游戏时间对象
		private var _isRun   				     : Boolean  = false;										// 是否开始运行
		private var _isMouseVisible 			 : Boolean  = true;											// 是否不显示鼠标
		private var _iskeyboardEnabled		     : Boolean  = true;											// 键盘事件是否启用		
		private var _interval        		     : int;														// 每帧间隔时间	
		private var _tween 						 : int;														// 更新循环补间数
		private var _gameComponents              : ArrayCollection;											// 游戏组件集合（IGameComponents）
		private var _updateableComponents 		 : Vector.<IUpdateable>    = new Vector.<IUpdateable>();	// 更新对象集合
		private var _currentlyUpdatingComponents : Vector.<IUpdateable>    = new Vector.<IUpdateable>();	// 当前更新的组件集合
		private var _width    		   		     : Number;													// 游戏窗口宽度
		private var _height    		    	     : Number;													// 游戏窗口高度
		private var _scene:SceneManager;
		public var thread:ThreadManager;
		private var _swfLoader:Loader;
		private var _renderManager:RendersManager;		
		public function sctjZoneNew()
		{
			super();
			init();
		}
		
		private function init():void{
		//	this.addChild(new TheMiner);
			
			Config.gameParams = new Object();
			Config.gameParams.client = 1;
			/*GlobalLayer.instance.init(this.stage);
			GlobalLayer.instance.regLayer("zoneCon",this);*/
			GlobalLayer.instance.root.addEventListener(Event.ENTER_FRAME, onUpdate);
			_gameComponents 		= new ArrayCollection(false);
			_gameComponents.added   = onGameComponentAdded;
			_gameComponents.removed = onGameComponentRemoved;
			//_gameComponents.add(new Fps());
			this._renderManager = RendersManager.instance;
			this._renderManager.addCompnent(DisposeManager.instance);
			_scene = new SceneManager();
			_gameComponents.add(_scene);
			
			thread = ThreadManager.instance;
			thread.init(60);
			_gameComponents.add(thread);
			thread.addDict("skinthread");
			thread.addDict("shadowthread");

			// 内存回收管理
			var memory:CacheManager 			= CacheManager.instance;
			memory.limit    = Config.memoryLimit;
			memory.loopTime = Config.memoryInterval;
			_gameComponents.add(memory);
			
			var loader:ActionLoader = ActionLoader.instance;
			_gameComponents.add(loader);
			
			
			ObjectPoolManager.getInstance().initPool(Constant.TweenClass,1200);
			ObjectPoolManager.getInstance().initPool(Constant.mapTileUrlClass,100);
			ObjectPoolManager.getInstance().initPool(Constant.ActionAssetsClass,100);
			ObjectPoolManager.getInstance().initPool(Constant.TimerClass,100);
			ObjectPoolManager.getInstance().initPool(Constant.TimerHandlerClass,100);
			ObjectPoolManager.getInstance().initPool(Constant.EffectClass,0);
			_scene.add(1,Zone);
		}
		
		
		protected function resizeHandler(event:Event):void
		{
			if(this._scene){
				this._scene.resize();
			}
		}
		
		/** 添加游戏组件成功事件 */
		private function onGameComponentAdded(item : IGameComponent) : void
		{
			item.initialize();
			// 添加游戏逻辑组件
			if (item is IUpdateable)
			{
				var gameComponent : IUpdateable = item as IUpdateable;
				_updateableComponents.push(item);
			}
			
			if (item is IDrawable)
			{
				addChildAt(IDrawable(item).display,0);
			}
		}
		
		/** 删除游戏组件成功事件 */
		private function onGameComponentRemoved(item : IGameComponent) : void
		{
			var index : int;
			if (_isRun == false) // 删除时组件还没有初始化
			{
				
			}
			var gameComponent : IUpdateable = item as IUpdateable;
			if (gameComponent != null)
			{
				index = _updateableComponents.indexOf(gameComponent);
				if (index > -1)
				{
					_updateableComponents.splice(index, 1);
				}
			}
			
			if (item is IDrawable)
			{
				removeChild(IDrawable(item).display);
			}
		}
		
		/** 重绘消息循环 */
		private function onUpdate(e : Event) : void
		{
			// 经验：FlashPlayer在窗口最小化失去焦点时，帧频会变为2。为保证游戏数据计算正确，添加补差更新。
			_gameTime.elapsedGameTime = getTimer() - _gameTime.totalGameTime;
			_gameTime.totalGameTime   = getTimer();
			_tween				 	  = _gameTime.elapsedGameTime / _interval;
			_tween 					  = _tween == 0 ? 1 : _tween;
			_gameTime.elapsedGameTime = _gameTime.elapsedGameTime / _tween;
			for (var i : int = 0; i < _tween; i++)
			{
				this.update(_gameTime);
			}
			_renderManager.update(_gameTime);
		}
		
		/** 游戏逻辑更新 */
		protected function update(gameTime : GameTime) : void
		{
			for each (var updateable : IUpdateable in _updateableComponents)
			{
				if (updateable.enabled)
				{
					updateable.update(gameTime);
				}
			}
			_currentlyUpdatingComponents = null;
		}
		
		/** 当前游戏时间对象 */
		public function get time() : GameTime
		{
			return _gameTime;
		}
		
		public function initZone(id:int):void
		{
			Facade.instance.setModel(ModelName.PLAYER_ROLE_DATA,com.mgame.model.PlayerData.getRoleData())
			_scene.start(1);
			_scene.transfer(id);
			Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.UPDATE_BATTLE_VIEW);
		}
		
		public function end():void{
			this._scene.end();
		}
	}
}