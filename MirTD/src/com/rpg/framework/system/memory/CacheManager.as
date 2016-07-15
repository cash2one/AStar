package com.rpg.framework.system.memory
{
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.utils.Timer;
	import com.rpg.scene.SceneCacheManager;
	
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.getTimer;
	
	
	

	/** 内存回收管理（内存到指定上限后，每间隔 5分钟回收一次） */
	public class CacheManager extends GameComponent
	{
		private var _timer  : Timer;
		private var _limit  : int;
		private var _caches : Vector.<CacheCollection>;
		private var _currentlyCaches : Vector.<CacheCollection>;
		
		/**
		 * 最后一次gc时间
		 */
		private var _lastGc:int = 0;
		private static var _instance:CacheManager = null;
		private var readyToGC:Boolean = false;
		public var drawShadow:Boolean = true;
		/**
		 * 上次记录的内存
		 */
		public var totalmemory:int;
		
		private var shadowLimit:int = 650 * 1024 * 1024;
		
		public static function get instance():CacheManager{
			if(_instance == null){
				_instance = new CacheManager();
			}
			return _instance;
		}
		
		public function get needShadow():Boolean{
			return totalmemory < shadowLimit && drawShadow; 
		}
		
		/** 内存回收间隔时间 */
		public function get loopTime() : int
		{
			return _timer.distanceTime;
		}
		public function set loopTime(value : int) : void
		{
			_timer.distanceTime = value;
		}
		
		/** 内存回收上限条件 */
		public function get limit() : int
		{
			return _limit;
		}
		public function set limit(value : int) : void
		{
			_limit = value;
		}

		public function CacheManager()
		{
			_timer  = new Timer(1000 * 10);
			_caches = new Vector.<CacheCollection>();
			this.enabled = true;
		}

		public function add(item : CacheCollection) : void
		{
			var index : int = _caches.indexOf(item);
			if (index == -1)
			{
				_caches.push(item);
			}
		}

		private var _counter:int = 0;
		
		/**
		 * 定时监视内存用量，内存总量到  limit 时开始释放没用的内存
		 * @param gameTime 游戏时候
		 *  10秒一次
		 */		
		public override function update(gameTime : GameTime) : void
		{
			if(_timer.heartbeat(gameTime)){
				totalmemory = System.totalMemory;
				if(totalmemory > limit){
					if(_counter % 15){
						readyToGC = true;
						SceneCacheManager.instance.mapskin.clearLimit();
					}
				}
				if(_counter < 30*6)
					_counter++;
				else{
					_counter = 0;
					if (totalmemory > limit )
					{
						_currentlyCaches = _caches.concat();
						for each (var cache : CacheCollection in _currentlyCaches)
						{
							cache.clear();	// 引用计算为 0的数据删除
						}
						
						_currentlyCaches = null;
					}
					return;
				}
				/*if(_counter % 3 == 0){
					//SceneCacheManager.instance.monsterSkin.clear();
					//SceneCacheManager.instance.shadowSkin.clear();
				}else if(_counter % 3 == 1){
				}else if(_counter % 3 == 2){
					SceneCacheManager.instance.mapskin.clearLimit();
				}*/
				
				/*if( gameTime.totalGameTime - _lastGc > 30 * 1000 * 60)
					gc();*/
			}
			
		}
		
		public function clearCache():void{
			_currentlyCaches = _caches.concat();
			for each (var cache : CacheCollection in _currentlyCaches)
			{
				cache.clear();	// 引用计算为 0的数据删除
			}
			_currentlyCaches = null;
			SceneCacheManager.instance.mapskin.clearLimit();
		}

		/** 回收内存 */
		public function gc() : void
		{
			_lastGc = getTimer();
		}
		
		public function timeToGc():void{
			var totalmemory:int = System.totalMemory;
			if(totalmemory > limit){
				readyToGC = true;
			}
			if(readyToGC){
				CacheManager.instance.gc();
				readyToGC = false;
			}
			_counter = 0;
		}
	}
}
