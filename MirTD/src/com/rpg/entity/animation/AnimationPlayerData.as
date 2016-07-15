package com.rpg.entity.animation
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	

	public class AnimationPlayerData implements IDisposable
	{
		/** 最大高度 */
		public var maxHeight : int;
		/** 动画是否可以以像素点选中 */
		public var select : Boolean;
		/** 动画数据 */
		public var clip  :AnimationClip; 		 // 存放 AnimationClip 对象集合
		
		public var action:int;
		public var dir:int;
		
		//protected var _action   : Dictionary; 	  		 // 动画剪辑规则
		public var visible:Boolean = true;
		public var model:String;
		protected var _actionDirs:Dictionary;
		public var fileName:int;
		
		public var soundurl:String = "";
		public var soundframe:int  = -1;
		
		/**
		 * 是否是默认模型
		 */
		public var isDefaultModel:Boolean = false;
		
		public function AnimationPlayerData()
		{
			_actionDirs   = new Dictionary();
		}
		
		public function dispose() : void
		{
			//_reader.dispose();
			if(clip && clip.frames){
				for each (var frame:AnimationFrame in clip.frames) 
				{
					if(frame)
						frame.dispose();
				}
				clip.frames = null;
				clip = null;
			}
			soundframe = -1;
			soundurl   = "";
			_actionDirs   = null;
		}

		public function getClipFrame(index:int):AnimationFrame{
			return null;
		}
		
		/** 生成影片动画帧  */
		protected function createFrame(index : int,frameInfo:Object,bitmapData:BitmapData,standX:int,standY:int) : AnimationFrame
		{
			var rect  : Rectangle;
			var frame : AnimationFrame;
			frame  	   = new AnimationFrame();
			frame.x = frameInfo.x - standX;
			frame.y = frameInfo.y - standY;
			frame.data = bitmapData;

			if (index == 0)
			{
				maxHeight = frame.y;
			}
			return frame;
		}
	}
}
