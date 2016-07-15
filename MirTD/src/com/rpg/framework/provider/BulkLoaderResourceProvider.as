package com.rpg.framework.provider
{
	import com.rpg.framework.loading.BulkLoader;
	import com.rpg.framework.loading.BulkProgressEvent;

    /** HTTP方式大型文件批量下载模板 */
	public class BulkLoaderResourceProvider extends ResourceProvider
	{
		public var loadSingleComplete : Function;
		public var loadComplete       : Function;
		public var loadProgress		  : Function;
		public var loadError		  : Function;
		protected var _download   : BulkLoader;
		private var _itemsErrored : uint = 0;
		private var _itemsLoaded  : uint = 0;
		private var _itemsTotal   : uint = 0;

		/**
		 * 创建一个BulkLoader资源读取器(registerAsProvider为true为自动注册当前读取器)
		 * game 						游戏主体
		 * Connections					下载资源并行连接数
		 * registerResourceProviders 	是否自动注册到资料管理器中 － ContentManager
		 **/
		public function BulkLoaderResourceProvider(connectionCount : int = 1)	// , isLocal : Boolean = false
		{
//			_download = new BulkLoader(connectionCount, isLocal);
			_download = new BulkLoader(connectionCount);
			_download.addEventListener(BulkProgressEvent.OPEN    , onOpen);
			_download.addEventListener(BulkProgressEvent.PROGRESS, onBulkProgress);
			_download.addEventListener(BulkProgressEvent.COMPLETE, onBulkComplete);
			_download.addEventListener(BulkProgressEvent.ERROR   , onBulkError);
		}

		public function add(url : String, name : String = null, preventCache : Boolean = false, weight : int = 1) : void
		{
			_download.add(url, name, preventCache, weight);
		}

		public override function load() : void
		{
			if (_download.count() > 0)
			{
				_download.load();
				super.load();
			}
			else
			{
				if (loadComplete != null)
				{
					loadComplete();
				}
			}
		}

		/** 下载开始事件 */
		protected function onOpen(e : BulkProgressEvent) : void
		{
			
		}

		/** 下载进度事件 */
		protected function onBulkProgress(e : BulkProgressEvent) : void
		{
			if (loadProgress != null)
			{
				loadProgress(e);
			}
		}

		/** 下载项完成事件 */
		protected function onBulkComplete(e : BulkProgressEvent) : void
		{
			// 添加下载的资源到此资源提供器的集合中
			var res : ContentTypeReader = new ContentTypeReader();
	    	res.name			 	    = e.item.name;
	    	res.content                 = e.item.content;
			addResource(res);

			if (loadSingleComplete != null) loadSingleComplete(res);
        	
        	this.bulkCompleteAll(e);
	    }

		/** 所有下载项完成事件 */
		protected function onBulkCompleteAll() : void
		{
			if (loadComplete != null)
			{
				loadComplete();
			}
		}

		/** 下载出错事件 */
		protected function onBulkError(e : BulkProgressEvent) : void
		{
			_itemsErrored++;
			
			if (loadError != null)
			{
				loadError(e);
			}
			
			this.bulkCompleteAll(e);
		}

		private function bulkCompleteAll(e : BulkProgressEvent) : void
		{
			_itemsLoaded = e.itemsLoaded;
			_itemsTotal  = e.itemsTotal;

			if (_itemsTotal == _itemsLoaded + _itemsErrored) // 成功和错误下载项和加载项总数一致时也会抛出加载全完成事件
			{
				this.onBulkCompleteAll();
			}
		}
		
		public override function dispose() : void
		{
			if (_download)
			{
				_download.removeEventListener(BulkProgressEvent.PROGRESS, onBulkProgress);
				_download.removeEventListener(BulkProgressEvent.COMPLETE, onBulkComplete);
				_download.removeEventListener(BulkProgressEvent.ERROR   , onBulkError);
				_download.dispose();
				_download = null;
				super.dispose();
			}
			loadSingleComplete = null;
			loadProgress       = null;
			loadComplete 	   = null;
			loadError		   = null;
		}
	}
}