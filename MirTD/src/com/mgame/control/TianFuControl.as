package com.mgame.control
{
	import com.core.Facade;
	import com.core.control.ViewControl;
	import com.mgame.model.ConfigData;
	import com.mgame.model.PlayerData;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-8 上午11:12:43
	 * 
	 */
	public class TianFuControl extends ViewControl
	{
		public function TianFuControl(view:Object)
		{
			super(view);
		}
		private var _inited:Boolean = false;
		
		override public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.TIANFU_VIEW){
				switch(cmd){
					case CMDMain.SHOW:
						this._view.show();
						if(!_inited){
							this._view.initItems();
							_inited = true;
						}
						this._view.setGold(PlayerData.getGoldLocal());
						break;
					case CMDMain.HIDE:
						this._view.hide();
						break;
					case CMDMain.TIANFU_ADD:
						this.tianfuAdd(data);
						break;
				}
			}else if(group == ControlGroup.RES){
				switch(cmd){
					case CMDMain.ADD_GOLD:
						this._view.setGold(PlayerData.getGoldLocal());
						break;
				}
			}
		}
		
		private function tianfuAdd(data:*):void{
			var tianfu:Object = PlayerData.getTianfu();
			var cfg:Object = ConfigData.allCfgs[ConfigData.TIANFU];
			var curlv:int = tianfu[data.id];
			if(cfg[data.id][curlv + 1]){
				var cfgNext:Object = cfg[data.id][curlv + 1];
				var gold:int = PlayerData.getGoldLocal();
				if(gold < int(cfgNext.gold)){
					Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.NOTICE,"金币不足");
				}else{
					Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.ADD_GOLD,-int(cfgNext.gold));
					tianfu[data.id] = curlv + 1;
					PlayerData.setTianfu(tianfu);
					Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.NOTICE,data.name+" 升级成功");
					this._view.setItemLv(data.id,curlv + 1);
				}
			}else{
				Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.NOTICE,"已经是最高级");
			}
			
		}
	}
}