package com.rpg.framework.loading
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * SWF 文件加载
	 * 
	 */	
	public class SWFItem extends LoadingItem
	{
		private var _loader    : URLLoader;
		private var _binLoader : Loader;
		
		public function SWFItem(url : String, type : String, name : String)
		{
			super(url, type, name);
		}
		
		protected override function httpLoad():void
		{
			if (local)
			{
				super.httpLoad();
			}
			else
			{
				_loader = new URLLoader();
				_loader.dataFormat = URLLoaderDataFormat.BINARY;
				_loader.addEventListener(ProgressEvent.PROGRESS     	  , super.onProgressHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR      	  , super.onErrorHandler);
				_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS	  , super.onHttpStatusHandler);
				_loader.addEventListener(Event.OPEN					      , super.onStartedHandler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
				_loader.addEventListener(Event.COMPLETE					  , super.onCompleteHandler);
				try
				{
					_loader.load(_urlRequest);
				}
				catch (e : SecurityError)
				{
					super.onSecurityErrorHandler(createErrorEvent(e));
				}
			}
		}

		protected override function httpContent(evt : Event) : void
		{
			// 用  URLLoader 拿到 SWF 文件以后，通过 Loader.loadBytes 解析
			_binLoader = new Loader();
			_binLoader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
			_binLoader.loadBytes(evt.target.data);
		}

		private function initHandler(e : Event) : void
		{
			_binLoader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
			content = _binLoader.content;
			super.httpContent(new Event(Event.COMPLETE));
		}
		
		public override function stop() : void
		{
			try
			{
				if (_loader)
				{
					_loader.close();
				}
			}
			catch (e : Error)
			{
				
			}
			super.stop();
		}
		
		protected override function cleanListeners() : void
		{
			if (_loader)
			{
				_loader.removeEventListener(ProgressEvent.PROGRESS	  		 , super.onProgressHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR 	  		 , super.onErrorHandler);
				_loader.removeEventListener(Event.OPEN			 	  		 , super.onStartedHandler);
				_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS	     , super.onHttpStatusHandler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
				_loader.removeEventListener(Event.COMPLETE			  		 , super.onCompleteHandler);

				if (_binLoader && _binLoader.contentLoaderInfo.hasEventListener(Event.INIT))
				{
					_binLoader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
				}
			}
			super.cleanListeners();
		}
		
		public override function dispose() : void
		{
			super.dispose();
			_loader    = null;
			_binLoader = null;
		}   
	}	
}