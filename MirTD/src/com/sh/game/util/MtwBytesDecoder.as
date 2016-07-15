package com.sh.game.util
{
	import flash.utils.ByteArray;

	public class MtwBytesDecoder
	{
		public function MtwBytesDecoder()
		{
		}
		
		public static function decode(bytes:ByteArray,key:String):void{
			var keyBytes:ByteArray = new ByteArray();
			keyBytes.writeMultiByte(key,"utf8");
			var p:int  = bytes.length / 2;
			bytes.position = p;
			for(var i:int = 0; i < keyBytes.length; i ++){
				bytes.writeByte(bytes[i + p] ^ keyBytes[i]);
			}
		}
	}
}