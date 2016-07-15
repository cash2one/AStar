package com.rpg.scene.model
{
	public class CmdVO
	{
		public function CmdVO(cmd:int,arg:Object)
		{
			this.cmd = cmd;
			this.arg =arg;
		}
		public var cmd:int;
		public var arg:Object;
		
		public function toString():String{
			return cmd + "";
		}
	}
}