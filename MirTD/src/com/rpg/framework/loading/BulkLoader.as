/**
 *  var a:BulkLoader = new BulkLoader();
	a.addEventListener(BulkProgressEvent.PROGRESS,PROGRESS);
	a.addEventListener(BulkProgressEvent.COMPLETE,COMPLETE);
	a.add("http://hiphotos.baidu.com/%D4%CAzai/pic/item/f1927dbdde4cb12518d81fad.jpg");			
	a.add("http://hiphotos.baidu.com/chaduopaopao/pic/item/825ce9a63c861ebfd043583e.jpg");
	a.load();	// 设置最大并行连接数
 */
package com.rpg.framework.loading
{
	import com.rpg.framework.IDisposable;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	

	[Event(name = "open"    , type = "oops.framework.content.loading.BulkProgressEvent")]
	[Event(name = "progress", type = "oops.framework.content.loading.BulkProgressEvent")]
	[Event(name = "complete", type = "oops.framework.content.loading.BulkProgressEvent")]
	[Event(name = "error"   , type = "flash.events.ErrorEvent")]
	public class BulkLoader extends EventDispatcher implements IDisposable
	{
		private var _local : Boolean;
		/**
		 * 构造函数
		 * @param maxConnections 	最大下载连接数
		 * @param isLocal  		 	是否开启本地存储（默认为不开启）
		 */
		public function BulkLoader(maxConnections : int = 1, local : Boolean = false)
		{
			_local		    = local;
			_maxConnections = maxConnections;
		}

		/** public Function **************************************************/

		/** 启动加载以前添加的所有项目 */
		public function load() : void
		{
			if (_currentConnections > 0) _currentConnections--;
			
			while (_currentConnections < _maxConnections && _workItems.length > 0)
			{
				var item : LoadingItem = _workItems.shift();
				item.load();
				_currentConnections++;
			}
		}

		/**
		 * 添加加载网址
		 * @param url 			下载地址
		 * @param preventCache  是否加载缓冲中数据（true为不用IE缓存中数据）
		 * @param name			资源名
		 * @param weight		资源大小分量值
		 */
		public function add(url : String, name : String = null, preventCache : Boolean = false, weight : int = 1) : void
		{
			if (name == null || name == "")
			{
				name = url;
			}

			var item : LoadingItem = getLoadingItem(url);
			/**
			 * 彭海：
			 * 让参数：preventCache（强制加载）生效
			 * */
			if (item == null || preventCache) // 当前加载项不存在,
			{
				var type : String = this.guessType(url);
				item 			  = new TYPE_CLASSES[type] (url, type , name);
				item.preventCache = preventCache;
				item.weight       = weight;
				item.local        = _local;
				this.addItem(item);
			}
		}

		/**
		 * 添加加载 LoadingItem 对象
		 * @param item 			LoadingItem 对象
		 */
		public function addItem(item : LoadingItem) : void
		{
			item.addEventListener(BulkProgressEvent.OPEN    , onOpen);
			item.addEventListener(BulkProgressEvent.COMPLETE, onComplete);
			item.addEventListener(BulkProgressEvent.PROGRESS, onProgress);
			item.addEventListener(BulkProgressEvent.ERROR   , onItemError);
			
			_items.push(item);      
			_workItems.push(item);
			_dictItems[item.name] = item;
			_totalWeight		 += item.weight;
			_itemsTotal++;
		}

		/** 获取指定 URL 的 LoadingItem 实例 */
		public function getLoadingItem(key : String) : LoadingItem
		{
			return LoadingItem(_dictItems[key]);
        }

		public function dispose() : void
		{
			_items.forEach(function(item : LoadingItem, ... rest) : void
			{
				item.removeEventListener(BulkProgressEvent.OPEN    , onOpen);
				item.removeEventListener(BulkProgressEvent.COMPLETE, onComplete);
				item.removeEventListener(BulkProgressEvent.PROGRESS, onProgress);
				item.removeEventListener(BulkProgressEvent.ERROR   , onItemError);
            	item.dispose();
				item = null;
            });
			
			_items    			  = null;
			_dictItems			  = null;
			_workItems 			  = null;
			customTypesExtensions = null;
        }

		public function stop() : void
		{
			_items.forEach(function(item : LoadingItem, ... rest) : void
			{
				if (item.status == LoadingItem.STATUS_WAIT || item.status == LoadingItem.STATUS_STARTED)
				{
					item.stop();
				}
				_currentConnections = 0;
			});
		}
		
		/** 下载项目总数  */
		public function count() : int
		{
			return _itemsTotal;
		}

		/** Private Function **************************************************/

		private function onOpen(e : Event) : void
		{
			var item : LoadingItem		= e.target as LoadingItem;     
			var eOpen:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.OPEN);
			eOpen.item 		 			= item;
			eOpen.bytesLoaded 			= _bytesLoaded;
			eOpen.bytesTotal  			= _bytesTotal;
			eOpen.itemsLoaded 			= _itemsLoaded;
			eOpen.itemsTotal  			= _itemsTotal;
			eOpen.itemsSpeed  			= _itemsSpeed;
			eOpen.weightPercent 		= _weightPercent;
			eOpen.sender				= this;
			
			dispatchEvent(eOpen);
		}

		/** 下载完成事件（itemsLoaded==itemsTotal为所有项下载完成）*/
		private function onComplete(e : Event) : void
		{
			var item : LoadingItem = e.target as LoadingItem;
			
			_itemsLoaded++;
			
			var eComplete:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.COMPLETE);
			eComplete.item 		 			= item;
			eComplete.bytesLoaded 			= _bytesLoaded;
			eComplete.bytesTotal  			= _bytesTotal;
			eComplete.itemsLoaded 			= _itemsLoaded;
			eComplete.itemsTotal  			= _itemsTotal;
			eComplete.itemsSpeed  			= _itemsSpeed;
			eComplete.weightPercent 		= _weightPercent;
			eComplete.sender				= this;
			
			dispatchEvent(eComplete);
			
			if (_itemsLoaded != _itemsTotal)
			{
				this.load();
			}
		}

		/** 项下载出错 */
		private function onItemError(e : ErrorEvent) : void
		{
			this.load();
        	
        	var item : LoadingItem         = e.target as LoadingItem;     
            var eError : BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.ERROR);
            eError.item 		 		   = item;
            eError.bytesLoaded 			   = _bytesLoaded;
            eError.bytesTotal  			   = _bytesTotal;
            eError.itemsLoaded 			   = _itemsLoaded;
            eError.itemsTotal  			   = _itemsTotal;
            eError.itemsSpeed  			   = _itemsSpeed;
            eError.weightPercent 		   = _weightPercent;
            eError.errorMessage   		   = e.text;
			eError.sender				   = this;
			
			trace(this, "onItemError", e.text);
	        dispatchEvent(eError);
        }

		/** 下载进度处理 */
		private function onProgress(e : ProgressEvent) : void
		{
			//dispatchEvent(this.getProgressForItems(e));
		}

		/** 计算下载进度状态 */
		private function getProgressForItems(e : ProgressEvent) : BulkProgressEvent
		{
            _bytesLoaded = _bytesTotal = 0;
            var localWeightPercent     : Number = 0;
            var localWeightLoaded      : Number = 0;							
            var localWeightTotal       : int    = 0;
            var localitemsStarted      : int    = 0;		// 开始下载的对象数		
            var localItemsTotal        : int    = 0;		// 对象总数
            var localItemsLoaded       : int    = 0;		// 已下载完成对象数
            var localBytesLoaded       : int    = 0;		// 已下载字节数
            var localBytesTotal        : int    = 0;		// 字节总数
            var localBytesTotalCurrent : int    = 0; 		// 所有下载对象字节总数
			var localSpeed 			   : Number = 0;
			
			var event:BulkProgressEvent = new BulkProgressEvent(BulkProgressEvent.PROGRESS);
			
			for each (var item : LoadingItem in _items)
			{
				if (!item) continue;
                localItemsTotal++;
                localitemsStarted++;
                localWeightTotal += item.weight;
				if (item.status == LoadingItem.STATUS_STARTED || 		// 下载启动 (LoadingItem.onStartedHandler)
					item.status == LoadingItem.STATUS_FINISHED || 		// 下载完成 (LoadingItem.onCompleteHandler)
                    item.status == LoadingItem.STATUS_STOPPED)			// 下载停止 (LoadingItem.stop())
                {
					// 新加防止网速很快，FALSH API没及时获取到下载文件大小而导致的计算错误    2010.12.17
					if (item.bytesLoaded > item.bytesTotal)
					{
						item.bytesLoaded = item.bytesTotal;
					}
					
                	localSpeed 			   += item.speed;
                    localBytesLoaded       += item.bytesLoaded;
                    localBytesTotalCurrent += item.bytesTotal;
                    localWeightLoaded      += (item.bytesLoaded / item.bytesTotal) * item.weight;
					if (item.status == LoadingItem.STATUS_FINISHED)
					{
						localItemsLoaded++;
					}
					
					event.item = item;
                }
            }

			// 只设置字节总数如果所有的项目已开始加载
			if (localitemsStarted != localItemsTotal)
			{
				localBytesTotal = Number.POSITIVE_INFINITY;
			}
			else
			{
				localBytesTotal = localBytesTotalCurrent;
			}
            localWeightPercent = localWeightLoaded / localWeightTotal; // 所对下载对象的完成总比例
			if (localWeightTotal == 0)
			{
				localWeightPercent = 0;
			}
            
            localSpeed  = localSpeed / (_itemsLoaded + 1);
            _itemsSpeed = localSpeed;
          
            event.itemBytesLoaded 		= e.bytesLoaded;
            event.itemBytesTotal  		= e.bytesTotal;
            event.itemsLoaded	 		= localItemsLoaded;
            event.itemsTotal      		= localItemsTotal;
            event.itemsSpeed      		= localSpeed;
            event.bytesLoaded     		= localBytesLoaded;
            event.bytesTotal      		= localBytesTotal;
            event.weightPercent   		= localWeightPercent;
            return event;
        }

		/** 判断资源文件类型 */
		private function guessType(urlAsString : String) : String
		{
			// 将删除URL的查询字符串
			var searchString : String = urlAsString.indexOf("?") > -1 ? urlAsString.substring(0, urlAsString.indexOf("?")) : urlAsString;                   
            var finalPart    : String = searchString.substring(searchString.lastIndexOf("/"));;
            var extension    : String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
            var type         : String;
			if (!Boolean(extension))
			{
				extension = BulkLoader.TYPE_TEXT;
			}
			if (extension == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_IMAGE;
			}
			else if (extension == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_MOVIECLIP;
			}
			else if (extension == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_SOUND;
			}
			else if (extension == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_VIDEO;
			}
			else if (extension == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(extension) > -1)
			{
				type = BulkLoader.TYPE_XML;
			}
			else
			{
				// 是否为自定义新扩展名 key = asp, value = BulkLoader.TYPE_TEXT
				for (var checkType : String in customTypesExtensions)	
				{
					if (checkType == extension)
					{
						type = customTypesExtensions[checkType];
						break;
					}
				}
				if (!type)
				{
					type = BulkLoader.TYPE_TEXT;
				}
			}
			return type;
		}

		/** Public Variable **************************************************/
		/** 自定义加载地址扩展名 */
		public var customTypesExtensions : Dictionary = new Dictionary();
		
        /** Private Variable **************************************************/
		private var _items       	    : Array      = [];	    			// 加载对象数组
		private var _workItems    	    : Array      = [];					// 正在加载项数据
		private var _dictItems          : Dictionary = new Dictionary();	// 加载对象集合
        private var _maxConnections 	: int    	 = 12;					// 最大下载连接数据默认12个
        private var _currentConnections : int   	 = 0;					// 当前已用连接数
		private var _itemsTotal 		: int    	 = 0;					// 下载项总数
        private var _itemsLoaded 	    : int   	 = 0;					// 下载项完成数
        private var _totalWeight        : int   	 = 0;					// 下载对象总比例系数
        private var _bytesTotal         : int    	 = 0;					// 总下载字段数
        private var _bytesLoaded        : int    	 = 0;					// 当前已下载字段数
        private var _itemsSpeed         : Number 	 = 0;					// 平均下载速度
        private var _weightPercent      : Number	 = 0;					// 总下载比例
		
		/** Public Static **************************************************/
		
		public static const TYPE_BINARY       : String = "binary";
		public static const TYPE_IMAGE        : String = "image";
		public static const TYPE_MOVIECLIP    : String = "movieclip";
		public static const TYPE_SOUND        : String = "sound";
		public static const TYPE_TEXT         : String = "text";
		public static const TYPE_XML          : String = "xml";
		public static const TYPE_VIDEO        : String = "video";
		public static const CAN_BEGIN_PLAYING : String = "canBeginPlaying";
		
        /** 支持的文件扩展名 */
		private static var IMAGE_EXTENSIONS     : Array = ["jpg", "jpeg", "gif", "png"];
		private static var MOVIECLIP_EXTENSIONS : Array = ['swf'];
		private static var TEXT_EXTENSIONS      : Array = ["txt", "js", "php", "aspx", "jsp"];
		private static var VIDEO_EXTENSIONS     : Array = ["flv", "f4v", "f4p", "mp4"];
		private static var SOUND_EXTENSIONS     : Array = ["mp3", "f4a", "f4b"];
		private static var XML_EXTENSIONS       : Array = ["xml"];
    	
        public static var TYPE_CLASSES : Object = 
        {
            image     : ImageItem,
            movieclip : SWFItem,
            xml       : XMLItem,
            video     : VideoItem,
            sound     : SoundItem,
            text      : URLItem,
            binary    : BinaryItem
        };

		public static function truncateNumber(raw : Number, decimals : int = 2) : Number
		{
			var power : int = Math.pow(10, decimals);
			return Math.round(raw * (power)) / power;
		}
	}
}