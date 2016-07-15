package com.mgame.view.component
{
	import com.core.Facade;
	import com.mgame.model.ConfigData;
	import com.mgame.model.ModelName;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	import consts.SkillID;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import util.DrawUtils;
	import util.FilterSet;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-7 上午10:09:49
	 * 技能
	 */
	public class SkillItem extends Sprite
	{
		private var _view:Object;
		private var _skill:Object;
		private var _bitmap:Bitmap;
		private var _cfg:Object;
		private var _selected:Boolean = false;
		private var mIntervalID:uint = 0;
		/**
		 * cd扇形
		 */		
		private var mWedgeSprite:Sprite;
		
		/**
		 * cd扇形遮罩
		 */		
		private var mMaskSprite:Sprite;
		
		/**
		 * 冷却时间
		 */		
		private var mCDTime:Number = 0;
		
		/**
		 * 开始计算CD的时间
		 */		
		private var mStartCDTime:int = 0;
		
		/**
		 * 是否正在显示CD
		 */		
		private var mShowingCD:Boolean = false;
		
		private static const ICON_WIDTH:int = 40;
		private static const ICON_HEIGHT:int = 40;
		
		public function SkillItem(skill:Object)
		{
			super();
			this._skill = skill;
			init();
			//this.startOwnCD();
		}
		
		public function get id():int{
			if(_skill)
			return _skill.id;
			else
				return 0;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(value){
				this.filters = [FilterSet.lvSelectFilter];
			}else{
				this.filters = [];
			}
		}

		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.skillItem") as Class;
			this._view = new cls();
			this.addChild(_view as DisplayObject);
			_cfg = ConfigData.allCfgs[ConfigData.SKILL][_skill.id];
			while(this._view.skillicon.numChildren > 0){
				this._view.skillicon.removeChildAt(0);
			}
			this._bitmap = new Bitmap(Resource.getRes("png.skill" + _cfg.groupid) );
			this._view.skillicon.addChild(_bitmap);
			
			_bitmap.width = ICON_WIDTH;
			_bitmap.height = ICON_HEIGHT;
			this.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			if(_cfg.groupid == SkillID.HAN_BING_ZHANG)
				this._view.shortcut.text = "1";
			else if(_cfg.groupid == SkillID.BING_PAO_XIAO)
				this._view.shortcut.text = "2";
			else if(_cfg.groupid == SkillID.LIU_XING)
				this._view.shortcut.text = "3";
		}
		
		public function clickHandler(e:MouseEvent):void{
			if(!_selected){
				var _skillcd:Dictionary = Facade.instance.getModel(ModelName.SKILL_CDS);
				if(getTimer() < _skillcd[_skill.id]){
					Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.NOTICE,"技能未冷却");
					return ;
				}
				Facade.instance.sendNotification(ControlGroup.BATTLE_PROCESS,CMDMain.SELECT_SKILL,this._skill.id);
				Facade.instance.sendNotification(ControlGroup.BATTLE_SCENE,CMDMain.SELECT_SKILL,this._skill.id);
				Facade.instance.setModel(ModelName.SELECT_SKILL,this._skill.id);
			}else{
				Facade.instance.sendNotification(ControlGroup.BATTLE_PROCESS,CMDMain.CLEAR_SELECT_SKILL);
				this.selected = false;
			}//this.selected = !_selected;
		}
		
		/**
		 * 开始自己的CD时间
		 * 
		 */		
		public function startOwnCD(time:int):void
		{
			if (mShowingCD)
			{
				return;
			}
			mShowingCD = true;
			if (time > 0)
			{
				mCDTime = int(time);
			}
			startCD();
		}
		
		/**
		 * 开始CD
		 * 
		 */		
		private function startCD():void
		{
			mStartCDTime = getTimer();
			if (mIntervalID > 0)
			{
				clearInterval(mIntervalID);
				mIntervalID = 0;
			}
			mIntervalID = setInterval(cdProgress, 1000 / 30);
		}
		
		/**
		 * CD遮罩每帧执行
		 * @param event
		 * 
		 */		
		private function cdProgress():void
		{
			//创建CD扇形
			if (!mWedgeSprite)
			{
				mWedgeSprite = new Sprite();
			}
			mWedgeSprite.x =0 ;
			mWedgeSprite.y =0;
			mWedgeSprite.mouseEnabled = false;
			this._view.skillicon.addChild(mWedgeSprite);
			
			//创建CD扇形遮罩
			if (!mMaskSprite)
			{
				mMaskSprite = new Sprite();
				mMaskSprite.graphics.clear();
				mMaskSprite.graphics.beginFill(0, 1);
				mMaskSprite.graphics.drawRect(0, 0, ICON_WIDTH, ICON_HEIGHT);
				this._view.skillicon.addChild(mMaskSprite);
				mWedgeSprite.mask = mMaskSprite;
			}
			if(!mMaskSprite.visible)
				mMaskSprite.visible = true;
			var curtime:int = getTimer();
			var angle:Number = 360 * (curtime - mStartCDTime) / (mCDTime );
			
			//CD时间到后停止
			if (angle >= 360)
			{
				stopCD();
				return;
			}
			
			//开始画扇形
			mWedgeSprite.graphics.clear();
			mWedgeSprite.graphics.lineStyle(0, 0, 0);
			mWedgeSprite.graphics.beginFill(0, 0.5);
			DrawUtils.wedge(mWedgeSprite, ICON_WIDTH / 2, ICON_HEIGHT / 2, 90, 360 - angle, ICON_WIDTH, ICON_HEIGHT);
		}
		
		/**
		 * 停止CD
		 * 
		 */		
		public function stopCD():void
		{
			if (mIntervalID > 0)
			{
				clearInterval(mIntervalID);
				mIntervalID = 0;
			}
			mShowingCD = false;
			this.mCDTime = 0;
			if (mWedgeSprite)
			{
				if (mWedgeSprite.parent)
				{
					mWedgeSprite.parent.removeChild(mWedgeSprite);
				}
			}
			
			if(mMaskSprite)
				mMaskSprite.visible = false;
		}
		
		public function dispose():void{
			stopCD();
			if(mMaskSprite && mMaskSprite.parent){
				mMaskSprite.parent.removeChild(mMaskSprite);
			}
			mMaskSprite = null;
			if(_view){
				this.removeChild(_view as DisplayObject);
				_view = null;
			}
			this.selected = false;
			_cfg = null;
			if(_skill){
				_skill = null;
			}
		}
	}
}