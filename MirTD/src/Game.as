package
{
	import com.core.Facade;
	import com.core.inter.IControl;
	import com.mgame.control.BattleSceneControl;
	import com.mgame.control.LevelSelectControl;
	import com.mgame.control.MainControl;
	import com.mgame.control.MainMenuControl;
	import com.mgame.control.ResultWinControl;
	import com.mgame.control.TianFuControl;
	import com.mgame.model.LocalCache;
	import com.mgame.model.PlayerData;
	import com.mgame.view.BattleScene;
	import com.mgame.view.LevelSelect;
	import com.mgame.view.MainMenu;
	import com.mgame.view.TianFuView;
	import com.mgame.view.component.Notice;
	import com.mgame.view.popup.Alert;
	import com.mgame.view.popup.ResultWindow;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	import consts.ViewName;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-31 下午5:37:20
	 * 游戏总管
	 */
	public class Game
	{
		private var _resLoader:Loader;
		private var _notice:Notice;
		public function Game()
		{
		}
		
		/**
		 * 初始化容器
		 */
		public function initGame(stage:Stage):void{
			var zone:Sprite = new Sprite();
			stage.addChild(zone);
			var tipsDown:Sprite = new Sprite();
			stage.addChild(tipsDown);
			tipsDown.mouseChildren = false;
			tipsDown.mouseEnabled = false;
			var uiCont:Sprite = new Sprite();
			stage.addChild(uiCont);
			var uiCont2:Sprite = new Sprite();
			stage.addChild(uiCont2);
			var alert:Sprite = new Sprite();
			stage.addChild(alert);
			var tips:Sprite = new Sprite();
			stage.addChild(tips);
			tips.mouseChildren = false;
			tips.mouseEnabled = false;
			GlobalLayer.instance.init(stage);
			GlobalLayer.instance.regLayer("zoneCon",zone);
			GlobalLayer.instance.regLayer("flashTipsDown",tipsDown);
			GlobalLayer.instance.regLayer("flashTips",tips);
			GlobalLayer.instance.regLayer("flashUI",uiCont);
			GlobalLayer.instance.regLayer("popUp",uiCont2);
			GlobalLayer.instance.regLayer("alert",alert);
			
			loadRes();
		}
		
		/**
		 * 加载资源
		 */
		private function loadRes():void{
			var bytes:ByteArray = new ResourceEmbed.AllRes() as ByteArray;
			_resLoader = new Loader();
			_resLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,resCompleteHandler);
			var _loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			_resLoader.loadBytes(bytes,_loaderContext);
		}
		
		private function resCompleteHandler(e:Event):void{
			PlayerData.initData();
			initViews();
			GlobalLayer.instance.root.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			GlobalLayer.instance.root.addEventListener(KeyboardEvent.KEY_UP,keyUp);
		}
		
		/**
		 * 初始化各种视图
		 */
		private function initViews():void{
			var mainMenu:MainMenu = new MainMenu(GlobalLayer.instance.getLayer("flashUI"));
			Facade.instance.setView(ViewName.MAIN_MENU,mainMenu);
			Facade.instance.addObserver(ControlGroup.MAIN_MENU,new MainMenuControl(mainMenu));
			var levelSelect:LevelSelect = new LevelSelect(GlobalLayer.instance.getLayer("flashUI"));
			Facade.instance.setView(ViewName.LEVEL_SELECT,levelSelect);
			Facade.instance.addObserver(ControlGroup.LEVEL_SELECT,new LevelSelectControl(levelSelect));
			var battleScene:BattleScene = new BattleScene(GlobalLayer.instance.getLayer("zoneCon"),GlobalLayer.instance.getLayer("flashUI"));
			Facade.instance.setView(ViewName.BATTLE_SCENE,battleScene);
			var battleSceneControl:BattleSceneControl = new BattleSceneControl(battleScene);
			Facade.instance.addObserver(ControlGroup.BATTLE_SCENE,battleSceneControl);
			Facade.instance.addObserver(ControlGroup.KEY_CONTROL,battleSceneControl);
			Facade.instance.addObserver(ControlGroup.RES,battleSceneControl);
			
			var resultWin:ResultWindow = new ResultWindow(GlobalLayer.instance.getLayer("alert"));
			Facade.instance.setView(ViewName.RESULT_WINDOW,resultWin);
			Facade.instance.addObserver(ControlGroup.RESULT_WINDOW,new ResultWinControl(resultWin));
			
			var tianfuView:TianFuView = new TianFuView(GlobalLayer.instance.getLayer("flashUI"));
			Facade.instance.setView(ViewName.TIANFU_VIEW,tianfuView);
			var tianfuControl:TianFuControl = new TianFuControl(tianfuView);
			Facade.instance.addObserver(ControlGroup.TIANFU_VIEW,tianfuControl);
			Facade.instance.addObserver(ControlGroup.RES,tianfuControl);
			
			Alert.init(getDefine("png.alertbg"),getDefine("res.NormalBtn"),getDefine("res.CloseBtn"),GlobalLayer.instance.root);
			Facade.instance.addObserver(ControlGroup.MAIN,new MainControl(this));
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.VIEW_INIT_COMPLETE);
			
			_notice = new Notice();
			GlobalLayer.instance.getLayer("flashTips").addChild(_notice);
			_notice.x = GlobalLayer.instance.root.stageWidth / 2;
			_notice.y = 500;
		}
		
		private function keyDown(e:KeyboardEvent):void{
			Facade.instance.sendNotification(ControlGroup.KEY_CONTROL,CMDMain.KEY_DOWN,e);
		}
		
		protected function keyUp(e:KeyboardEvent):void
		{
			Facade.instance.sendNotification(ControlGroup.KEY_CONTROL,CMDMain.KEY_UP,e);
			switch(e.keyCode){
				case Keyboard.NUMPAD_SUBTRACT:
					LocalCache.getInstance().clear();
					break;
			}
		}
		
		public function addNotice(txt:String,color:uint = 0xff0000):void{
			this._notice.add(txt,color);
		}
		
		public function getDefine(name:String):Class{
			return ApplicationDomain.currentDomain.getDefinition(name) as Class;
		}
	}
}