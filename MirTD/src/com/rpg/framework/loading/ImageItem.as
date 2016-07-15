package com.rpg.framework.loading
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	/** 图片、SWF文件加载 */
	public class ImageItem extends LoadingItem 
	{
		private var _loader : Loader;
		
		public function ImageItem(url : String, type : String, name : String)
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
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.INIT					    , onInitHandler);
				_loader.contentLoaderInfo.addEventListener(Event.OPEN					    , super.onStartedHandler); 
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR 		    , super.onErrorHandler);
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);    
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS		    , super.onProgressHandler);
				_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS      , super.onHttpStatusHandler);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE				  	, super.onCompleteHandler);
				try
				{
					_loader.load(_urlRequest, context);
				}
				catch (e : SecurityError)
				{
					super.onSecurityErrorHandler(createErrorEvent(e));
				}
			}
		}
		
		protected override function httpContent(evt : Event) : void
		{
			try
			{
				content = _loader.contentLoaderInfo.content;
			}
			catch (e : SecurityError)
			{
				content = null;
			}
			super.httpContent(evt);
		}
		
		public function onInitHandler(evt : Event) : void
		{
			dispatchEvent(evt);
		}
		
		protected override function cleanListeners() : void
		{
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.INIT					    , onInitHandler);
				_loader.contentLoaderInfo.removeEventListener(Event.OPEN					    , super.onStartedHandler); 
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR 		    , super.onErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , super.onSecurityErrorHandler);    
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS		    , super.onProgressHandler);
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS       , super.onHttpStatusHandler);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE				    , super.onCompleteHandler);
			}
			super.cleanListeners();
		}
		
		public override function stop() : void
		{
			try
			{
				if (_loader)
				{
					_loader.close();
					_loader.unloadAndStop(true);
				}
			}
			catch (e : Error)
			{
				
			}
			super.stop();
		}
		
		public override function dispose() : void
		{
			super.dispose();
			_loader = null;
		}
	}
}