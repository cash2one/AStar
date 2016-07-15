package com.rpg.framework.loading
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;

	/** 没测试本地存储 */	
	public class SoundItem extends LoadingItem
	{
		private var _loader : Sound;

		public function SoundItem(url : String, type : String, name : String)
		{
			super(url, type, name);
		}
		
		protected override function httpLoad():void
		{
			// 注：音乐文件没有用本地存储，功能是因为二进制无法转成 Sound 对象使用 
			// flash 11.2 中有有相关API
			if (false) // local
			{
				super.httpLoad();
			}
			else
			{
				_loader = new Sound();
				_loader.addEventListener(ProgressEvent.PROGRESS			  , super.onProgressHandler);
				_loader.addEventListener(Event.COMPLETE					  , onCompleteHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR			  , super.onErrorHandler);
				_loader.addEventListener(Event.OPEN						  , onStartedHandler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
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
		
		// 注：音乐文件没有用本地存储，功能是因为二进制无法转成 Sound 对象使用 
		// flash 11.2 中有有相关API
		protected override function onCompleteHandler(e : Event) : void
		{
			status = STATUS_FINISHED;
			calculateSpeed(); // 计算下载速度
			cleanListeners(); // 下载完成后删除所有下载事件
			
			httpContent(e);
		}
		
		protected override function httpContent(evt : Event) : void
		{
			content = _loader;
			super.httpContent(evt);
		}
		
		protected override function onStartedHandler(evt : Event) : void
		{
			content = _loader;
			super.onStartedHandler(evt);
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
                _loader.removeEventListener(ProgressEvent.PROGRESS			 , super.onProgressHandler);
                _loader.removeEventListener(Event.COMPLETE		 			 , onCompleteHandler);
                _loader.removeEventListener(IOErrorEvent.IO_ERROR			 , super.onErrorHandler);
                _loader.removeEventListener(Event.OPEN						 , onStartedHandler);
                _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, super.onSecurityErrorHandler);
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
