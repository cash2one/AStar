/**
 * 设计思想
 * 1、数据缓存功能会对每个对象做一个引用计数据，在 remove时，判断引用计数为 0时在释放缓存数据的内存。
 * 2、可以继承此类重写 removeStrategy方式去自定义删除缓存项的条件。
 * 3、可设计一个定时器在固定间隔时间去检查有哪些数据是可以从缓冲区删除的。
 * 4、在使用引用计数时要调用 addReference方法才会对指定缓存数据计数据。
 * 5、在使用时要注意灵活的使用 addReference以管理在数据指定条件下释放内存。
 * 6、如果程序中有内存泄漏时，考虑在 remove方法中输出 key和引用计数 reference
 */
package com.rpg.framework.system.memory
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	
	public class CacheCollection
	{
		private var _items : Dictionary;
		private var _keys  : Array;
		public var cacheMax:int = -1;
		public function CacheCollection()
		{
			_items = new Dictionary();
			_keys  = [];
		}
		
		public function get length():int{
			if(_keys)
				return _keys.length;
			else
				return 0;
		}
		
		/**
		 * 添加对象的引用计数
		 * @param key	唯一键值
		 * @return 		数据是否存在且引用计数添加成功
		 */
		public function addReference(key : *) : Boolean
		{
			if (_items[key] != null)
			{
				_items[key].reference++;
				return true;
			}
			return false;
		}

		/**
		 * 删除引用计数
		 * @param key 资源唯一键值
		 * @return 数据是否存在且引用计数删除成功
		 *
		 */
		public function removeReference(key : *,clear:Boolean = false) : int
		{
			if (_items[key] != null)
			{
				_items[key].reference--;
				if(clear)
					remove(key);
				/*if(Config.debug && _items[key].reference < 0)
					throw new Error("请务必把报错发出来给程序:  " + key + "   -  " + _items[key].reference);*/
				if(_items[key].reference <= 0)
					return 1;
				return 0;
			}
			return -1;
		}

		/**
		 * 获取数据
		 * @param key   资源唯一键值
		 * @return 		缓存数据
		 */
		public function getData(key : *) : *
		{
			if (_items[key] != null)
			{
				return _items[key].data;
			}
			return null;
		}

		/**
		 * 获取item
		 * @param key   资源唯一键值
		 * @return 		缓存数据
		 */
		public function getItem(key : *) : *
		{
			if (_items[key] != null)
			{
				return _items[key];
			}
			return null;
		}
		
		/**
		 * 添加缓存数据
		 * @param key   资源唯一键值
		 * @param data	缓存数据
		 */
		public function add(key : *, data : *) : Object
		{
			if(key in _items)
			{
				if(_items[key]){
					/*if(Config.Log > LogType.ERROR)
						Logger.log("重复资源"+ key,LogType.ERROR);*/
					return _items[key].data;
				}
			}
			var item : CacheItem = new CacheItem();
			item.data 			 = data;
			_items[key]			 = item;
			_keys.push(key);
			return null;
		}

		public function removeNow(key : *):void{
			if (_items[key] != null)
			{
				if (_items[key].data is IDisposable)
				{
					_items[key].data.dispose();
				}else if(_items[key].data is BitmapData){
					_items[key].data.dispose();
				}
				delete _items[key];
				var index : int = _keys.indexOf(key);
				if (index > -1)
				{
					_keys.splice(index, 1);
				}
			}
		}
			
		
		/**
		 * 删除缓存数据
		 * @param key   资源唯一键值
		 */
		public function remove(key : *) :Boolean
		{
			if (_items[key] != null)
			{
				if (removeStrategy(_items[key]))
				{
					if (_items[key].data is IDisposable)
					{
						_items[key].data.dispose();
					}else if(_items[key].data is BitmapData){
						_items[key].data.dispose();
					}
					delete _items[key];
					var index : int = _keys.indexOf(key);
					if (index > -1)
					{
						_keys.splice(index, 1);
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 删除缓存项策略（默认引用数小于一，且内存到一定上限后在删除。）
		 * @param item 缓存项
		 * @return 是否可以删除
		 *
		 */
		protected function removeStrategy(item : CacheItem) : Boolean
		{
			return item.reference < 1;
			//return true;
		}
		
		/** 删除所有缓存项  */		
		public function clear():void
		{
			var len:int = _keys.length;
			var i:int = 0;
			while(len > 0){
				if(!this.remove(_keys[i])){
					i++;
				}
				len--;
			}
		}
		
		public function clearLimit():void{
			if(cacheMax >= 0 && _keys.length > cacheMax){
				var len:int = _keys.length;
				var overflow:int = len - cacheMax;
				var i:int  = 0,j:int = 0;
				while(overflow > 0 && i < len){
					if(this.remove(_keys[j])){
						overflow--;
					}else{
						j++;
					}
					i++;
				}
			}
		}
		
		public function getKeys():String{
			return this._keys.toString();
		}
	}
}
class CacheItem
{
	public var reference : int;		// 引用计数
	public var data		 : Object;  // 缓冲项
}