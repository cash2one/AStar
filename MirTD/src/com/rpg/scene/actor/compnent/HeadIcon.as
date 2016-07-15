package com.rpg.scene.actor.compnent
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-3-23 下午5:52:49
	 * 角色头上的icon
	 */
	public class HeadIcon extends Bitmap
	{
		public var data:Object;
		
		public function HeadIcon(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}