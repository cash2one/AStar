package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationFrame;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.framework.system.memory.CacheCollection;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	
	
	/** 人物皮肤抽象类  */
	public class ElementSkin extends AnimationPlayer
	{
		protected var _selectEnabled : Boolean = true;			// 是否可以选中人物 
		protected var _effectEnabled : Boolean = true;			// 是否有人物选择特效
		protected var _skinVisible   : Boolean = false; 		// 人物身体是否加载完成
		
		private var _element	   : ElementBase;				// 父级场景元件
		private var _isCanSelect   : Boolean = false; 			// 是否能选中人物皮肤状态（是为了在选中人物皮肤后，不要在次验让皮像素而影响性能）
		protected var _notDispose	   : Boolean = true; 			// 是否已释放
		
		private static var SELECT_ELEMENT : ElementBase;		// 当前选中的元件

		/**
		 * 是否已释放对象 
		 * @return true为已释放
		 * 
		 */		
		public function get notDispose() : Boolean
		{
			return _notDispose;
		}
		
		/** 皮肤构造函数 */
		public function ElementSkin(element : ElementBase)
		{
			_element = element;
			//_element.addChild(this);
		}
		
		public function setSkin(skinType : String,model:String,path:String):void{
			
		}
		
		public override function initialize():void
		{
			this.display.mouseEnabled = true;
			
			super.initialize();
		}

		public override function dispose() : void
		{
			
			// 释放元件时，如果先中元件和释放元件是同一个，则清空选择元件。
			if (SELECT_ELEMENT)
			{
				if (SELECT_ELEMENT.id == _element.id)
				{
					SELECT_ELEMENT = null;
				}
			}
			if(_notDispose)
				super.dispose();
			_notDispose  = false;
			_skinVisible = false;
			_element     = null;
			
		}
		
		/**
		 * 选中验证 
		 * 
		 */		
		public function selectVerify(x:int,y:int) : Boolean
		{
			
			var isHighlight : Boolean = false;
			var piexl : uint;
			var alpha : uint;
			for (var clipType : String in _animation)
			{
				var data : AnimationPlayerData =getData(clipType,this._currentActionType,this._currentDirection);
				if (data != null && data.select || _skinVisible == false)
				{
					var bitmap : Bitmap = _animation[clipType];
					// 注:有可能有的资源在内存中存在，不过加载流程是先加载地图、衣服、武器、武器特效等顺序。
					//    这时有可能this.animation[clipType]项存在，不过帧数据还没有赋值。为此加以判断
					if (bitmap.bitmapData != null)
					{
						var bx : int;
						var by : int = y - bitmap.y;
						if (bitmap.scaleX == -1)
						{
							bx = -x + bitmap.x;
							if(0 < bx && bitmap.y < y && bitmap.width > bx && bitmap.y + bitmap.height > y)
							{
								piexl = bitmap.bitmapData.getPixel32(bx, by);
								alpha = piexl >> 24 & 0xFF;
								if (piexl != 0)
								{
									//this.addHighlight();		// 添加提示效果
									isHighlight = true;
									break;
								}
							}
						}
						else
						{
							bx = x - bitmap.x;
							if(bitmap.x < x && bitmap.y < y && bitmap.x + bitmap.width > x && bitmap.y + bitmap.height > y)
							{
								piexl = bitmap.bitmapData.getPixel32(bx, by);
								alpha = piexl >> 24 & 0xFF;
								if (piexl != 0)
								{
									//this.addHighlight();		// 添加提示效果
									isHighlight = true;
									break;
								}
							}
						}
						
					}
				}
			}
			return isHighlight;
		}

		
		/**
		 * 获取缓存类型加
		 * @param skinType 皮肤类型
		 * @return 皮肤缓存集合
		 * 
		 */		
		protected function getCacheData(skinType : String = null) : CacheCollection
		{
			return null;
		}
		/**
		 * 获取缓存类型加
		 * @param skinType 皮肤类型
		 * @return 皮肤缓存集合
		 * 
		 */		
		protected function getDefaultData() : CacheCollection
		{
			return null;
		}
		
		override public function get enabled():Boolean{
			return this.inView && this._enabled;
		}
		
		/**
		 * 皮肤是否已可见 
		 * 
		 */		
		public function get skinVisible() : Boolean
		{
			return _skinVisible;
		}
	}
}