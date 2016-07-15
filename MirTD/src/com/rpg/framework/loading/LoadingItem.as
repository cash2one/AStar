package com.rpg.framework.loading
{
	import com.rpg.framework.IDisposable;
	import com.sh.game.global.Config;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "open", type = "flash.events.Event")]
	[Event(name = "init", type = "flash.events.Event")]
	public class LoadingItem extends EventDispatcher implements IDisposable
	{
		public function LoadingItem(url : String, type : String, name : String)
		{
			if (!url || !String(url))
			{
				throw new Error("[BulkLoader] 不能添加一个空的 URL 的项目")
			}

			this.status  = STATUS_WAIT;
			this.type    = type;
			this.name    = name;
			this.url     = url;
		}

		/** 开始加载资料 */
		public function load() : void
		{
			
			_urlRequest = new URLRequest(Config.getUrl(url));
			httpLoad();
		}

		protected function httpLoad() : void
		{
			_stream = new URLStream();
			_stream.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_stream.addEventListener(Event.COMPLETE, onCompleteHandler);
			_stream.addEventListener(Event.OPEN, onStartedHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_stream.load(_urlRequest);
		}

		/** Http状态事件 */
		protected function onHttpStatusHandler(e : HTTPStatusEvent) : void
		{
			_httpStatus = e.status;
			dispatchEvent(e);
		}

		/** 开始下载事件 */
		protected function onStartedHandler(e : Event) : void
		{
			_responseTime = getTimer();
			_latency	  = BulkLoader.truncateNumber((_responseTime - _startTime) / 1000);
			status 		  = STATUS_STARTED;
			dispatchEvent(e);
		}

		/** 下载进度事件 */
		protected function onProgressHandler(e : ProgressEvent) : void
		{
			if (_stream) // 保存本地存储数据流
			{
				while (_stream.bytesAvailable)
				{
					_stream.readBytes(_sharedContent, _sharedContent.length);
				}
			}

			bytesLoaded    = e.bytesLoaded;
			bytesTotal     = e.bytesTotal;
			bytesRemaining = bytesTotal - bytesLoaded;
			_percentLoaded = bytesLoaded / bytesTotal;
			_weightPercentLoaded = _percentLoaded * weight;
			calculateSpeed();
			dispatchEvent(e);
		}

		/** 下载完成事件 */
		protected function onCompleteHandler(e : Event) : void
		{
			status = STATUS_FINISHED;
			calculateSpeed(); // 计算下载速度
			cleanListeners(); // 下载完成后删除所有下载事件

			
			httpContent(e);
			
		}

		/** 网络内容解析 */
		protected function httpContent(e : Event) : void
		{
			dispatchEvent(e);
		}

		/** 本地内容解析 */
		protected function sharedContent(sharedContent : *) : void
		{
			if (sharedContent is ByteArray)
			{
				_sharedLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSharedLoaderComplete);
				function onSharedLoaderComplete(e : Event) : void
				{
					content = e.currentTarget.content;
					dispatchEvent(e);
				}

				try
				{
					_sharedLoader.loadBytes(sharedContent);
				}
				catch (e : ArgumentError)
				{
					httpLoad();
				}
			}
			else
			{
				content = sharedContent;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		/** 加载出错事件 */
		protected function onErrorHandler(e : ErrorEvent) : void
		{
			_numTries++;

			if (_numTries < _maxTries)
			{
				status = null
				this.load();
				e.stopPropagation();
			}
			else
			{
				status = STATUS_ERROR;
				_errorEvent = e;
				this.cleanListeners(); // 下载出错时删除所有下载事件
				this.dispatchErrorEvent(_errorEvent);
			}
		}

		/** 安全错误事件 */
		protected function onSecurityErrorHandler(e : ErrorEvent) : void
		{
			status = STATUS_ERROR;
			_errorEvent = e as ErrorEvent;
			this.dispatchErrorEvent(_errorEvent);
			this.cleanListeners();
		}

		/** 报错事件反馈 */
		private function dispatchErrorEvent(e : ErrorEvent) : void
		{
			status = STATUS_ERROR;
			dispatchEvent(new ErrorEvent(BulkProgressEvent.ERROR, true, false, e.text));
		}

		/** 创建一个错误事件 */
		protected function createErrorEvent(e : Error) : ErrorEvent
		{
			return new ErrorEvent(BulkProgressEvent.ERROR, false, false, e.message);
		}

		private function createUrl(url : String, v : String) : String
		{
			var urlNew : String = url;
			if (v.length > 0)
			{
				if (url.indexOf("?") == -1)
				{
					urlNew = url + "?v=" + v;
				}
				else
				{
					urlNew = url + "&v=" + v;
				}
			}
			return urlNew;
		}

		/** 计算下载速度 */
		protected function calculateSpeed() : void
		{
			_totalTime = getTimer();
			_timeToDownload = (_totalTime - _responseTime) / 1000;
			if (_timeToDownload == 0)
			{
				_timeToDownload = 0.1;
			}
			speed = BulkLoader.truncateNumber((bytesLoaded / 1024) / (_timeToDownload));
		}

		/** 停止下载 */
		public function stop() : void
		{
			status = STATUS_STOPPED;
			try
			{
				if (_stream)
				{
					_stream.close();
				}
			}
			catch (e : Error)
			{

			}
		}

		/** 释放对象内存 */
		public function dispose() : void
		{
			this.stop();
			this.cleanListeners();
			this.context = null;
			this.content = null;
			_urlRequest = null;
			_errorEvent = null;

			/*if (_sharedLoader)
			{
				try
				{
					_sharedLoader.close();
				}
				catch (e : IOError)
				{

				}
				_sharedLoader = null;
			}
			if (_sharedContent)
			{
				_sharedContent.clear();
				_sharedContent = null;
			}*/
			_stream = null;
		}

		/** 删除所有事件 */
		protected function cleanListeners() : void
		{
			if (_stream)
			{
				_stream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_stream.removeEventListener(Event.COMPLETE, onCompleteHandler);
				_stream.removeEventListener(Event.OPEN, onStartedHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
				_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
		}

		public static const STATUS_WAIT : String     = "wait";
		public static const STATUS_STOPPED : String  = "stopped";
		public static const STATUS_STARTED : String  = "started";
		public static const STATUS_FINISHED : String = "finished";
		public static const STATUS_ERROR : String    = "error";

		public var version : String                  = ""; 		 // 资源版本号
		public var local : Boolean; 							 // 是否本地存储
		public var url : String;								 // 加载地址
		public var type : String; 								 // 加载数据类型(binary、image、movieclip、sound、text、xml、video)
		public var name : String;								 // 防止缓冲加载没更新数据时用到
		public var status : String; 							 // 加载状态
		public var speed : Number;								 // 加载速度
		public var weight : int                      = 1; 		 // 加载文件相对其它文件大小比例
		public var bytesTotal : int                  = 0; 		 // 下载字段总数
		public var bytesLoaded : int                 = 0; 		 // 下载字段
		public var bytesRemaining : int              = 10000000; // 剩余下载量
		public var content : *; 								 // 资源内容
		public var context : *;									 // LoaderContext 对象
		public var preventCache : Boolean; 						 // 防止缓冲加载没更新数据（true为防止缓冲）

		protected var _errorEvent : ErrorEvent;
		protected var _urlRequest : URLRequest;
		protected var _startTime : int;							 // 开始下载时间
		protected var _responseTime : Number; 					 // 连接上URL资料时间
		protected var _latency : Number; 						 // 时间（秒），服务器和发送开始了流媒体内容
		protected var _stream : URLStream;
		protected var _sharedLoader : Loader; 		 // 本地文件加载器
		protected var _sharedContent : ByteArray; 	 // 本地文件二进制数据
		protected var _sharedPath : String; 		 // 本地存储地址
		protected var _sharedExist : Boolean; 		 // 本地文件是否存在

		private var _maxTries 			 : int = 3;  // 最大尝试次数
		private var _numTries 			 : int = 0;  // 重加载次数
		private var _httpStatus 		 : int = -1; // HTTP连接状态
		private var _timeToDownload 	 : Number;   // 已加载时间
		private var _totalTime 			 : Number;   // 总加载时间
		private var _percentLoaded 		 : Number;   // 加载的百分比进行（从0到1）。
		private var _weightPercentLoaded : Number;   // 下载快权力比例
	}
}
