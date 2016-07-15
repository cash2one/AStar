package com.sh.game.util
{
	import flash.utils.ByteArray;
	
	import pluginfw.nio.Input;

	public class Array2Map
	{
		
		public static function addMapKeys(keys:Array,data:Object):Object{
			var map:Object = new Object();
			for each(var n:String in keys){
				map[n] = data[n];
			}
			return map;
		}
		
		public static function addByteToMapByKeys(input:Input ,keys:Array,bytes:ByteArray):Object{
			bytes.position = 0;
			input.setBytes(bytes);
			var ret:Object = new Object();
			for each(var key:Object in keys){
				if(input.bytesAvailable > 0)
					ret[key] = input.readVarInt(false);
				else{
					Logger.log("keys 读取错误：" + keys);
					break;
				}
			}
			return ret;
		}
	}
}