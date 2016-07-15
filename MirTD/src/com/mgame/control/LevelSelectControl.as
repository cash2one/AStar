package com.mgame.control
{
	import com.core.Facade;
	import com.core.control.ViewControl;
	import com.core.inter.IControl;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	import com.mgame.model.PlayerData;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:53:10
	 * 
	 */
	public class LevelSelectControl extends ViewControl
	{
		private var inited:Boolean = false;
		public function LevelSelectControl(view:Object)
		{
			super(view);
		}
		
		private function init():void{
			var cfgs:Object = Facade.instance.getModel(ModelName.GAME_CONFIG);
			var levels:Object = cfgs[ConfigData.LEVELS];
			this._view.initLevels(levels);
		}
		
		private function updateLevels():void{
			var lv:int = PlayerData.getMaxLevel();
			this._view.changeLv(lv);
			var curlevel:int = PlayerData.getMaxLevel();
			this.selectHandler(curlevel + 1);
		}
		
		override public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.LEVEL_SELECT){
				switch(cmd){
					case CMDMain.SHOW:
						this._view.show();
						if(!inited)
						{
							inited = true;
							this.init();
						}
						updateLevels();
						break;
					case CMDMain.HIDE:
						this._view.hide();
						break;
					case CMDMain.USER_SELECT_LEVEL:
						this.selectHandler(data);
						break;
				}
			}
		}
		
		private function selectHandler(data:Object):void{
			Facade.instance.setModel(ModelName.CUR_SELECT_LEVEL,data);
			this._view.select(data);
		}
	}
}