package com.mgame.view
{
	import com.core.Facade;
	import com.mgame.model.ModelName;
	import com.mgame.view.component.SkillItem;
	import com.mgame.view.popup.Alert;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:44:38
	 * 
	 */
	public class BattleScene extends BaseView
	{
		private var _zone:sctjZoneNew;
		private var _uiContainer:Object;
		private var _bloodbar:Sprite;
		private var _skillsContainer:Sprite;
		private var _skillItems:Dictionary;
		private var _itemArr:Array;
		private var _skillcd:Dictionary;
		private var _maxHp:int = 100;
		private var _maskRect:Rectangle;
		
		public function BattleScene(container:Object,uiContainer:Object)
		{
			super(container);
			_uiContainer = uiContainer;
			init();
			_skillcd = Facade.instance.getModel(ModelName.SKILL_CDS);
			if(!_skillcd)
			{
				_skillcd = new Dictionary();
				Facade.instance.setModel(ModelName.SKILL_CDS,_skillcd);
			}
		}
		
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.battle") as Class;
			this._view = new cls();
			_bloodbar = this._view.bloodbar;
			_skillsContainer = this._view.skills;
			_maskRect = new Rectangle(0,0,91,8);
			initEvent();
		}
		
		private function initEvent():void{
			this._view.backBtn.addEventListener(MouseEvent.CLICK,backHandler);
		}
		
		public function setGold(value:int):void{
			this._view.topright.goldtxt.text = value + "";
		}
		
		public function setHp(data:int):void{
			this._view.head.hptxt.text = data + "/" + _maxHp;
			_maskRect.width = 91 * (data / _maxHp);
			this._view.head.bloodbar.scrollRect = _maskRect;
		}
		
		/**
		 * 进入场景，初始化数据 
		 * @param skills
		 * @param data
		 * @param gold
		 * @param maplevel
		 */
		public function updateData(skills:Object,data:Object,gold:int,maplevel:int):void{
			this._view.topright.goldtxt.text = gold;
			this._view.topright.leveltxt.text = maplevel;
			_maxHp = data.maxHp;
			setHp(_maxHp);
			var item:SkillItem;
			while(_skillsContainer.numChildren > 0){
				_skillsContainer.removeChildAt(0);
			}
			if(_skillItems){
				for each (item in _skillItems) 
				{
					item.dispose();
				}
			}
			_skillItems = new Dictionary();
			_itemArr = new Array();
			var i:int = 0;
			var arr:Array = new Array();
			for (var key:String in skills) 
			{
				arr.push(int(key));
			}
			arr.sort();
			for (var j:int = 0; j < arr.length; j++) 
			{
				key = arr[j];
				var skill:Object = skills[key];
				item = new SkillItem(skill);
				this._skillsContainer.addChild(item);
				item.y = j * 60;
				_skillItems[skill.id] = item;
				_itemArr.push(skill.id);
			}
			
			//this._view.head.hptxt
		}
		
		private function backHandler(e:MouseEvent):void{
			Alert.show("提示","确定要放弃当前关卡吗？",["确定","取消"],backCallBack);
		}
		
		private function backCallBack(detail:int,args:Array = null):void{
			if(detail == 0){
				Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.GAME_OVER);
				//Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.LEVEL_SELECT);
			}
		}
		
		public function enterZone():void{
			if(!_zone){
				_zone = new sctjZoneNew();
			}
			_container.addChildAt(_zone,0);
			var id:int = Facade.instance.getModel(ModelName.CUR_MAPID);
			_zone.initZone(id);
		}
		
		public function end():void{
			if(this._zone)
				this._zone.end();
		}
		
		override public function show():void{
			if(_view)
				this._uiContainer.addChild(_view);
			_visible = true;
		}
		
		public function selectSkill(id:int):void{
			for each (var item:SkillItem in this._skillItems) 
			{
				if(item.id == id)
					item.selected = true;
				else
					item.selected = false;
			}
		}
		
		public function selectSkillByIndex(index:int):int{
			if(_itemArr){
				if(_itemArr[index] > 0){
					if(!isCd(_itemArr[index])){
						selectSkill(_itemArr[index]);
						return _itemArr[index];	
					}else{
						Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.NOTICE,"技能未冷却");
					}
				}
			}
			return 0;
		}
		
		public function isCd(skillid:int):Boolean{
			return getTimer() < this._skillcd[skillid];
		}
		
		public function skillCd(data:Array):void{
			var skillid:int = data[0];
			var sleeptime:int = data[1];
			if(_skillItems[skillid])
				_skillItems[skillid].startOwnCD(sleeptime);
		}
		
		/**
		 * 取消选中技能
		 */
		public function clearSelectSkill():void{
			var id:int = Facade.instance.getModel(ModelName.SELECT_SKILL);
			if(this._skillItems[id]){
				(this._skillItems[id] as SkillItem).selected = false;
			}
			Facade.instance.setModel(ModelName.SELECT_SKILL,0);
		}
		
		override public function hide():void{
			if(_view && _view.parent)
				this._uiContainer.removeChild(_view);
			if(_zone && _zone.parent){
				this._container.removeChild(_zone);
			}
			_visible = false;
		}
	}
}