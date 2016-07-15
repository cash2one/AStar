package com.sh.game.util
{
	import com.sh.game.global.Config;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Logger
	{
		private static var _logs:Array = new Array();
		
		/**
		 * 场景主循环帧消耗时间(ms)
		 */
		public static var frameTime:int = 0;
		/**
		 * 使用中的特效
		 */
		public static var effectInUse:int = 0;
		
		public function Logger()
		{
			
		}
		
		public static function addPrinter(printer:ILogger,printerType:int):void{
			_logs[printerType] = printer;
		}
		
		/**
		 * 
		 * @param str
		 * @param logType
		 * @param printerType
		 */
		public static function log(str:String,logType:int = 2,printerType:int = 0):void{
			if(_logs[printerType] != null)
				_logs[printerType].log(str,logType);
			else
				trace(str);
		}
		
		public static function logUrlRequest(url:String,data:Object):void{
			var req:URLRequest = new URLRequest(url);
			var uid:String = Config.gameParams.username;
			req.data = data;
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			urlloader.addEventListener(Event.COMPLETE,logComplete);
			urlloader.load(req);
		}
		
		public static function logComplete(e:Event):void{
			var urlloader:URLLoader = e.currentTarget as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE,logComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		}
		
		public static function ioError(e:IOErrorEvent):void{
			var urlloader:URLLoader = e.currentTarget as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE,logComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		}
	}
}