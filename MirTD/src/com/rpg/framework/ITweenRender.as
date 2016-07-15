package com.rpg.framework
{
	public interface ITweenRender
	{
		/**
		 * 
		 * @param gameTime
		 * @return 是否销毁
		 * 
		 */
		function render(gameTime : GameTime):Boolean ;
		function get enabled() : Boolean;
	}
}
