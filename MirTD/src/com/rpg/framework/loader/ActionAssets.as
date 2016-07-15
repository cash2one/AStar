package com.rpg.framework.loader
{
	import com.rpg.enum.Constant;
	import com.rpg.pool.IPoolItem;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	public class ActionAssets implements IPoolItem
	{
		public function ActionAssets()
		{
			
		}
		
		public function init(data:Object,res:Object,name:int,type:String):void{
			this._name = name;
			this.type = type;
			this.data = data;
			this.res = res;
		}
		
		public function reset():void{
			this.clear();
		}
		
		public function dispose():void{
			this.clear();
		}
		
		public function get name():int
		{
			return _name;
		}
		
		public var type:String;
		private var _name:int;
		public var data:Object;
		public var res:Object;
		
		/**
		 * 获取类定义
		 * @return
		 */
		public function getClass(className :int) :BitmapData
		{
			var bytes:ByteArray = this.res[className];
			bytes.position = 0;
			var frame:Object = this.data[className];
			var rect:Rectangle = new Rectangle(0,0,frame.w,frame.h);
			var bmp:BitmapData = new BitmapData(frame.w,frame.h,true,0);
			bmp.setPixels(rect,bytes);
			return bmp;
		}
		
		public function get isNull():Boolean{
			return data == null;
		}
		
		
		public function clear():void{
			data = null;
			res = null;
			_name = 0;
			type = null;
		}
	}
}

