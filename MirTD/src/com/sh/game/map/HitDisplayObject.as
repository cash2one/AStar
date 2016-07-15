package com.sh.game.map
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class HitDisplayObject
	{
		public var bitmapData:BitmapData;
		
		public var node:TreeNode;
		
		public var id:int = 0;
		
		public var updated:Boolean = true;
		
		public var hited:Vector.<HitDisplayObject>;
		
		public var roleX:int = 0;
		public var roleY:int = 0;
		
		/**
		 * 是否执行遮挡
		 */
		public var call:Boolean = false;
		
		public function HitDisplayObject()
		{
			_viewRect = new Rectangle();
			hited = new Vector.<HitDisplayObject>();
		}
		
		public function addHited(zhn:HitDisplayObject):Boolean{
			if(hited.indexOf(zhn) < 0){
				hited.push(zhn);
				return true;
			}
			return false;
		}
		
		public function removeHited(hitedObj:HitDisplayObject):HitDisplayObject{
			var index:int = hited.indexOf(hitedObj);
			if(index >= 0){
				hited.splice(index,1);
				return hitedObj;
			}
			return null;
		}
		
		private var _viewRect:Rectangle;
		
		public function set viewRect(value:Rectangle):void
		{
			_viewRect = value;
		}

		/**
		 * 当前区域
		 */
		public function get viewRect():Rectangle
		{
			return _viewRect;
		}

		public function get x():int{
			return _viewRect.x;
		}
		
		public function get y():int{
			return _viewRect.y;
		}
		
		public function set x(value:int):void{
			this._viewRect.x = value;
		}
		
		public function set y(value:int):void{
			this._viewRect.y = value;
		}
		
		public function set width(value:int):void{
			this._viewRect.width = value;
		}
		
		public function set height(value:int):void{
			this._viewRect.height = value;
		}
	}
}