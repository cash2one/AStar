package com.mgame.control
{
	import com.core.Facade;
	import com.core.control.ViewControl;
	import com.core.inter.IControl;
	import com.mgame.model.ModelName;
	import com.mgame.model.PlayerData;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:53:46
	 * 
	 */
	public class BattleSceneControl  extends ViewControl
	{
		public function BattleSceneControl(view:Object)
		{
			super(view);
		}
		
		override public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.BATTLE_SCENE){
				switch(cmd){
					case CMDMain.SHOW:
						this._view.show();
						break;
					case CMDMain.HIDE:
						this._view.hide();
						break;
					case CMDMain.ENTER_ZONE:
						this._view.enterZone();
						break;
					case CMDMain.END_ZONE:
						this._view.end();
						break;
					case CMDMain.UPDATE_BATTLE_VIEW:
						updateSkills();
						break;
					case CMDMain.CLEAR_SELECT_SKILL:
						this._view.clearSelectSkill();
						break;
					case CMDMain.SELECT_SKILL:
						this._view.selectSkill(data);
						break;
					case CMDMain.SKILL_CDSTART:
						this._view.skillCd(data);
						break;
					case CMDMain.HP:
						this._view.setHp(data);
						break;
				}
			}else if(group == ControlGroup.KEY_CONTROL){
				switch(cmd){
					case CMDMain.KEY_DOWN:keyDown(data);break;
					case CMDMain.KEY_UP:keyUp(data);break;
				}
			}else if(group == ControlGroup.RES){
				switch(cmd){
					case CMDMain.ADD_GOLD:
						var gold:int = PlayerData.getGoldLocal();
						this._view.setGold(gold);
						break;
				}
			}
		}
		
		private function keyDown(data:Object):void{
			
		}
		
		private function keyUp(data:Object):void{
			var e:KeyboardEvent = data as KeyboardEvent;
			var id:int ;
			switch(int(e.keyCode)){
				case Keyboard.NUMBER_1:
					id = this._view.selectSkillByIndex(0);
					if(id > 0){
						Facade.instance.sendNotification(ControlGroup.BATTLE_PROCESS,CMDMain.SELECT_SKILL,id);
						Facade.instance.setModel(ModelName.SELECT_SKILL,id);
					}
					break;
				case Keyboard.NUMBER_2:
					id = this._view.selectSkillByIndex(1);
					if(id > 0){
						Facade.instance.sendNotification(ControlGroup.BATTLE_PROCESS,CMDMain.SELECT_SKILL,id);
						Facade.instance.setModel(ModelName.SELECT_SKILL,id);
					}
					break;
				case Keyboard.NUMBER_3:
					id = this._view.selectSkillByIndex(2);
					if(id > 0){
						Facade.instance.sendNotification(ControlGroup.BATTLE_PROCESS,CMDMain.SELECT_SKILL,id);
						Facade.instance.setModel(ModelName.SELECT_SKILL,id);
					}
					break;
			}
		}
		
		private function updateSkills():void{
			var skills:Object = PlayerData.getSkills();
			var player:Object = PlayerData.getPlayerData();
			var gold:int = PlayerData.getGoldLocal();
			var maplevel:int = Facade.instance.getModel(ModelName.CUR_MAPID);
			this._view.updateData(skills,player,gold,maplevel);
		}
		
	}
}