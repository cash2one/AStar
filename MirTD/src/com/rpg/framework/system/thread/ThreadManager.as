/**
 * 设计思想：
 * 1、模拟 CPU 时间片分配原理，在 update时间有空于时分配给其他复杂逻辑处理时间，以避免一次性处理复杂逻辑导到致游戏画出卡。
 * 2、在便用线程对列时，要注意公共数据要以全局唯一对象去使用，否则容易出错对象引用错乱而导致的逻辑错误。
 */
package com.rpg.framework.system.thread
{
	import com.rpg.framework.GameComponent;
	import com.rpg.framework.GameTime;
	
	import flash.utils.Dictionary;
	
	
	public class ThreadManager extends GameComponent
	{
		private static const SECONDS_ONE 		 : Number = 1000.00;		// 一秒的浮点表示
		private static const SECURITY_FRAMERATE  : int	  = 2;			// 安全帧数
		private static const MAX_TAILURE_PROCESS : int    =3;				// 最大失败处理数
		
		private var _interval         : int;								// 每帧间隔时间
		private var _securityInterval : int;								// 安全每帧间隔时间
		private var _tailureProcess   : int;								// 失败处理次数
		private var _ids		      : Dictionary;							// 线程编号字典
		private var _dictType		  : Dictionary;
		private var _threadList       : Vector.<Vector.<IThreadProcess>>;
		private var _flag			  : Boolean;
		private var _typeSort:Vector.<String>;
		
		public function ThreadManager()
		{
			this.enabled = true;
		}
		
		private static var _instance:ThreadManager = null;
		
		public static function get instance():ThreadManager{
			if(_instance == null){
				_instance = new ThreadManager();
			}
			return _instance;
		}

		public function init(fps:int):void{
			_ids              = new Dictionary();
			_dictType		  = new Dictionary();
			_typeSort = new Vector.<String>();
			_threadList		  = new Vector.<Vector.<IThreadProcess>>();
			_interval    	  = Math.round(SECONDS_ONE / fps);
			_securityInterval = _interval + SECURITY_FRAMERATE;
		}
		
		public function set fps(value:int):void{
			_interval    	  = Math.round(SECONDS_ONE / value);
			_securityInterval = _interval + SECURITY_FRAMERATE;
		}
		
		public function addDict(key : String) : void
		{
			if (_dictType[key] == null)
			{
				_dictType[key] = new Vector.<IThreadProcess>();
				_threadList.push(_dictType[key]);
				_typeSort.push(key);
			}
		}

		public override function update(gameTime : GameTime) : void
		{
			process(gameTime);
			/*process(gameTime);
			process(gameTime);
			process(gameTime);
			process(gameTime);
			process(gameTime);*/
		}
		
		private function process(gameTime : GameTime):void{
			for each(var key : String in _typeSort)
			{
				if (_dictType[key].length > 0)
				{
					var item : IThreadProcess = _dictType[key][0];
					if (gameTime.elapsedGameTime < _securityInterval)
					{
						_ids[key + item.id] = true;
						item.process();
						if (item.completed)
						{
							this.remove(key, item);
						}
					}
					else if (_tailureProcess > MAX_TAILURE_PROCESS)
					{
						_ids[key + item.id] = true;
						while (true)
						{
							item.process();
							if (item.completed)
							{
								_tailureProcess = 0;
								this.remove(key, item);
								break;
							}
						}
					}
					else
					{
						_tailureProcess++;
					}
					break;
				}
				
			}
			
			for each (var thread : Vector.<IThreadProcess> in _threadList)
			{
				if (thread.length > 0)
				{
					_flag = true;
					break;
				}
				else
				{
					_flag = false;
				}
			}
			this.enabled = _flag;
		}

		public function add(key : String, item : IThreadProcess) : void
		{
			var combinationKey : String = key + item.id;
			if (_ids[combinationKey] == null)
			{
				_ids[combinationKey] = false;
				_dictType[key].push(item);
				this.enabled = true
			}
			else
			{
				//Logger.log(  "线程对列中不可以添加重复对象");
			}
		}

		public function remove(key : String, item : IThreadProcess) : void
		{
			var combinationKey : String = key + item.id;
			if (_ids[combinationKey] != null)
			{
				delete _ids[combinationKey];
				var index : int = _dictType[key].indexOf(item);
				if (index > -1)
				{
					_dictType[key].splice(index, 1);
				}
			}
		}
	}
}