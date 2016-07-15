package com.sh.game.util
{
	public class DragImage
	{
		private static var _instance:DragImage;


		public static function get instance():DragImage
		{
			return _instance||= new DragImage(); 
		}
		public var funcDic:Object = new Object();
	}
}