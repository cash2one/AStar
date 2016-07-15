package com.mgame.control
{
	import com.core.Facade;
	import com.core.inter.IControl;
	import com.mgame.battle.Zone;
	import com.mgame.model.ConfigData;
	import com.mgame.model.LocalCache;
	import com.mgame.model.ModelName;
	import com.mgame.model.SkillCmdVO;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.Constant;
	import com.rpg.framework.GameTime;
	import com.rpg.scene.actor.Monster;
	import com.rpg.scene.actor.RPGAnimal;
	import com.rpg.scene.actor.Role;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-5 下午3:22:57
	 * 
	 */
	public class ProcessControl implements IControl
	{
		private var _zone:Zone;
		private var _selectSkill:Object;
		public var mouseX:int = 0;
		public var mouseY:int = 0;
		public var mouseMoved:Boolean = false;
		private var _lastMousePos:Point = new Point();
		private var _mouseIn:Boolean = true;
		private var _mouseDown:Boolean = false;
		private var _nextAttack:int = 0;
		private var _skillCfg :Object;
		private var _normalSkillCD:int = 100;
		private var _cdPecent:Number = 1;
		private var _skillcd:Dictionary;
		
		public function ProcessControl(zone:Zone)
		{
			this._zone = zone;
			_skillCfg  = ConfigData.allCfgs[ConfigData.SKILL];
			_normalSkillCD = _skillCfg[30410].sleeptime * ( (100 - zone.myRole.gameObj.baseObj.ability.speed) / 100);
			_cdPecent =  (100 - zone.myRole.gameObj.baseObj.ability.cd )/ 100;
			initMouseEvent(GlobalLayer.instance.root);
			_skillcd = Facade.instance.getModel(ModelName.SKILL_CDS);
			if(!_skillcd)
			{
				_skillcd = new Dictionary();
				Facade.instance.setModel(ModelName.SKILL_CDS,_skillcd);
			}
		}
		
		public function update(group:int, cmd:int, data:*):void
		{
			if(group == ControlGroup.KEY_CONTROL){
				switch(cmd){
					case CMDMain.KEY_DOWN:keyDown(data);break;
					case CMDMain.KEY_UP:keyUp(data);break;
				}
			}else if(group == ControlGroup.BATTLE_PROCESS){
				switch(cmd){
					case CMDMain.SELECT_SKILL:
						this.selectSkill(data);
						break;
					case CMDMain.CLEAR_SELECT_SKILL:
						this.clearSkill();
						break;
				}
			}
		}
		
		private function selectSkill(skillid:int):void{
			_selectSkill = this._skillCfg[skillid];
			if(_selectSkill.hurtarea == 2){
				this._zone.frontMcLayer.display.addChild(_zone.eclipse);
				this._zone.eclipse.draw(_selectSkill.hurtdis * 2,_selectSkill.hurtdis * 0.8 * 2,0x00ff00);
				this._zone.eclipse.x = this.mouseX - _zone.screenX;
				this._zone.eclipse.y = this.mouseY - _zone.screenY;
			}else if(_selectSkill.hurtarea == 1){
				
			}
		}
		
		private function clearSkill():void{
			this._selectSkill = null;
			if(_zone.eclipse && _zone.eclipse.parent)
				_zone.eclipse.parent.removeChild(_zone.eclipse);
			//Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.CLEAR_SELECT_SKILL);
		}
		
		public function attack():void{
			doSkill(this._zone._myRid,this.mouseX - _zone.screenX,this.mouseY - _zone.screenY,30410);
		}
		
		private function normalCdStart():void{
			
		}
		
		public function isCd(skillid:int):Boolean{
			return getTimer() < this._skillcd[skillid];
		}
		
		public function doSkill(id:int,x:int,y:int,skillid:int,shift:Boolean = false):Boolean{
			var roleMg:Role = this._zone.elements[id];
			if(roleMg == null)
				return false;
			if(!roleMg.canProcess)
				return false;
			if(this.isCd(skillid)){
				//				ModelProxy.change("movetips","error","技能cd");
				return false;
			}
			var skill:Object = _skillCfg[skillid];
			if((roleMg.busy && skill.cdonly == 0) || roleMg.moving)
				return false;
			if(roleMg.dead)
				return false;
			
			
			_zone._playSkillMovie[skillid] = true;
			this._zone.playSkillMovie(skill,roleMg,null,x ,y ,null);
			//this.sendCmd(CMDZone.Skill,{id:skillid,x:x,y:y,target:toid,shift:shift});
			if(skill.cdonly == 0){
				this.normalCdStart();
			}
			return true;
		}
		
		public function render(gameTime:GameTime):void{
			if(_selectSkill == null){
				if(_mouseDown && _nextAttack < gameTime.totalGameTime){
					attack();
					_nextAttack = gameTime.totalGameTime + _normalSkillCD;
				}
			}
		}
		
		private function keyDown(data:Object):void{
		}
		
		private function keyUp(data:Object):void{
		}
		
		private function initMouseEvent(stage:Stage):void{
			GlobalLayer.instance.getLayer("zoneCon").addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			GlobalLayer.instance.getLayer("zoneCon").addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			GlobalLayer.instance.getLayer("zoneCon").addEventListener(MouseEvent.ROLL_OUT,mouseZoneOut);
			GlobalLayer.instance.getLayer("zoneCon").addEventListener(MouseEvent.ROLL_OVER,mouseZoneIn);
			GlobalLayer.instance.getLayer("zoneCon").addEventListener(MouseEvent.MOUSE_UP,zoneMouseUp);
			GlobalLayer.instance.root.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
		
		/**
		 * 点击屏幕，移动
		 */
		protected function mouseMove(event:MouseEvent):void
		{
			mouseX = event.stageX;
			mouseY = event.stageY;
			if(_lastMousePos.x != mouseX || _lastMousePos.y != mouseY){
				mouseMoved = true;
				_lastMousePos.x = mouseX;
				_lastMousePos.y = mouseY;
			}
			if(this._selectSkill && this._zone.eclipse){
				this._zone.eclipse.x = this.mouseX - _zone.screenX;
				this._zone.eclipse.y = this.mouseY - _zone.screenY;
			}
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
		}
		
		private function mouseZoneOut(e:MouseEvent):void{
			_mouseIn = false;
			_mouseDown = false;
		}
		private function mouseZoneIn(e:MouseEvent):void{
			_mouseIn = true;
		}
		
		protected function zoneMouseUp(event:MouseEvent):void
		{
			if(this._selectSkill){
				var x:int = this.mouseX - _zone.screenX;
				var y:int = this.mouseY - _zone.screenY;
				this.doSkill(this._zone._myRid,x,y,this._selectSkill.skillid);
				if(_selectSkill.hurtarea == 2){
					var result:Object = new Object();
					result.id = _zone._myRid;
					result.toid = 0;
					result.x = x / Constant.CELL_WIDTH;
					result.y = y/Constant.CELL_HEIGHT;
					result.type = 1;
					result.servertime = getTimer();
					result.skillid = _selectSkill.skillid;
					var hurtlist:Array = getHurtList(_zone._myRid,_selectSkill,x,y);
					result.hurtlist = hurtlist;
					result.bufflist = getBufferList(_selectSkill,hurtlist);
					this._zone.roleDoSkill(result,true);
					if(_zone.eclipse && _zone.eclipse.parent)
						_zone.eclipse.parent.removeChild(_zone.eclipse);
				}
				var sleeptime:int = int(_selectSkill.sleeptime * this._cdPecent);
				this._skillcd[_selectSkill.skillid] = getTimer() + sleeptime;
				Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.SKILL_CDSTART,[_selectSkill.skillid,sleeptime]);
				Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.CLEAR_SELECT_SKILL);
				this._selectSkill = null;
			}
		}
		
		private function getBufferList(skill:Object,hurtList:Array):Array{
			if(skill.buffer > 0){
				var bufflist:Array = new Array();
				var targets:Array = new Array();
				var buffinfo:Object = new Object();
				buffinfo.bufferid = skill.buffer;
				buffinfo.dispelTime= getTimer() + int(skill.buffertime);
				for each (var hurt:Object in hurtList) 
				{
					targets.push(hurt.id);
				}
				buffinfo.hurt = skill.bufferhurt;
				buffinfo.targets = targets;
				bufflist.push(buffinfo);
				return bufflist;
			}
			return null;
		}
		
		private function getHurtList(from:int,skill:Object,x:int,y:int):Array{
			var arr:Array = new Array();
			var hurt:int = -(int(skill.hurtp) + this._zone.myRole.gameObj.baseObj.ability.att);
			for each (var ele:RPGAnimal in this._zone.elements) 
			{
				if(ele is Monster && !ele.dead){
					var distance:int =Math.sqrt( (x - ele.x) *  (x - ele.x) + (y - ele.y) * (y - ele.y)); 
					if(distance <= skill.hurtdis){
						var hurtinfo:Object = new Object();
						hurtinfo.id = ele.id;
						hurtinfo.value = hurt;
						var hp:int = ele.gameObj.realHp + hurt;
						if(hp <= 0){
							hurtinfo.die =1;
							hp = 0;
						}else{
							hurtinfo.die =0;
						}
						ele.gameObj.realHp = hp;
						hurtinfo.curhp = hp;
						hurtinfo.hit = 1;
						arr.push(hurtinfo);
					}
				}
			}
			return arr;
		}
		
		protected function mouseUp(event:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		public function dispose():void{
			GlobalLayer.instance.getLayer("zoneCon").removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			GlobalLayer.instance.getLayer("zoneCon").removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			GlobalLayer.instance.getLayer("zoneCon").removeEventListener(MouseEvent.ROLL_OUT,mouseZoneOut);
			GlobalLayer.instance.getLayer("zoneCon").removeEventListener(MouseEvent.ROLL_OVER,mouseZoneIn);
			GlobalLayer.instance.getLayer("zoneCon").removeEventListener(MouseEvent.MOUSE_UP,zoneMouseUp);
			GlobalLayer.instance.root.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_skillcd = null;
			this._zone = null;
		}
	}
}