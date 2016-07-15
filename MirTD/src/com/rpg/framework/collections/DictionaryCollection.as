package com.rpg.framework.collections
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.utils.*;
	

	public class DictionaryCollection extends Proxy implements IDisposable
	{
		private var _weakKeys : Boolean;
		private var _items    : Dictionary;
		private var _keys  	  : Array;

		public function DictionaryCollection(weakKeys : Boolean = false)
		{
			_weakKeys = weakKeys;
			_items    = new Dictionary(_weakKeys);
			_keys     = [];
		}

		public function add(key : *, item : *) : void
		{
			_items[key] = item;
			if (_keys.indexOf(key) == -1)
			{
				_keys.push(key);
			}
		}

		/**
		 * 删除字典资源 
		 * @param key			键值
		 * @param isDispose		是否释放资源对象
		 * @return 
		 * 
		 */		
		public function remove(key : *, isDispose : Boolean = true) : Boolean
		{
			if (_items[key] != null)
			{
				if (isDispose)
				{
					if (_items[key] is IDisposable)
					{
						IDisposable(_items[key]).dispose();
					}
					else if (_items[key] is DisplayObject)
					{
						if (_items[key].parent != null)
						{
							_items[key].parent.removeChild(_items[key]);
						}
					}
				}
				var index : int = _keys.indexOf(key);
				if (index > -1)
				{
					_keys.splice(index, 1);
				}
				delete _items[key];
				return true;
			}
			return false;
		}

		public function clear(isDispose : Boolean = true) : void
		{
			var length:int = _keys.length;
			while (length > 0)
			{
				length--;
				remove(_keys[length], isDispose);
			}
		}

		public function get length() : uint
		{
			return _keys.length;
		}

		public function dispose() : void
		{
			this.clear();
			_items = null;
			_keys = null;
		}

		//--------------------------------------------------//

		override flash_proxy function callProperty(methodName : *, ... args) : *
		{
			var res : *;
			switch (methodName.toString())
			{
				default:
					res = _items[methodName].apply(_items, args);
					break;
			}
			return res;
		}

		override flash_proxy function getProperty(name : *) : *
		{
			return _items[name];
		}

		override flash_proxy function setProperty(name : *, value : *) : void
		{
			throw new Error("function is not available");
		}

		override flash_proxy function deleteProperty(name : *) : Boolean
		{
			throw new Error("function is not available");
		}

		override flash_proxy function hasProperty(name : *) : Boolean
		{
			return name in _items;
		}

		override flash_proxy function nextNameIndex(index : int) : int
		{
			if (index < _keys.length)
			{
				return index + 1;
			}
			return 0;
		}

		override flash_proxy function nextName(index : int) : String
		{
			return _keys[index - 1];
		}

		override flash_proxy function nextValue(index : int) : *
		{
			return _items[_keys[index - 1]];
		}
	}
}
