package com.rpg.entity
{
	
	import com.sh.game.consts.DirectionType;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	

	/** 游戏场景中的元件抽象类。所有游戏场景中的元件都必须继承此类 */
	public class ElementBase extends GameSprite
	{
		/** 属性倍率 */
		public static const RATE_BASE : int           = 1000;

		/** 元件唯一编号 */
		public var id : Number                        = -1;
		/** 元件类型 */
		public var type : int                         = -1;
		/** 元件所属场景层 */
		public var layer : int;
		/** 元件 中心坐标 */
		public var centerPoint : Point;
		/** 游戏中人物偏移X坐标 */
		public var excursionX : int;
		/** 游戏中人物偏移Y坐标 */
		public var excursionY : int;
		/** 人物方向 */
		public var direction : int                    = DirectionType.DOWN;

		protected var _skin : ElementSkin; // 元件皮肤组件
		protected var _values : Dictionary; // 对象属性值集合
		protected var _isDisposed : Boolean             = false;

		public override function addChild(item : GameSprite) : void
		{
			if(item is ElementSkin){
				var skin : ElementSkin = item as ElementSkin;
				skin.inView = true;
			}
			super.addChild(item);
		}
		
		public override function removeChild(item : GameSprite) : void
		{
			if(item is ElementSkin){
				var skin : ElementSkin = item as ElementSkin;
				skin.inView = false;
			}
			super.removeChild(item);
		}
		
		public function get inView():Boolean{
			return this._skin.inView;
		}
		
		/**
		 * 对象属性值集合
		 *
		 */
		public function getValue(key : int) : *
		{
			if (_isDisposed == false)
			{
				return _values[key];
			}
			return null;
		}

		public function setValue(key : int, value : *, local : Boolean = true) : void
		{
			if (local) // 本地设置属性数据
			{
				_values[key] = value;
			}
//			else if (value is int || value is Number)		// 数据类型为数字
//			{
//				_values[key] = value / RATE_BASE;
//			}
			else // 数据类型为非数字
			{
				_values[key] = value;
			}
		}

		public function ElementBase()
		{
			_values = new Dictionary();
			this.centerPoint = new Point();

			/** 创建对象组件 */
			this.createComponent();
		}

		/** 创建对象组件 */
		protected function createComponent() : void
		{
		}

		/** 设置元件位置 */
		public function setPosition() : void
		{
			/*var p : Point = Tile.getTilePointToStage(this.tilePoint.x, this.tilePoint.y);
			this.originX = p.x;
			this.originY = p.y;*/
		}

		public override function initialize() : void
		{
			this.setPosition();
			super.initialize();
		}

		public override function dispose() : void
		{
			_isDisposed = true;
			_values = null;
			this.centerPoint = null;
			if(this._skin){
				if(_skin.parent)
					_skin.parent.removeChild(_skin);
				this._skin.dispose();
				_skin = null;
			}
			super.dispose();
		}

		/**
		 * 鼠标选中验证
		 *
		 */
		public function selectVerify(x:int,y:int) : Boolean
		{
			return _skin.selectVerify(x,y);
		}


		/** 元件深度 */
		public function get depth() : Number
		{
			return this.display.y;
		}

		/** 元件 X 轴注册点*/
		public function get originX() : Number
		{
			return this.display.x + excursionX;
		}

		public function set originX(value : Number) : void
		{
			this.display.x = value - excursionX;
		}


		/** 元件中心击打 */
		public function get hitPoint() : Point
		{
			if(_skin){
				centerPoint.x = _skin.display.width >> 1;
				centerPoint.y = -70;// excursionY >> 1;
			}
			return centerPoint;
		}

		//--------------- 元件层分类  ---------------
		public static const LAYER_SMAPBG :int        = 0;
		public static const LAYER_MAPBG :int        = 1;
		public static const LAYER_ROLE :int        = 2;
		public static const LAYER_SHADOW :int        = 3;
		public static const LAYER_NAME :int        = 4;
		public static const LAYER_DROP :int        = 5;
		public static const LAYER_SKILL :int        = 6;
		public static const LAYER_SKILL2 :int        = 7;
		public static const LAYER_EFFECT :int        = 8;
		public static const LAYER_EFFECT2 :int        = 9;
	}
}
