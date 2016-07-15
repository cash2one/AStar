package com.rpg.framework
{
	import flash.display.Sprite;

	public interface IDrawable
	{
//		function draw(gameTime:GameTime):void
		function get display() : Sprite			// 显示对象
		function get visible() : Boolean 		// 是否显示
	}
}
