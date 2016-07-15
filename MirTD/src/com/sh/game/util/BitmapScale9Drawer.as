package com.sh.game.util
{
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public  class BitmapScale9Drawer 
	{
		public static var _defaultBitmapData_:BitmapData=new BitmapData(10,10,false,0xffffff)
		private var _bitmapdata:BitmapData;
		private var _width:int;
		private var _height:int;
		private var _scale9Grid:Rectangle;
		private var _cutRect:Rectangle
		private var _scale9GridRect:Array
		private var _x:int=0;
		private var _y:int=0
		
		public function BitmapScale9Drawer(bitmapData:BitmapData=null,scale9Grid:Rectangle=null)
		{
			super();
			this._bitmapdata=bitmapData;
			if(this._bitmapdata==null)this._bitmapdata=_defaultBitmapData_;
			this._scale9Grid=scale9Grid
			if(this._scale9Grid==null)
				this._scale9Grid=new Rectangle(80,30,121,340);
			updataCutRectangle();
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
		public function get curRect():Rectangle
		{
			return this._cutRect;
		}
		public function reander():void
		{
			updataCutRectangle()
		}
		private function updataCutRectangle():void
		{
			if(this._bitmapdata==null||(_bitmapdata.width==0&&this._bitmapdata.height==0))return;
			var rect:Rectangle=this._bitmapdata.rect;
			var width:int=this._width-_scale9Grid.x-(rect.right-this._scale9Grid.right)
			var height:int=this._height-_scale9Grid.y-(rect.bottom-this._scale9Grid.bottom)
			width<0?width=0:''
			height<0?height=0:''
			this._cutRect=new Rectangle(
				_scale9Grid.x,
				_scale9Grid.y,
				width,
				height
			)
			var xx:Array=[0,this._scale9Grid.x,this._scale9Grid.right];
			var yx:Array=[0,this._scale9Grid.y,this._scale9Grid.bottom];
			var wx:Array=[this._scale9Grid.x,this._scale9Grid.width,rect.right-this._scale9Grid.right];
			var hx:Array=[this._scale9Grid.y,this._scale9Grid.height,rect.bottom-this._scale9Grid.bottom]
			
			var x:Array=[0,this._cutRect.x,this._cutRect.right];
			var y:Array=[0,this._cutRect.y,this._cutRect.bottom];
			var w:Array=[this._cutRect.x,this._cutRect.width,rect.right-this._scale9Grid.right];
			var h:Array=[this._cutRect.y,this._cutRect.height,rect.bottom-this._scale9Grid.bottom]
			this._scale9GridRect=new Array
			for(var i:int=0;i<3;i++)
			{
				for(var j:int=0;j<3;j++)
				{
					var matrix:Matrix=new Matrix
					var scalew:Number
					var scaleh:Number
					
					scalew=(w[i]/wx[i]);
					scaleh=(h[j]/hx[j]);
					matrix.scale(scalew,scaleh);
					matrix.ty=y[j]-yx[j]+_y;        
					matrix.tx=x[i]-xx[i]+_x;
					if(i==1)
						matrix.tx=(1-scalew)*x[1]+_x;
					if(j==1)
						matrix.ty=(1-scaleh)*y[1]+_y;
					_scale9GridRect.push({rect:new Rectangle(x[i],y[j],w[i],h[j]),matrix:matrix})
				}
			}
		}
		public function set  width(value:Number):void
		{
			this._width=value;
			updataCutRectangle()        
		}
		public function set  height(value:Number):void
		{
			this._height=value        
			updataCutRectangle()        
		}
		public function setup(bitmapData:BitmapData,scale9Grid:Rectangle):void
		{
			this.bitmapData=bitmapData;
			this.scale9Grid=scale9Grid;
		}
		public function set  scale9Grid(innerRectangle:Rectangle):void
		{
			this._scale9Grid=innerRectangle;
			updataCutRectangle()        
		}
		public function get scale9Grid():Rectangle
		{
			return this._scale9Grid
		}
		public function set rect(value:Rectangle):void
		{
			this._x=value.x;
			this._y=value.y;
			this._width=value.width;
			this._height=value.height
			updataCutRectangle()        
		}
		public function set bitmapData (value:BitmapData):void
		{
			
			this._bitmapdata=value;
			updataCutRectangle()        
			
		}
		public function draw(graphics:Graphics,clear:Boolean=true,drawCutRect:Boolean=true):void
		{
			if(clear)graphics.clear();
			for(var i:int=0;i<9;i++)
			{
				
				var rect:Rectangle=_scale9GridRect[i].rect;
				var matrix:Matrix=_scale9GridRect[i].matrix
				//                                        graphics.lineStyle(1,0xff0000)
				graphics.beginBitmapFill(this._bitmapdata,matrix,false,true);
				if(!(!drawCutRect&&i==4))
				{
					graphics.drawRect(rect.x+_x,rect.y+_y,rect.width,rect.height)
				}
				
			}
		}
		
		public function setSize(width:int,height:int):void
		{
			this._width=width;
			this._height=height;
			updataCutRectangle()        
		}        
		
	}
}