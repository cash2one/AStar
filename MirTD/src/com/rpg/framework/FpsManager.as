package com.rpg.framework
{	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class FpsManager
	{
		public function FpsManager()
		{
		}
		private var _fps:FpsItem;
		private var _timeID:uint;
		public function resiger():DrawableGameComponent
		{
			_fps = new FpsItem();
			_timeID = setTimeout(updatefps,30000)

			return _fps;
		}
		
		private function updatefps():void
		{
			_fps.lastdeal();
			clear();
			
		}
		private function clear():void
		{
			clearTimeout(_timeID);
			_timeID = 0;
			if(_fps&&_fps.display.parent)
			{
				_fps.display.parent.removeChild(_fps.display);
			}
			_fps = null;
		}
		
	
		
	}
}