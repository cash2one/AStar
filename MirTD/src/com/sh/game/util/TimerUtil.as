package com.sh.game.util
{
	public class TimerUtil
	{
		public function TimerUtil()
		{
		}
		
		private static var _instance:TimerUtil = null;
		
		public static function get instance():TimerUtil{
			if(_instance == null){
				_instance = new TimerUtil();
			}
			return _instance;
		}
		
	}
}