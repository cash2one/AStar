package com.rpg.scene.actor.compnent
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	public class Eclipse extends Sprite implements IDisposable
	{
		private static var caches:Dictionary = new Dictionary();
		private static const Border:int = 10;
		private var bitmap:Bitmap;
		public function Eclipse()
		{
			super();
		}
		
		public function draw(w:int,h:int,color:uint = 0xff0000):void{
			var ename:String = w+ "_" + h + "_"  + color;
			if(!caches[ename]){
				var shape:Shape = new Shape();
				shape.graphics.clear();
				shape.graphics.lineStyle(4,color,0.2);
				shape.graphics.beginGradientFill(GradientType.RADIAL,[color,color],[0.2,0.5],[0,255],new Matrix(1,0,0,1,w/2 +Border,h/2 + Border));
				shape.graphics.drawEllipse(Border,Border,w ,h );
				shape.graphics.endFill();
				var bmd:BitmapData = new BitmapData(w+ Border*2,h+ Border*2,true,0);
				bmd.draw(shape);
				caches[ename] = bmd;
			}
			if(!bitmap){
				bitmap = new Bitmap();
				this.addChild(bitmap);
			}
			bitmap.bitmapData = caches[ename];
			bitmap.x = -w/2 - Border;
			bitmap.y = -h/2- Border;
		}
		
		public function dispose():void
		{
			if(bitmap){
				if(bitmap.parent)
					bitmap.parent.removeChild(bitmap);
				bitmap.bitmapData = null;
				bitmap = null;
			}
		}
		
		
	}
}