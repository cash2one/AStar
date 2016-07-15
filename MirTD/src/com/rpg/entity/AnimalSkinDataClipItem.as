package com.rpg.entity
{
	public class AnimalSkinDataClipItem
	{
		public var action 	   : int;
		public var interval	   : int;
		public var playCount   : int;
		public var totalcount:int;
		public var actionIndex : int;
		public var standX:int;
		public var standY:int;

		public function AnimalSkinDataClipItem(action : int, interval : int,totalcount:int, playCount : int, actionIndex : int = -1,standX:int = 320,standY:int = 374)
		{
			this.action 	 = action;
			this.totalcount = totalcount;
			this.interval    = interval;
			this.playCount   = playCount;
			this.actionIndex = actionIndex;
			this.standX = standX;
			this.standY = standY;
		}
	}
}