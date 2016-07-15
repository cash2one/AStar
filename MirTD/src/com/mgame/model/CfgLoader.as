package com.mgame.model
{
	import com.sh.game.util.CSVDataUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	

	public class CfgLoader
	{
		private static var _instance:CfgLoader = null;
		private var loadDataCompleteFunc:Function;
		private var onPro:Function;
		private var _dataUrls:Array;
		private var tryCount:int = 0;
		
		private var _urlLoader:URLLoader;
		
		private var _mapDataCache:Array;
		private var _totalCount:int = 0;
		
		public function CfgLoader()
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE,urlloaded);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		public static function get instance():CfgLoader{
			if(_instance == null){
				_instance = new CfgLoader();
			}
			return _instance;
		}
		
		public function loadMapData(urlList:Array,completeFunc:Function,version:String = null,onPro:Function = null):void{
			_dataUrls = urlList;
			_mapDataCache = new Array();
			this.loadDataCompleteFunc = completeFunc;
			this.onPro = onPro;
			_totalCount = urlList.length;
			loadNextData();
		}
		
		private var _curFile:String = "";
		
		
		private function loadNextData():void{
			if(_dataUrls && _dataUrls.length > 0){
				//_curFile = _dataUrls.shift();
				//	App.mloader.loadBYTE(Config.getUrl(_curFile,ResourceType.DATA),0,new Handler(urlloaded),new Handler(onProgress),null,false);
				tryCount = 0;
				_curFile = _dataUrls.shift();
				_urlLoader.load(new URLRequest(_curFile));
			}else{
				if(this.loadDataCompleteFunc != null){
					loadDataCompleteFunc(_mapDataCache);
					_mapDataCache = null;
					loadDataCompleteFunc = null;
					//_urlLoader = null;
				}
			}
		}
		
		protected function ioErrorHandler():void
		{
			/*if(tryCount < 3){
				tryCount ++;
				if(_urlLoader){
					_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					_urlLoader.removeEventListener(Event.COMPLETE,urlloaded);
				}
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(Event.COMPLETE,urlloaded);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				_urlLoader.load(new URLRequest(Config.getUrl(_curFile,ResourceType.DATA)));
			}*/
			/*if(_urlLoader){
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				_urlLoader.removeEventListener(Event.COMPLETE,urlloaded);
			}*/
			loadNextData();
		}
		
		protected function onProgress(event:*):void
		{ 
			if(onPro != null){
				onPro(event + this._totalCount - this._dataUrls.length - 1,_totalCount);
				//onPro(event.bytesLoaded,event.bytesTotal);
			}
		}
		
		private function urlloaded(e:Event):void{
			if(e.currentTarget.data == null){
				_mapDataCache.push(null);
				loadNextData();
				return;
			}
			var cfgs:Object;
			var bytes:ByteArray;
			var type:String = _curFile.substring(_curFile.lastIndexOf(".") + 1);
			if(type == "csv")
				cfgs = CSVDataUtil.listData(e.currentTarget.data);
			_mapDataCache.push(cfgs);
			loadNextData();
		}
		
	}
}