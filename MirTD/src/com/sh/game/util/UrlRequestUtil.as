package com.sh.game.util
{
	import com.sh.game.global.Config;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import morn.core.handlers.Handler;

	public class UrlRequestUtil
	{
		public function UrlRequestUtil()
		{
		}
		
		public static function request(url:String,data:Object,handler:Handler):void{
			var req:UrlRequestUtil = new UrlRequestUtil();
			req.doRequest(url,data,handler);
		}
		
		private var _completeHandler:Handler;
		
		public function doRequest(url:String,data:Object,handler:Handler):void{
			_completeHandler = handler;
			var req:URLRequest = new URLRequest(url);
			var uid:String = Config.gameParams.username;
			req.data = data;
			var urlloader:URLLoader = new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			urlloader.addEventListener(Event.COMPLETE,logComplete);
			urlloader.load(req);
		}
		
		public function logComplete(e:Event):void{
			var urlloader:URLLoader = e.currentTarget as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE,logComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			if(_completeHandler){
				_completeHandler.executeWith([urlloader.data]);
				_completeHandler = null;
			}
		}
		
		public function ioError(e:IOErrorEvent):void{
			var urlloader:URLLoader = e.currentTarget as URLLoader;
			urlloader.removeEventListener(Event.COMPLETE,logComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			if(_completeHandler){
				_completeHandler.executeWith([null]);
				_completeHandler = null;
			}
		}
	}
}