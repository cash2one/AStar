package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Test3 extends Sprite
	{
		public function Test3()
		{
//			var spr:Sprite = new Sprite();
//			addChild(spr);
//			spr.graphics.beginFill(0xff0000);
//			spr.graphics.drawRect(0,0,20,20);
//			spr.graphics.endFill();
			
			var i:int = (1 << 16) + 1;trace(i);
			var j:int = 2 << 16;trace(j);
			var z:int = 1 << 17;trace(z);
			
			return;
			var bmd:BitmapData = new BitmapData(40,50,true,0xff0000);
			var bmp:Bitmap = new Bitmap();
			addChild(bmp);
			bmd.draw(bmp);
			
//			photography(spr);
		}
		
		public function photography(photo:DisplayObject,fillColor:uint = 0,hemorrhage:Number = 0,transparent:Boolean = true):BitmapData
		{ 
			var tmpRect:Rectangle = photo.getRect(photo); 
			var picture:BitmapData = new BitmapData(photo.width + hemorrhage * 2,photo.height + hemorrhage * 2,transparent,fillColor); 
			picture.draw(photo,new Matrix(1,0,0,1,- tmpRect.left + hemorrhage,- tmpRect.top + hemorrhage)); 
			return picture; 
		} 
	}
}