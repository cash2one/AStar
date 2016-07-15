package com.mgame.view
{
	import com.core.Facade;
	import com.mgame.view.component.LevelComponent;
	
	import consts.CMDMain;
	import consts.ControlGroup;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import util.FilterSet;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午8:45:53
	 * 
	 */
	public class LevelSelect extends BaseView
	{
		private var _levels:Array;
		private var _lastSelect:LevelComponent;
		private var _curPage:int = 0;
		private var _totalPage:int = 0;
		private var _totalCount:int = 0;
		private static const PageCount:int = 12;
		private var _levelCfgs:Object;
		private var _pageLvs:Array;
		
		public function LevelSelect(container:Object)
		{
			super(container);
			init();
		}
		
		private function init():void{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.LevelSelect") as Class;
			this._view = new cls();
			initEvents();
		}
		
		/**
		 * 初始化关卡列表显示
		 * @param mylevel
		 * @param levelCfgs
		 * 
		 */
		public function initLevels(levelCfgs:Array):void{
			_levelCfgs = levelCfgs;
			_levels = new Array();
			for each (var cfg:Object in levelCfgs) 
			{
				var lv:LevelComponent = new LevelComponent(cfg);
				_levels.push(lv);
			}
			this._totalCount = _levels.length;
			this._totalPage = Math.ceil(_totalCount/PageCount);
			this.setPage(0);
			/*_levels = new Array();
			var bx:int = 100;
			var by:int = 80;
			var i:int = 0;
			for each (var cfg:Object in levelCfgs) 
			{
				var lv:LevelComponent = new LevelComponent(cfg);
				this._view.addChild(lv);
				lv.x = (i % 4) * 150 + bx;
				lv.y = int(i/4) * 130 + by;
				_levels[cfg.id] = lv;
				i++;
			}*/
		}
		
		public function changeLv(lv:int):void{
			for each (var comp:LevelComponent in _levels) 
			{
				if(comp.data.id > lv + 1)
					comp.enabled  = false;
				else
					comp.enabled  = true;
			}
		}
		
		public function select(id:int):void{
			var lv:LevelComponent = this._levels[id - 1];
			if(lv != _lastSelect && lv != null && lv.enabled) {
				lv.selected = true;
				if(_lastSelect){
					_lastSelect.selected = false;
				}
				_lastSelect = lv;
			}
		}
		
		private function initEvents():void{
			(this._view.backBtn as SimpleButton).addEventListener(MouseEvent.CLICK,backHandler);
			(this._view.enterBtn as SimpleButton).addEventListener(MouseEvent.CLICK,enterHandler);
			(this._view.tianfuBtn as SimpleButton).addEventListener(MouseEvent.CLICK,tianfuHandler);
			(this._view.left_btn as SimpleButton).addEventListener(MouseEvent.CLICK,leftPageHandler);
			(this._view.right_btn as SimpleButton).addEventListener(MouseEvent.CLICK,rightPageHandler);
		}
		
		private function leftPageHandler(e:MouseEvent):void{
			setPage(this._curPage - 1);
		}
		
		private function rightPageHandler(e:MouseEvent):void{
			setPage(this._curPage + 1);
		}
		
		private function setPage(page:int):void{
			if(page >= 0 && page < _totalPage){
				this._curPage = page;
				var j:int = 0;
				var bx:int = 100;
				var by:int = 80;
				var lv:LevelComponent;
				if(_pageLvs){
					for each (lv in _pageLvs) 
					{
						if(lv.parent){
							lv.parent.removeChild(lv);
						}
					}
				}
				_pageLvs = [];
				for (var i:int = _curPage * PageCount; i < (_curPage + 1 )* PageCount; i++) 
				{
					if(this._levels.length > i){
						lv = _levels[i];
						this._view.addChild(lv);
						_pageLvs[lv.data.id] = lv;
						lv.x = (j % 4) * 150 + bx;
						lv.y = int(j/4) * 130 + by;
						j++;
					}else{
						break;
					}
				}
			}
		}
		
		private function backHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.MAIN_MENU);
		}
		
		private function tianfuHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.TIANFU_VIEW);
		}
		
		/**
		 * 进入战斗 
		 * @param e
		 */
		private function enterHandler(e:MouseEvent):void{
			Facade.instance.sendNotification(ControlGroup.MAIN,CMDMain.ENTER_GAME);
		}
	}
}