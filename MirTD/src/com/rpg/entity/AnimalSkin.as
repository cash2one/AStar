package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationEventArgs;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.entity.animation.AnimationPlayerDataSet;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.scene.SceneCacheManager;
	import com.sh.game.util.ModelName;
	
	import flash.display.Bitmap;
	
	
	
	/** 人物皮肤抽象类  */
	public class AnimalSkin extends ElementSkin
	{
		
		protected var _animal 			 : Animal;										// 人物元件
		protected var _actionQueue 		 : Array; 										// 连续动做队列
		
		protected var _defaultModel:String;											//默认模型id
		
		protected var _needSort:Boolean;
		protected var _needShadow:Boolean = true;
		
		protected var skinPath:String = "";
		
		/**
		 * 资源加载优先级 玩家自己为0 
		 */
		protected var _prority:int = 2;
		
		public function get animalId() : Number
		{
			return _animal.id;
		}
		
		/** 皮肤构造函数 */
		public function AnimalSkin(element : ElementBase)
		{
			super(element);
			_animal = element as Animal;
		}

		
		/**
		 * 第一个皮肤加载完成 
		 * 
		 */		
		protected function loadComplete(data : AnimationPlayerData) : void
		{
			if (this.skinVisible == false)
			{
				// 主皮肤可显示
				_skinVisible = true;
				if( this._dataList[ElementSkinType.SHADOW_OUT] != null)
					addAnimationClip(ElementSkinType.SHADOW_OUT);
				/*else if( this._dataList[ElementSkinType.SHADOW] != null)
					addAnimationClip(ElementSkinType.SHADOW);*/
				this.y 			   = 0;
				_animal.excursionY = data.maxHeight;
				_animal.setPosition();

				// 修正因动物皮肤高度改变时，自身特效的高度变化
				for each (var gc : GameComponent in _animal.components.source)
				{
					if (gc is Body)
					{
						Body(gc).visible = true;
						//Body(gc).setPosition();
					}
				}
				this.show();
			}
		}
		
		/**
		 * 显示出来后做的事
		 */
		protected function show():void
		{
			
		}
		
		/**
		 * 皮肤处理完成 
		 * @param skinType 皮肤类型
		 * @param data     皮肤动画数据
		 * 
		 */		
		protected function processComplete(skinType : String, data : AnimationPlayerData) : void
		{
			if(this._notDispose){
				if(data != null && this._dataList != null){
					if((skinType == ElementSkinType.SHADOW_OUT || skinType == ElementSkinType.SHADOW) && !_needShadow )
						return;
					var typeData : AnimationPlayerData = data;
					var curdata:AnimationPlayerData;
					var sortnow:Boolean = false;
					// 正在下载资源时，用户把资源数据切换了。防下载后显示不正确的资源皮肤
					var sets:AnimationPlayerDataSet = this.getDataSets(skinType);
					if(sets == null)
						return;
					var dataChange:Boolean = false;
					if(data.model == sets.model || data.isDefaultModel){
						curdata = sets.getData(data.action,data.dir);
						if(curdata == null || curdata.isDefaultModel){
							sets.addData(typeData.action,typeData.dir,typeData,typeData.isDefaultModel);
							dataChange = true;
						}
					}
					var bmp:Bitmap = this.getChildByName(skinType) as Bitmap;
					if (bmp == null)
					{
						this.addAnimationClip(skinType);
					}
					if(data.action != this._currentActionType || (!data.isDefaultModel && data.model != sets.model)){// 此处可能有问题
						return;
					}else if(data.isDefaultModel){
						if(data.dir != _currentDirection)
							return;
					}else if(data.dir != sets.getDir(_currentActionType,this._currentDirection)){
						return;
					}
					
					// 当有一件同样类型的装备在人物身上时，先删除之前的装备
					//var filters:Array = null;
					// 第一个皮肤加载完成
					if(skinType == ElementSkinType.MONSTER || skinType == ElementSkinType.NPC || skinType == ElementSkinType.CLOTHING_FOOT)
						this.loadComplete( data);
					if(!this.enabled)
						sortnow = true;
					// 当人物身体显示后，才显示其它装备
					if (skinVisible == false)
					{
						if (this.getChildByName(skinType))
						{
							this.getChildByName(skinType).visible = false;
						}
						
					}
					else
					{
						for each (var bitmap : Bitmap in _animation)
						{
							bitmap.visible = true;
						}
						this.enabled = true;
						
					}
					if(sortnow){
						if (this.enabled){
							this.setSkinIndex();
							this.play(_currentActionType,_currentDirection,false); // 经验：考虑是否每次调用些方些要运行play方法
						}
					}else{
						_needSort = true;
						//this.setSkinIndex();
						if (this.enabled)
							addAnimToView(skinType,_currentActionType,_currentDirection);
					}
					// 设置皮肤深度
					
					//this.setSkinIndex();
					// 添加皮肤引用计数
				}else{
					//trace("没有资源");
				}
			}else{
				//trace("....");
			}
		}
		
		public override function update(gameTime:GameTime):void{
			super.update(gameTime);
			if(enabled && this._needSort){
				this.setSkinIndex();
				this.play(_currentActionType,_currentDirection,false); // 经验：考虑是否每次调用些方些要运行play方法
				this._needSort = false;
			}
		}
		
		/** 设置皮肤的层次**/
		protected function setSkinIndex() : void 
		{
			
			// 人物影子深度效验
			var index : int = -1;
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

		protected override function loadContent():void
		{
			this.enabled = false;		// skinVisible为 true 时才开始逻辑更新
		}

		/**
		 * 添加一个皮肤类型
		 * @param skinType	皮肤类型
		 * @param callback  皮肤显示回调函数
		 *
		 */
		public function addType(skinType : String, callback : Function, skinPath : String, model:String = null,defaultCfg:Object = null) : void
		{
			this._dataList[skinType] = new AnimationPlayerDataSet(skinType,callback,model,defaultCfg,skinPath);
		}

		
		/**
		 * 显示或隐藏皮肤可视状态 
		 * @param skinType 皮肤类型（值为null时为移出所有皮肤）
		 * @param isShow   是否可视（true为可视）
		 * 
		 */		
		public function showOrHideSkin(skinType : String, isShow : Boolean) : void
		{
			switch (skinType)
			{
				case null:
					for (var key : String in this._dataList)
					{
						_dataList[key].visible = isShow;
					}
					break;
				default:
					_dataList[skinType].visible = isShow;
					break
			}
		}

		/**
		 * 修改动做
		 * @param actionType  动做类型
		 * @param isForce  	     是否强制改变动做
		 */
		public function setAction(compulsory : Boolean = false) : void
		{
			// 此处定义人物方向和美术图布局有关
			if (_currentActionType != _animal.action || _currentDirection != _animal.direction || compulsory)
			{
				_currentActionType = _animal.action;
				_currentDirection  = _animal.direction;
				showAction();
			}
		}

		/** 显示动作  */		
		protected function showAction() : void
		{
			this.play(_currentActionType ,_currentDirection);
		}
		
		/**
		 * 人物动做动画播放完成
		 * 
		 */		
		protected override function playComplete(e : AnimationEventArgs) : void
		{
			if (_actionQueue && _actionQueue.length > 0)
			{
				_animal.setAction(_actionQueue.shift(), -1, true);
			}
			else
			{
				// 攻击动做完成时，切换人物行为为休闲状态
				if (_animal.action == ActionType.ATTACK ||
					_animal.action == ActionType.ATTACK_SPECIAL||
					_animal.action == ActionType.HURT )
				{
					_animal.setAction(ActionType.STAND);
				}else if(_animal.action == ActionType.DIE){
					
				}
			}
		}
		
		/**
		 * 设置连续动做 
		 * @param actions 动做对列
		 * 
		 */		
		public function setContinuousAction(actionQueue : Array) : void
		{
			_actionQueue = actionQueue;
			_animal.setAction(_actionQueue.shift(), -1,true);
		}
		
		protected function getShadowCache():CacheCollection{
			return SceneCacheManager.instance.shadowSkin;
		}
		
		public function preLoadSkin(skinType:String,action:int,dir:int):void{
			if(skinType == ElementSkinType.SHADOW)
				return;
			var skinTypeData : AnimationPlayerDataSet = this._dataList[skinType];
			var shadowsets:AnimationPlayerDataSet;
			if (skinTypeData && skinTypeData.enabled)
			{
				//trace("加载资源" + skinType +  " :" + skinTypeData.model + "action:" +action+ " dir:"+dir);
				var o:Object =  this.getCacheData(skinType);
				var cache : * = o != null?o.getData(ModelName.getSource(skinTypeData.model , action , dir)):null;
				if (!cache)
				{
					if(skinTypeData.model){
						shadowsets = this._dataList[ElementSkinType.SHADOW];
						if(needShadow(skinType) || shadowsets==null)
						{
							ActionLoader.instance.load(skinTypeData.skinPath,null,skinTypeData.model,skinType,action,dir,true,_prority,skinTypeData.id);
						}else{
							ActionLoader.instance.load(skinTypeData.skinPath,null,skinTypeData.model,skinType,action,dir,true,_prority,skinTypeData.id,nullFunc);
						}
					}else{
					}
				}
			}
		}
		
		private function nullFunc(arg:*):void
		{
			
		}
		
		override protected function loadSkin(skinType:String,action:int,dir:int):void
		{
			if(skinType == ElementSkinType.SHADOW)
				return;
			var skinTypeData : AnimationPlayerDataSet = this._dataList[skinType];
			var shadowsets:AnimationPlayerDataSet;
			if (skinTypeData && skinTypeData.enabled)
			{
				//trace("加载资源" + skinType +  " :" + skinTypeData.model + "action:" +action+ " dir:"+dir);
				var o:Object;
				if(skinType == ElementSkinType.SHADOW || skinType == ElementSkinType.SHADOW_OUT)  //影子绘制
					o =  this.getShadowCache();
				else
					o =  this.getCacheData(skinType);
				var cache : * = o != null?o.getData(ModelName.getSource(skinTypeData.model , action, dir)):null;
 				if (cache)
				{
					skinTypeData.callback(cache);
					// 皮肤添加事件
					//SceneCacheManager.instance.addReference(skinType,cache.fileName);
				}
				else
				{
					if(skinTypeData.model){
						if(skinType == ElementSkinType.SHADOW_OUT)
						{
							useDefalutShadow();
							ActionLoader.instance.load(skinTypeData.skinPath,skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,1,skinTypeData.id);
							return;
						}else if(skinType == ElementSkinType.SHADOW){
							//useDefalutShadow();
							return;
						}else
							this.useDefault(skinType,this._defaultModel,action,this._currentDirection,skinTypeData.callback);
						shadowsets = this._dataList[ElementSkinType.SHADOW]; //影子绘制
						if(needShadow(skinType) || shadowsets==null)
						{
							ActionLoader.instance.load(skinTypeData.skinPath,skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,1,skinTypeData.id);
						}else{ //影子绘制
							//useDefalutShadow();
							ActionLoader.instance.load(skinTypeData.skinPath,skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,0,skinTypeData.id,shadowsets.callback);
						}
					}else{
						//trace("试图加载资源但是没有model : " + skinType + "   " + "action:" +action+ " dir:"+dir);
					}
				}
			}
		}
		
		public function useDefalutShadow():void{
			if(this._animation[ElementSkinType.SHADOW_OUT]){
				this._animation[ElementSkinType.SHADOW_OUT].bitmapData = null;//RoleEmbed.getBitmapdata("png.zone.shadow");
				this._animation[ElementSkinType.SHADOW_OUT].x = -this._animation[ElementSkinType.SHADOW_OUT].width/2;
				this._animation[ElementSkinType.SHADOW_OUT].y = -this._animation[ElementSkinType.SHADOW_OUT].height/2;
			}/*else if(this._animation[ElementSkinType.SHADOW]){
				this._animation[ElementSkinType.SHADOW].bitmapData = RoleEmbed.getBitmapdata("png.zone.shadow");
				this._animation[ElementSkinType.SHADOW].x = -this._animation[ElementSkinType.SHADOW].width/2;
				this._animation[ElementSkinType.SHADOW].y = -this._animation[ElementSkinType.SHADOW].height/2;
			}*/
		}
		
		protected function needShadow(skinType:String):Boolean{
			return skinType !=ElementSkinType.NPC&&skinType !=ElementSkinType.MONSTER;
			//return skinType !=ElementSkinType.NPC&&skinType !=ElementSkinType.MONSTER&&skinType !=ElementSkinType.CLOTHING_FOOT;
		}
		
		private function useDefault(skinType:String,model:String,action:int,dir:int,callBack:Function):void
		{
			/*if(model != null){
				if(callBack != null && (skinType == ElementSkinType.MONSTER || skinType == ElementSkinType.NPC  || skinType == ElementSkinType.CLOTHING_FOOT)){
					var o:Object = this.getDefaultData();
					var cache : * = o != null?o.getData(model + "_" + action + "_" + dir):null;
					if (cache)
					{
						callBack(cache);
						return;
					}
				}
			}*/
			if(this._animation[skinType] && action != ActionType.HURT)
				this._animation[skinType].bitmapData = null;
		}
		
		public override function dispose() : void
		{
			for (var key : String in _dataList)
			{
				this.removeType(key);
			}
			
			/*_skinTypeData.dispose();
			_skinTypeData    = null;*/
			_animal          = null;
			super.dispose();
		}
	}
}