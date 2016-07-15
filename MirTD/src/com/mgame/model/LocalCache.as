package com.mgame.model
{
	
	import flash.net.SharedObject;
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 上午9:51:17
	 * 
	 */
	public class LocalCache {
		
		private var globalCache:SharedObject;
		private static var _instance:LocalCache;
		private static var _rid:int = 0;
		
		public function LocalCache() {
			globalCache = SharedObject.getLocal("yscqtdgame");
		}
		
		public static function getInstance():LocalCache {
			if(LocalCache._instance == null) {
				LocalCache._instance = new LocalCache();
			}
			return LocalCache._instance;
		}
		
		public function putValue(key:String,value:Object):void {
				globalCache.data[key]=value;
				globalCache.flush();
		}
		
		public function getValue(key:String):* {
				return globalCache.data[key];
		}
		
		public function clear():void {
			globalCache.clear();
		}
	}
}