package com.sh.game.util
{
	import com.sh.game.map.HitDisplayObject;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapDataHitTestUtil
	{
		/**
		 * 黑白图，黑色碰撞检测
		 */
		public static function hitTest(display1:HitDisplayObject,display2:HitDisplayObject,minW:int,minH:int):Boolean{
			var hited:Boolean = false;
			var rectInter:Rectangle = display1.viewRect.intersection(display2.viewRect);
			if(rectInter.width > 0){
				var bdred:BitmapData = new BitmapData(rectInter.width,rectInter.height,true);
				bdred.copyChannel(display1.bitmapData,new Rectangle(rectInter.x - display1.x,rectInter.y -display1.y ,display1.bitmapData.width,display1.bitmapData.height),new Point(0,0),BitmapDataChannel.RED,BitmapDataChannel.RED);
				bdred.copyChannel(display2.bitmapData,new Rectangle(rectInter.x - display2.x,rectInter.y -display2.y,display2.bitmapData.width,display2.bitmapData.height),new Point(0,0),BitmapDataChannel.BLUE,BitmapDataChannel.BLUE);
				var colorRect:Rectangle = bdred.getColorBoundsRect(0xFF11FF11,0xFF00FF00 );
				if(colorRect && (colorRect.width>=minW && colorRect.height >= minH)){
					hited = true;
				}
				bdred.dispose();
			}
			return hited;
		}
		
	}
}