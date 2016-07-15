package com.rpg.framework
{
	public interface IUpdateable
	{
		function update(gameTime : GameTime) : void;
		function get enabled() : Boolean;
	}
}
