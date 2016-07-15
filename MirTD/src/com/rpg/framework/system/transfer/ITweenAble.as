package com.rpg.framework.system.transfer
{
	public interface ITweenAble
	{
		function get moveNext():Boolean;
		function get uniform():Boolean;
		
		function get endNow():Boolean;
		function get x() : Number;
		
		function set x(value : Number) : void;
		
		function get y() : Number;
		
		function set y(value : Number):void;
	}
}