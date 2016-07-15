package com.rpg.scene.map2
{
	import com.core.destroy.DestroyUtil;
	import com.core.destroy.IDestroy;
	import com.rpg.scene.SceneLayer;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class MapTiles implements IDestroy
	{
		/**
		 * 地图文件前缀 
		 */
		private var _rootName:String = "";
		private var _scale:Number = 1;
		/**
		 * 目录url
		 */
		private var _dirUrl:String = "";
		private var _tileWidth:int = 192;
		private var _tileHeight:int = 192;
		private var _mapEventId:uint;
		/**
		 * 地图块image
		 */
		private var _tileImgs:Dictionary;
		private var _container:SceneLayer;
		
		
		private var _border:int = 50;
		
		
		/**
		 * 整张地图总行数
		 */
		private var _row:int = 0;
		/**
		 * 整张地图总列数
		 */
		private var _col:int = 0;
		
		/**
		 *	当前地图行数
		 */
		private var _sRow:int = 0;
		/**
		 * 当前地图列数
		 */
		private var _sCol:int = 0;
		
		private var _refresh:Boolean = false;
		private var _width:int = 0;
		private var _height:int = 0;
		
		private var _screenX:int;
		private var _screenY:int;
		
		//public static var empty:BitmapData ;
		
		/**
		 *  刚切换场景
		 */
		public var changedMap:Boolean = true;
		
		private var cellEmpty:Shape = new Shape();
		
		private var _minimap:BitmapData;
		private var _maxid:int = 0;
		private var _totalWidth:int ;
		private var _totalHeight:int;
		/**
		 * 小地图是否绘制 了，防止重复绘制
		 */
		private var _miniDrawd:Boolean = false;
		/**
		 * 地图切片集合管理
		 */
		public function MapTiles(width:int,height:int,container:SceneLayer)
		{
			this._totalWidth = width;
			this._totalHeight = height;
			this._container = container;
		}
		
		public function drawMinimap(minimap:BitmapData):void
		{
			this._minimap = minimap;
			if(_minimap && !_miniDrawd) {
				var matrix : Matrix 		  = new Matrix();
				matrix.a 					  = this._totalWidth  / _minimap.width;
				matrix.d 					  = this._totalHeight / _minimap.height;
				_container.display.graphics.beginBitmapFill(_minimap, matrix, false, false);
				_container.display.graphics.drawRect(0, 0, this._totalWidth,this._totalHeight);
				_container.display.graphics.endFill();
				_miniDrawd = true;
			}
		}
		
		
		
		public function destroy():void{
			_minimap = null;
			this._container = null;
		}
	}
}