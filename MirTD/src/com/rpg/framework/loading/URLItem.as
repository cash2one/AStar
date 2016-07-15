package com.rpg.framework.loading
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
    
	public class URLItem extends LoadingItem
	{
		private var _loader : URLLoader;

		public function URLItem(url : String, type : String, name : String)
		{
			super(url, type, name);
		}
		
		protected override function httpLoad():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS		, super.onProgressHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR		, super.onErrorHandler);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler);
			_loader.addEventListener(Event.OPEN					, super.onStartedHandler);
			_loader.addEventListener(Event.COMPLETE				, super.onCompleteHandler);
			try
			{
				_loader.load(_urlRequest);
			}
			catch (e : SecurityError)
			{
				super.onSecurityErrorHandler(createErrorEvent(e));
			}
		}
		
		protected override function httpContent(evt : Event) : void
		{
			content = _loader.data;
			super.httpContent(evt);
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
                _loader.removeEventListener(ProgressEvent.PROGRESS	   , super.onProgressHandler);
                _loader.removeEventListener(IOErrorEvent.IO_ERROR 	   , super.onErrorHandler);
                _loader.removeEventListener(Event.OPEN			 	   , super.onStartedHandler);
                _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler);
				_loader.removeEventListener(Event.COMPLETE			   , super.onCompleteHandler);
            }
			super.cleanListeners();
        }

		public override function dispose() : void
		{
			super.dispose();
			_loader = null;
		}
	}
}
