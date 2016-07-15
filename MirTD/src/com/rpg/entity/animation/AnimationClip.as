package com.rpg.entity.animation
{
	public class AnimationClip
	{
		/** 动画剪辑名  */
		public var name 	 : String;
		/** 是否翻转（1为水平正向，-1为水平反向）  */
		public var turn 	 : int;
		/** 每帧间隔时间  */
		public var interval  : int;
		/** 循环次数 */
		public var playCount : int;
		/** 动画帧数据  */
		public var frames : Vector.<AnimationFrame> = new Vector.<AnimationFrame>;
		/** 已处理帧数  */
		public var process:int = 0;
		
		public var totalCount:int;

		public function AnimationClip(len:int):void{
			totalCount = len;
			frames = new Vector.<AnimationFrame>(len);
		}
		
		public function dispose() : void
		{
			var af : AnimationFrame;
			while (frames.length != 0)
			{
				af = frames.shift();
				af.dispose();
			}
			this.frames = null;
		}
	}
}
