package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationEventArgs;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.entity.animation.AnimationPlayerDataSet;
	import com.rpg.entity.animation.BodySkinDataSet;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.scene.SceneCacheManager;
	import com.sh.game.util.ModelName;
	
	import flash.display.Bitmap;
	
	
	
	/** 物体、技能皮肤抽象类  */
	public class BodySkin extends ElementSkin
	{
		
		protected var _body 			 :Body;										// 人物元件

		public function get animalId() : Number
		{
			return _body.id;
		}
		
		/** 皮肤构造函数 */
		public function BodySkin(element : ElementBase)
		{
			super(element);
			_body = element as  Body;

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
				
				this.y 			   = data.maxHeight;
				_body.excursionY = data.maxHeight;
				_body.setPosition();
			}
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
				if(data != null && data.clip != null){
					var typeData : AnimationPlayerData = data;
					
					// 正在下载资源时，用户把资源数据切换了。防下载后显示不正确的资源皮肤
					var sets:AnimationPlayerDataSet = this.getDataSets(skinType);
					if(!sets || data.model != sets.model || data.action != this._currentActionType){
						return;
					}
					
					// 当有一件同样类型的装备在人物身上时，先删除之前的装备
//					if (this.getChildByName(skinType) != null && typeData != null)
//					{
//						//this.removeSkin(skinType);
//						this.deleteAnimationClip(skinType);
//					}
//					
//					// 皮肤数据添加到显示对列中显示
//					this.addAnimationClip( skinType);
					var curdata:AnimationPlayerData = sets.getData(data.action,data.dir);
					if(curdata == null )
					{
						sets.addData(typeData.action,typeData.dir,typeData);
					}
					var bmp:Bitmap = this.getChildByName(skinType) as Bitmap;
					if (bmp == null)
					{
						this.addAnimationClip(skinType);
					}
				
					
					// 第一个皮肤加载完成 
					this.loadComplete( data);
					
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
					
					// 设置皮肤深度
					this.setSkinIndex();
					//SceneCacheManager.instance.addReference(skinType,typeData.fileName);
				}
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
						/*Logger.error(this, 
							"setSkinIndex", 
							_animal + "_" + _animal.type + "_" + _animal.id);*/
					}
				}
			}
			if (this.enabled)
				this.play(_currentActionType,_currentDirection,false); // 经验：考虑是否每次调用些方些要运行play方法
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
		public function addType(skinType : String, callback : Function, skinPath : String, model:String,defaultCfg:Object) : void
		{
			this._dataList[skinType] = new BodySkinDataSet(skinType,callback,model,defaultCfg);
		}

		/**
		 * 删除皮肤
		 * @param skinType 皮肤类型（值为null时为移出所有皮肤）
		 *
		 */
		protected function removeSkin(skinType : String, isDispose : Boolean = false) : void
		{
			this.removeType(skinType);
			if (isDispose)
			{
			}
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
				/*case null:
					for (var key : String in this._dataList)
					{
						_dataList[key].visible = isShow;
					}
					break;
				default:
					_dataList[skinType].visible = isShow;
					break*/
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
			if (_currentActionType != _body.action || _currentDirection != _body.direction || compulsory)
			{
				_currentActionType = _body.action;
				_currentDirection  = _body.direction;
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
			
		}
		
		
		override protected function loadSkin(skinType:String,action:int,dir:int):void
		{
			var skinTypeData : AnimationPlayerDataSet = this._dataList[skinType];
			
			if (skinTypeData && skinTypeData.enabled)
			{
				var o:Object = this.getCacheData(skinType);
				var cache : * = o != null?this.getCacheData(skinType).getData(ModelName.getSource(skinTypeData.model ,action,dir)):null;
				if (cache)
				{
					skinTypeData.callback(cache);
					
					// 皮肤添加事件
					//SceneCacheManager.instance.addReference(skinType,cache.fileName);
				}
				else
				{
					ActionLoader.instance.load("",skinTypeData.callback,skinTypeData.model,skinType,action,dir,true,0,skinTypeData.id);
				}
			}
		}
		
		public override function dispose() : void
		{
			for (var key : String in _dataList)
			{
				this.removeSkin(key, true);
			}
			
			/*_skinTypeData.dispose();
			_skinTypeData    = null;*/
			super.dispose();
		}
	}
}