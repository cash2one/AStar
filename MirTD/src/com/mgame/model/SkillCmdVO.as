package com.mgame.model
{
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-5 下午4:24:40
	 * 
	 */
	public class SkillCmdVO
	{
		public function SkillCmdVO()
		{
		}
		
		public var id:int;
		public var toid:int;
		public var x:int;
		public var y:int;
		public var type:int;
		public var servertime:int;
		public var skillid:int;
		public var hurtlist:Array;
		public var bufflist:Array;
		
	}
}