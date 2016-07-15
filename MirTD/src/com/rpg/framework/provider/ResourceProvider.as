package com.rpg.framework.provider
{
	import com.rpg.framework.IDisposable;
	import com.rpg.framework.collections.DictionaryCollection;

	/** 该ResourceProviderBase类可以扩展到创建ResourceProvider将自动注册的ResourceManager */
	public class ResourceProvider implements IDisposable
	{
		protected var _resources : DictionaryCollection = new DictionaryCollection(); // 资源集合
		
		/** 添加指定资料对象 */
		protected function addResource(res : ContentTypeReader) : void
		{
			_resources.add(res.name, res)
		}
		
		/** 获取指定资料对象 */
		public function getResource(name : String) : ContentTypeReader
		{
			return _resources[name];
		}

		/** 开始加载资料 */
		public function load() : void
		{
			
		}

		public function dispose() : void
		{
			_resources.dispose(); // 经验：如果此处报错，一般为同前对象的 Dispose() 方法被调用了两次，导致 resources 对象已为空了。
			_resources = null;
		}
	}
}
