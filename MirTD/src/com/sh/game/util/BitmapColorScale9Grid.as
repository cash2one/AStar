package com.sh.game.util
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapColorScale9Grid
	{
		
		private var _bitmapdata:BitmapData;
		private var _scale9Grid:Rectangle;

		private var _bwidth:int = 0;
		private var _bhight:int = 0;
		private var _width:int;
		private var _height:int;
		private var _x:int=0;
		private var _y:int=0;
		private var _curbitmapdata:BitmapData;
		private var _color:uint;
		private var _otherbmd:BitmapData;
			
		public function BitmapColorScale9Grid(bitmapData:BitmapData,scale9Grid:Rectangle=null,color:uint = 0xffffff)
		{
			
			this._bitmapdata=bitmapData;
			this._scale9Grid=scale9Grid
			this._x=scale9Grid.x;
			this._y=scale9Grid.y;
			this._width=scale9Grid.width;
			this._height=scale9Grid.height;
			this._color = color;
			updataCutRectangle()        

		}
		public function set rect(value:Rectangle):void
		{
			this._x=value.x;
			this._y=value.y;
			this._width=value.width;
			this._height=value.height
			updataCutRectangle()        
		}
		public function set x(value:int):void
		{
			this._x=value;
			this.updataCutRectangle()
		}
		public function set y(value:int):void
		{
			this._y=value;
			this.updataCutRectangle()
		}
		
		public function setPos(x:int,y:int):void
			
		{
			this._x=x;
			this._y=y;
			this.updataCutRectangle()
		}
		public function set  width(value:Number):void
		{
			this._width=value;
			updataCutRectangle()        
		}
		public function reander():void
		{
			updataCutRectangle()
		}
		public function set  height(value:Number):void
		{
			this._height=value        
			updataCutRectangle()        
		}
		public function setup(bitmapData:BitmapData,scale9Grid:Rectangle):void
		{
			this._bitmapdata=bitmapData;
			this._scale9Grid=scale9Grid;
			updataCutRectangle()
		}
		public function setSize(width:int,height:int):void
		{
			this._width=width;
			this._height=height;
			updataCutRectangle()        
		}       
		private function updataCutRectangle():void
		{
			if(this._bitmapdata==null||_width == 0 ||(_bitmapdata.width==0&&this._bitmapdata.height==0))
				return;
			var rect:Rectangle=this._bitmapdata.rect;
			_curbitmapdata = new BitmapData(_width,_height,true,0);
			var matrix:Matrix=new Matrix();
			matrix.tx=_x-rect.width/2;        
			matrix.ty=_y-rect.height/2;
			_curbitmapdata.draw(_bitmapdata,matrix);
			if(matrix.tx>0){
				_otherbmd = new BitmapData(matrix.tx,_height,true,_color);
				var matrix1:Matrix=new Matrix();
				_curbitmapdata.draw(_otherbmd,matrix1); 
			}
			if(matrix.ty>0){
				_otherbmd = new BitmapData(_width-matrix.tx,matrix.ty,true,_color);
				var matrix2:Matrix=new Matrix();
				matrix2.tx = matrix.tx;
				_curbitmapdata.draw(_otherbmd,matrix2); 
			}
			if(matrix.ty+rect.height<_height)
			{
				_otherbmd = new BitmapData(_width-matrix.tx,_height-(matrix.ty+rect.height),true,_color);
				var matrix3:Matrix=new Matrix();
				matrix3.ty = matrix.ty+rect.height;
				matrix3.tx = matrix.tx;
				_curbitmapdata.draw(_otherbmd,matrix3); 
			}
			if(_width>matrix.tx+rect.width)
			{
				_otherbmd = new BitmapData(_width-(matrix.tx+rect.width),_height-matrix.ty,true,_color);
				var matrix4:Matrix=new Matrix();
				matrix4.ty = matrix.ty;
				matrix4.tx = matrix.tx+rect.width;
				_curbitmapdata.draw(_otherbmd,matrix4); 
			}
			//_curbitmapdata.copyPixels(_bitmapdata,new Rectangle(0,0,rect.width,rect.height),new Point(_x-rect.width/2,_y-rect.height/2));
		}
		public function draw(graphics:Graphics,clear:Boolean=true):void
		{
			if(clear)graphics.clear();
			graphics.beginBitmapFill(this._curbitmapdata,null,false,true);
			graphics.drawRect(0,0,_width,_height);
		}
		public function dispose():void
		{
			if(this._bitmapdata)
			{
				this._bitmapdata.dispose();
				this._bitmapdata = null;
			}
			if(this._curbitmapdata)
			{
				this._curbitmapdata.dispose();
				this._curbitmapdata = null;
			}
			if(this._otherbmd)
			{
				this._otherbmd.dispose();
				this._otherbmd = null;
			}
		}
	}
}