package com.rpg.framework.system.thread
{
	public interface IThreadProcess
	{
		function get id() : String;

		function get completed() : Boolean;

		function process() : void;
		
		function get failMaxCount():int;
	}
}