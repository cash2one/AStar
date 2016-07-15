package com.rpg.scene.actor.skin
{
	
	import com.rpg.entity.AnimalSkin;
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.animation.AnimationMovieClip;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.ITweenRender;
	import com.rpg.framework.system.timer.RendersManager;
	import com.rpg.scene.actor.RPGAnimal;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.filters.BitmapFilter;
	
	import util.FilterSet;
	
	public class RPGAnimalSkin extends AnimalSkin implements ITweenRender
	{
		public var mask:Boolean;
		public var lockAction:Boolean;
		private var undisposed:Boolean = true;
		protected var _focus_1:AnimationMovieClip;//己方脚下光圈
		protected var _focus_2:AnimationMovieClip;//敌方脚下光圈
		private var _curAlpha:Number = 1;
		//private var _tween:TweenLite;
		public var hiding:Boolean = false;
		public var showing:Boolean = false;
		protected var _mouseFilter:BitmapFilter;
		protected var _shadow:Bitmap;
		/**
		 * 修改模型
		 * @param model
		 */		
		public function changeModel(model:String):void
		{
			
		}
		
		public function RPGAnimalSkin(element:ElementBase)
		{
			super(element);
		}
		
		public function set mouseFilter(value:BitmapFilter):void
		{
			_mouseFilter = value;
		}

		public function set playEnd(value:Boolean):void{
			this._playEnd = value;
		}
		
		/**
		 *	选中 
		 * @param i
		 * 
		 */
		public function setFocus(i:int,type:int = 0):void
		{
			if(i == 1){
			}else if(i == 2){
				if(!this._focus_2){
					/*_focus_2 = new AnimationMovieClip(RoleEmbed.getFocus2(),75,50,100);
					this._animal.components.add(_focus_2);
					if(type == 0)
						_focus_2.display.filters = [FilterSet.greenFocusFilter];
					_focus_2.display.blendMode = BlendMode.ADD;
					if(!_shadow)
						this.addChildAt(_focus_2,0);
					else
						this.addChildAt(_focus_2,1);*/
				}
			}else{
				if(this._focus_2){
					this._animal.components.remove(_focus_2);
					_focus_2 = null;
				}
			}
		}
		
		
		
	 	/** 设置皮肤的层次**/
		override protected function setSkinIndex() : void 
		{
			
			// 人物影子深度效验
			var index : int = 0;
			if(_shadow){
				index++;
			}
			if ((_focus_2 && this.contains(_focus_2)) || (_focus_1 && this.contains(_focus_1)))
			{
				index++;
			}
			// 人物皮肤深度效验
			for (var key : String in this._dataList)
			{
				if (this.getChildByName(key))
				{
					try
					{
						this.setChildByIndex(key, ++index);
					}
					catch (e : Error)
					{
						this.setChildByIndex(key, --index);
					}
				}
			}
		}
		
		public var filtersData:Array = [0,0,0,0,0,0]; 
		
		public function clearFilter(type:int):void{
			filtersData[type] = 0;
			updateFilter();
		}
		
		/**
		 * 修改动作
		 * @param actionType  动作类型
		 * @param isForce  	     是否强制改变动作
		 */
		override public function setAction(compulsory : Boolean = false) : void
		{
			// 此处定义人物方向和美术图布局有关
			if (_currentActionType != _animal.action || _currentDirection != _animal.direction || compulsory)
			{
				_currentActionType = _animal.action;
				_currentDirection  = _animal.direction;
				
				if(this._enabled)
					this.setSkinIndex();
				showAction();
			}
		}
		
		/**
		 * 0：鼠标经过
		 * 1：麻痹
		 * 2：中毒
		 * 3 : 冰冻
		 * 4：灼烧
		 * 5 ：特殊发光
		 */
		public function addFilter(type:int):void{
			filtersData[type] = 1;
			updateFilter();
		}
		
		protected var _allFilters:Array;
		
		public function updateFilter():void{
			var i:int = filtersData.length - 1;
			if(!_allFilters)
				_allFilters = [];
			_allFilters.length = 0;
			if(filtersData[0] == 1){
				if(_mouseFilter)
					_allFilters.push(_mouseFilter);
			}else if(filtersData[5] == 1){
				_allFilters.push(FilterSet.chengzhuFilter);
			}
			while(i >= 1){
				if(filtersData[i] == 1){
					var type:int = i; 
						if(type == 1){
							_allFilters.push(FilterSet.GrayFilter);
						}else if(type == 2){
							_allFilters.push(FilterSet.greenFilter);
						}else if(type == 3){
							_allFilters.push(FilterSet.blueFilter);
						}else if(type == 4){
							_allFilters.push(FilterSet.redFilter);
						}
						break;
				}
				i--;
			}
			for (var clipType : String in _animation)
			{
				if(clipType == ElementSkinType.SHADOW_OUT || clipType == ElementSkinType.SHADOW)
					continue;
				var data:AnimationPlayerData = this.getData(clipType,this._currentActionType,this._currentDirection);
				if (data == null || data.select)
				{
					_animation[clipType].filters =_allFilters;
				}
			}
		}
		
		override public function addAnimationClip(clipType:String):void{
			super.addAnimationClip(clipType);
			if(clipType == ElementSkinType.SHADOW_OUT || clipType == ElementSkinType.SHADOW)
				return;
			_animation[clipType].filters =_allFilters;
		}
		
		 /**
		* 显示出来后做的事，渐变显示
		*/
		override protected function show():void
		{
			/*if(this.inView && !hiding ){
				tweenShow();
			}*/
		}
		
		
		public override function dispose() : void
		{
			if(undisposed){
				RendersManager.instance.removeCompnent(this);
				this._endDispose= false;
				this.removeCommonShadow();
				if(this._focus_1){
					if(this._animal.components)
						this._animal.components.remove(_focus_1);
					//this.removeChild(_focus_1);
					_focus_1 = null;
				}
				if(this._focus_2){
					if(this._animal.components)
						this._animal.components.remove(_focus_2);
					//this.removeChild(_focus_2);
					_focus_2 = null;
				}
				/*if(_tween){
					_tween.kill();
					_tween = null;
				}*/
				_mouseFilter = null;
				this.filtersData = null;
				mask = false;
				this._animal = null;
				super.dispose();
				_curAlpha = 0;
				undisposed = false;
			}
		}
		
		public function set alpha(value:Number):void{
			if(!this.showing && !this.hiding){
				display.alpha = value;
			}
			_curAlpha = value;
		}
		
		/**
		 * 缓动显示
		 */
		public function tweenShow():void{
			var curalpha:Number = _curAlpha;
			this.display.alpha = 0;
			/*if(_tween){
				_tween.complete();
				_tween = null;
			}*/
			var flag:Boolean = false;
			if(this.showing || this.hiding){
				completeFunc();
				flag = true;
			}
			if(this._animal && this._animal.enabled){
				this.hiding = false;
				showing = true;
				RendersManager.instance.addCompnent(this);
				//_tween = TweenLite.to(display,0.6,{alpha:curalpha,onComplete:completeFunc,onCompleteParams:[null,null]});		
			}else if(flag){
				RendersManager.instance.removeCompnent(this);
			}
		}
		
		private var _endDispose:Boolean = false;
		/**
		 * 缓动隐藏
		 */
		public function tweenHide(endDispose:Boolean):void{
			_curAlpha = 0;
			if(_endDispose == false)
				_endDispose = endDispose;
			/*if(_tween){
				_tween.complete();
				_tween = null;
			}*/
			var flag:Boolean = false;
			if(this.showing || this.hiding){
				completeFunc();
				flag = true;
			}
			if(this._animal && this._animal.enabled){
				this.hiding = true;
				this.showing = false;
				RendersManager.instance.addCompnent(this);
				//_tween = TweenLite.to(display,1,{alpha:0,onComplete:completeFunc,onCompleteParams:[endFunc,args]});
			}else if(flag){
				RendersManager.instance.removeCompnent(this);
			}
		}
		
		public function render(gameTime:GameTime):Boolean{
			if(hiding){
				if(this.display){
					this.display.alpha -= 0.1;
					if(this.display.alpha <= 0){
						this.display.alpha = 0;
						completeFunc();
						return true;
					}
				}
			}else if(showing){
				if(this.display){
					this.display.alpha += 0.1;
					if(this.display.alpha >= 1){
						this.display.alpha = 1;
						completeFunc();
						return true;
					}
				}
			}else 
				return true;
			return false;
		}
		
		private function completeFunc():void{
			/*if(_tween){
				_tween = null;
			}*/
			this.display.alpha = this._curAlpha;
			if(hiding){
				if(this._animal){
					if(_endDispose)
						(this._animal as RPGAnimal).removeByParent();
					else
						(this._animal as RPGAnimal).removeRole(false,_endDispose);
				}
			}
			this.hiding = false;
			this.showing = false;
			//_endDispose = false;
			/*if(endFunc != null && args!= null){
				endFunc.apply(null,args);
			}*/
		}
		
		public function addCommonShadow():void{
			if(_shadow == null){
				_shadow = new Bitmap(Resource.getRes("png.shadow"));
				this.display.addChildAt(_shadow,0);
				_shadow.x = -_shadow.width/2;
				_shadow.y = -_shadow.height/2;
			}
		}
		
		public function removeCommonShadow():void{
			if(this._shadow != null){
				this._shadow.parent.removeChild(_shadow);
				this._shadow = null;
			}
		}
			
	}
}