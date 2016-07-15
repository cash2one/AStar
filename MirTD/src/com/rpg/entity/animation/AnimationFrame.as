package com.rpg.entity.animation
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.BitmapData;
	

	public class AnimationFrame implements IDisposable
	{
		public var x : int;
		public var y : int;
		public var data : BitmapData;

		public function dispose() : void
		{
			this.data.dispose();
			this.data = null;
		}
	}
}
