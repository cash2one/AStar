package com.sh.game.util
{
	
	import flash.utils.ByteArray;
	
	
	public class ObjectUtil
	{
		public static function clone(value:Object):Object
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}
	}
}

