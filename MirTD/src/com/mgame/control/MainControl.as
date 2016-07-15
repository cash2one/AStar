package com.mgame.control
{
	import com.core.Facade;
	import com.core.inter.IControl;
	import com.mgame.model.CfgLoader;
	import com.mgame.model.ConfigData;
	import com.mgame.model.LocalCache;
	import com.mgame.model.ModelName;
	import com.mgame.model.PlayerData;
	import com.mgame.view.popup.Alert;
	import com.sh.game.global.Config;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	import consts.ViewName;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 上午9:22:09
	 * 
	 */
	public class MainControl implements IControl
	{
		private var _main:Object;
		private var _app:Facade;
		public function MainControl(main:Object)
		{
			this._main = main;
			_app = Facade.instance;
		}
		
		public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.MAIN){
				switch(cmd){
					case CMDMain.VIEW_INIT_COMPLETE:
						initGame();
						break;
					case CMDMain.MAIN_MENU:
						changeView(ViewName.MAIN_MENU);
						break;
					case CMDMain.LEVEL_SELECT:
						changeView(ViewName.LEVEL_SELECT);
						break;
					case CMDMain.BATTLE_SCENE:
						changeView(ViewName.BATTLE_SCENE);
						break;
					case CMDMain.TIANFU_VIEW:
						changeView(ViewName.TIANFU_VIEW);
						break;
					case CMDMain.ENTER_GAME:
						startBattle();
						break;
					case CMDMain.GAME_OVER:
						//changeView(ViewName.LEVEL_SELECT);
						_app.sendNotification(ControlGroup.RESULT_WINDOW,CMDMain.SHOW,2);
						_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.END_ZONE);
						PlayerData.save();
						break;
					case CMDMain.LEVEL_CLEAR:
						var lv:int = _app.getModel(ModelName.CUR_MAPID);
						PlayerData.setMaxLevel(lv);
						PlayerData.save();
						_app.sendNotification(ControlGroup.RESULT_WINDOW,CMDMain.SHOW,1);
						_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.END_ZONE);
						//changeView(ViewName.LEVEL_SELECT);
						break;
					case CMDMain.NOTICE:
						if(data is Array)
							_main.addNotice(data[0],data[1]);
						else
							_main.addNotice(data);
						break;
					case CMDMain.ADD_GOLD:
						var gold:int = PlayerData.getGoldLocal() + int(data);
						PlayerData.setGoldLocal(gold);
						if(gold < 0)
							PlayerData.save();
						Facade.instance.sendNotification(ControlGroup.RES,CMDMain.ADD_GOLD,gold);
						break;
				}
			}
		}
		
		/**
		 * 游戏组件初始化完毕，显示主菜单
		 */
		private function initGame():void{
			this.initConfigs();
		}
		
		private function configComplete():void{
			this.initData();
			this.changeView(1);
		}
		
		/**
		 * 切换视图 
		 * @param state
		 */
		private function changeView(state:int):void{
			var curstate:int = _app.getModel(ModelName.STATE);
			if(curstate != state)
			{
				_app.setModel(ModelName.STATE,state);
				if(state == ViewName.MAIN_MENU){
					_app.sendNotification(ControlGroup.MAIN_MENU,CMDMain.SHOW);
					_app.sendNotification(ControlGroup.LEVEL_SELECT,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.HIDE);	
					_app.sendNotification(ControlGroup.TIANFU_VIEW,CMDMain.HIDE);	
				}else if(state == ViewName.LEVEL_SELECT){
					_app.sendNotification(ControlGroup.MAIN_MENU,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.LEVEL_SELECT,CMDMain.SHOW);
					_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.HIDE);	
					_app.sendNotification(ControlGroup.TIANFU_VIEW,CMDMain.HIDE);	
				}else if(state == ViewName.BATTLE_SCENE){
					_app.sendNotification(ControlGroup.MAIN_MENU,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.LEVEL_SELECT,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.SHOW);	
					_app.sendNotification(ControlGroup.TIANFU_VIEW,CMDMain.HIDE);	
				}else if(state == ViewName.TIANFU_VIEW){
					_app.sendNotification(ControlGroup.MAIN_MENU,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.LEVEL_SELECT,CMDMain.HIDE);
					_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.HIDE);	
					_app.sendNotification(ControlGroup.TIANFU_VIEW,CMDMain.SHOW);	
				}
			}
		}
		
		/**
		 * 初始化配置
		 */
		private function initConfigs():void{
			if(Config.debug){
				CfgLoader.instance.loadMapData(ConfigData.cfgUrls,cfgLoaded);
			}else{
				ConfigData.init();
				configComplete();
			}
		}
		
		private function cfgLoaded(cfgs:Array):void{
			ConfigData.initDebug(cfgs);
			configComplete();
		}
		
		/**
		 * 初始化游戏数据 
		 */
		private function initData():void{
			var cache:Object = LocalCache.getInstance().getValue("levels");
		}
		
		private function startBattle():void{
			var curlv:int = this._app.getModel(ModelName.CUR_SELECT_LEVEL);//选中关卡
			if(curlv > 0){
				changeView(ViewName.BATTLE_SCENE);
				_app.setModel(ModelName.CUR_MAPID,curlv);
				_app.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.ENTER_ZONE);
			}else{
				Alert.show("错误","请选择关卡",["确认"]);
			}
		}
	}
}