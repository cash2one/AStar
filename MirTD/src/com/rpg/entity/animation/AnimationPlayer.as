/**
 动画数据格式
 使用例子：
 var ap:AnimationPlayer = new AnimationPlayer(Bitmap, IAnimationStrategy);
 ap.play("动画剪辑名");
 addChild(ap);
 
 ap.Update(gameTime);		// 循环更新帧速
 
  更装备
 deleteAnimationClip("Person");
 addAnimationClip("Person",Data);
 setChildByIndex("Person",0);
 
 * 需求：
 * 1.多层动画显示
 * 2.动态添加和删除动画层
 * 3.动画播放停止接口
 * 4.每一帧事件
 * 5.当前动画剪辑播放完事件
 * 6.可动态定义每一帧动画的停留时间（待开发）-难点在时间间隔数据不好生成
 *
 **/
package com.rpg.entity.animation
{
	import com.rpg.entity.GameSprite;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.collections.DictionaryCollection;
	import com.rpg.framework.utils.Timer;
	import com.sh.game.consts.DirectionType;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	

	/** 注：继承Sprite只为在多层画动管理上有个默认的最小画布和程序扩展其它功能方便 */
	/** 多层动画管理组件 */
	public class AnimationPlayer extends GameSprite
	{		
		public static const  DefaultModel1  : String = "1";   //默认资源名
		public static const  DefaultModel0  : String = "0";   //默认资源名
		public static const LOOP   : int = -1;								// 无限循环
		public static const SINGLE : int = 1;								// 播放一次
		
		protected var _animationArgs      : AnimationEventArgs;				// 事件参数据
		protected var _animation          : Dictionary;			// 动画数组（Bitmap)
		protected var _dataList 		  : Dictionary;						// 动画数据列表
		protected var _playMaxCount		  : int;							// 最大已播放次数
		protected var _timer      		  : Timer;							// 动画播放速度控制
		public var inView:Boolean = false;  //是否在视野中
		protected var _playCount		   	  : int;							// 已播放次数
		private var _currentAnimationClip : Dictionary;						// 当前播放的动画剪辑数组
		protected var _randomFrame:Boolean; // 随机起始帧
		
		protected var _currentActionType : int = ActionType.STAND;			// 人物当前动做类型
		protected var _currentDirection  : int    = DirectionType.NONE;// 人物当前次方向
		protected var _changedIntval:int = 0;
		
		protected var _pause:Boolean = false;
		/**
		 *手动设置过播放次数的，不自动设置播放次数 
		 */
		protected var _changedPlayCount:Boolean = false;
		private var replayed:Boolean = true;
		protected  var option:Object;
		
		protected var _lastIndex:int = 0;
		
		/**
		 * 加入后直接播放最后一帧 
		 */
		protected var _playEnd:Boolean = false;
		
		/** 每秒多少帧（默认24帧）*/
		public function AnimationPlayer(playMaxCount : int = LOOP)
		{
			_playMaxCount 		  = playMaxCount;
			_animation   		  = new Dictionary();
			_dataList    		  = new Dictionary();
			_currentAnimationClip = new Dictionary();
			_animationArgs 		  = new AnimationEventArgs();
			_timer  			  = new Timer();
		}

		public function set playMaxCount(value:int):void
		{
			_playMaxCount = value;
			_changedPlayCount = true;
		}

		/** 添加动画剪辑 */
		public function addAnimationClip( clipType : String) : void
		{
			if(!_animation.hasOwnProperty(clipType))
				_animation[clipType] = new Bitmap();
		}
		
		/** 删除动画剪辑 */
		public function deleteAnimationClip(clipType : String ) : void
		{
			if(_animation[clipType] && _animation[clipType].parent){
				_animation[clipType].parent.removeChild(_animation[clipType]);
			}
			delete _animation[clipType];
			delete _currentAnimationClip[clipType];
		}
		
		public function removeType(clipType : String):void{
			if(_animation[clipType] && _animation[clipType].parent){
				_animation[clipType].parent.removeChild(_animation[clipType]);
			}
			delete _animation[clipType];
			if(_dataList[clipType]){
				var sets:AnimationPlayerDataSet = _dataList[clipType];
				sets.dispose();
				delete _dataList[clipType];
			}
			delete _currentAnimationClip[clipType];
		}
		
		/** 设置子索引 */
		public function setChildByIndex(clipType : String , index : int = 0) : void
		{
			this.display.addChildAt(_animation[clipType], index);
			/*if (this.enabled)
			{
				if(play)
					this.play(_currentActionType,_currentDirection,false); // 经验：考虑是否每次调用些方些要运行play方法
				else
					this.addAnimToView(clipType,_currentActionType,_currentDirection);
			}*/
		}

		/** 通过对象名获取子动画层可视对象 */
		public function getChildByName(clipType : String ) : DisplayObject
		{
			if (_animation[clipType] != null)
			{
				return _animation[clipType];
			}
			return null;
		}
		
		protected function getData(clipType:String,action:int,dir:int):AnimationPlayerData{
			var dataset  : AnimationPlayerDataSet;
			var clip : AnimationClip;
			dataset = _dataList[clipType];
			if (dataset )
			{
				return dataset.getData(action,dir);
			}
			return null;
		}

		public function getDataSets(clipType:String):AnimationPlayerDataSet{
			if(_dataList == null)
				return null;
			return this._dataList[clipType];
		}
		
		public function addAnimToView(clipType : String,action:int,dir:int):void{
			var dataset  : AnimationPlayerDataSet;
			var clip : AnimationClip;
			dataset = _dataList[clipType];
			if (dataset )
			{
				var data:AnimationPlayerData = dataset.getData(action,dir);
				if(data && data.clip != null ){
					clip = data.clip;
					if (clip)
					{
						if (clip.frames.length > 1)		 // 当前选中剪辑帧数是否大于1才加入到动画插入列表中
						{
							_currentAnimationClip[clipType] = data;
						}
						else if (clip.frames.length == 1) 	 // 单帧剪辑动画
						{
							this.setSingleFrame(clipType, 0);
						}
					}
				}
			}
		}
		
		/** 播放指定名称的动画剪辑 */
		public function play(action:int,dir:int, isLostFrame : Boolean = true) : void
		{
			_playCount			    = 0;
			if(_randomFrame){
				_animationArgs.clipFrameIndex = Math.random() * _animationArgs.clipTotalFrameCount;
			}else if(this._playEnd){
				_animationArgs.clipFrameIndex = Math.max(0,_animationArgs.clipTotalFrameCount - 1);
			}else if(isLostFrame){
				_animationArgs.clipFrameIndex = 0;
			}
			else if(_animationArgs.clipFrameIndex > _animationArgs.clipTotalFrameCount)
			{
				_animationArgs.clipFrameIndex = _animationArgs.clipTotalFrameCount;
			}
			else if(_lastIndex!=0&&_lastIndex < _animationArgs.clipTotalFrameCount-1&&_animationArgs.clipAction  == action)
			{
				_animationArgs.clipFrameIndex = _lastIndex;
			}
			if(_animationArgs.clipDir  != dir&&_animationArgs.clipAction  == action)
			{
				_animationArgs.clipFrameIndex = _lastIndex;
			}
			
			_animationArgs.clipAction = action;
			_animationArgs.clipDir = dir;
			
			if(!this.inView)
				return;
			var dataset  : AnimationPlayerDataSet;
			var clip : AnimationClip;
			for (var clipType : String in _dataList)
			{
				dataset = _dataList[clipType];
				if (dataset )
				{
					var data:AnimationPlayerData = dataset.getData(action,dir);
					if(data && data.clip != null ){
						clip = data.clip;
						if (clip)
						{
							_animationArgs.clipTotalFrameCount = clip.frames.length;
							if (clip.frames.length > 1)		 // 当前选中剪辑帧数是否大于1才加入到动画插入列表中
							{
								_currentAnimationClip[clipType] = data;
							}
							else if (clip.frames.length == 1) 	 // 单帧剪辑动画
							{
								this.setSingleFrame(clipType, 0);
							}
						}
					}else{//没有资源，去缓存取，缓存没有就去下载！
						loadSkin(clipType,action,dataset.getDir(action,_currentDirection));
					}
				}
			}
//			if(_randomFrame){
//				_animationArgs.clipFrameIndex = Math.random() * _animationArgs.clipTotalFrameCount;
//			}else if(isLostFrame){
//				_animationArgs.clipFrameIndex = 0;
//			}else{
//				if(_animationArgs.clipFrameIndex > _animationArgs.clipTotalFrameCount)
//					_animationArgs.clipFrameIndex = _animationArgs.clipTotalFrameCount;
//			}
			
			
			if (clip)
			{
				if(_changedIntval > 0)
					_timer.distanceTime = _changedIntval;
				else
					_timer.distanceTime = clip.interval;
				if(!_changedPlayCount)
					_playMaxCount       = clip.playCount;
			}
			
			// 当前选中剪辑中有数据则开始播放动画
			if (_animationArgs.clipTotalFrameCount > 0)
			{
				this.setMultipleFrame(_animationArgs.clipFrameIndex);
				this.playFrame(_animationArgs);
				this.enabled = true;
			}
			else
			{
				this.enabled = false;
			}
		}

		protected function loadSkin(clipType:String,action:int,dir:int):void
		{
			
		}
		
		/** 暂停动画 */
		public function set pause(value:Boolean) :void
		{
				this._pause = value;
		}

		/** 设置多帧显示 */
		protected function setMultipleFrame(index : int) : void
		{
			for (var clipType : String in _currentAnimationClip)
			{
				this.setSingleFrame(clipType, index);
			}
		}
		
		/** 重新播放 */
		public function replay():void{
			for (var clipType : String in _currentAnimationClip)
			{
				this.setSingleFrame(clipType, 0);
			}
			if(_animationArgs)
				_animationArgs.clipFrameIndex = 0;
		}
		
		/**
		 * 设置动画Y坐标 
		 * @param clipType
		 * @param y
		 */
		protected function setAnimalSkinY(clipType : String,bitmap:Bitmap,y:int):void{
			bitmap.y 		    = y;
		}
		
		/** 设置单帧显示 */
		protected function setSingleFrame(clipType : String, index : int) : void
		{
			// 经验:不用currentAnimationClip而用dataList取值，是因为在添加一个新动画层时，
			//      有可能还没在currentAnimationClip中初始化而语对象为空的错。（即 update不同步）
			var data : AnimationPlayerData;
			var dataset  : AnimationPlayerDataSet;
			dataset = _dataList[clipType];
			if (dataset )
			{
				data  =dataset.getDataAndTurn(_currentActionType,_currentDirection);
			}
			if(data && data.clip)
			{
				var clip   : AnimationClip		= data.clip;
				if(clip.frames.length > index){
					var frame  : AnimationFrame     = clip.frames[index];
					if(frame == null)
						frame = data.getClipFrame(index);
					if(frame != null){
						if(clipType != ElementSkinType.SHADOW){
							var scaleX : int 				= dataset.turn;
							_animation[clipType].scaleX	    = scaleX;
							_animation[clipType].x 	        = scaleX * frame.x;
						}else
							_animation[clipType].x 	        = frame.x;
						
						setAnimalSkinY(clipType,this._animation[clipType],frame.y);
						_animation[clipType].bitmapData = frame.data;
					}else{
						_animation[clipType].bitmapData = null;
					}
				}
				if(data.soundurl!=""&&data.soundframe == index&&replayed)
				{
					replayed = false;
				}
				
			}
			_lastIndex = index;
		}

		/** 动画帧更新新 */
		public override function update(gameTime : GameTime) : void
		{
			var count:int = _timer.heartbeat(gameTime);
			if (!_pause && count > 0)
			{
				if ((_playMaxCount == LOOP || _playCount < _playMaxCount))
				{
					// 当前影片剪辑动画指针递增
					_animationArgs.clipFrameIndex += count;
	
					// 判断是否进去下一个动画循环
					if (_animationArgs.clipFrameIndex >= _animationArgs.clipTotalFrameCount)
					{
						_animationArgs.clipFrameIndex = 0;
						_playCount++;
						this.playComplete(_animationArgs);
						replayed = true;
					}
					if (_playMaxCount == LOOP || _playCount < _playMaxCount)
					{
						this.setMultipleFrame(_animationArgs.clipFrameIndex);
						//trace(_animationArgs.clipFrameIndex);
						
						this.playFrame(_animationArgs);
					}
					else
					{
						this.enabled = false;
					}
				}
			}
		}

		public override function dispose() : void
		{
			option = null;
			_animationArgs  	  = null;
			_currentAnimationClip = null;
			if(_dataList != null){
				for each (var i:AnimationPlayerDataSet in _dataList) 
				{
					i.dispose();
				}
			}
			_dataList			  = null;	// 注：在此不可以直接删除动画数据源，因为有的数据要缓存起来，所以只删除引用。			
			if(_animation){
				for (var key:String in _animation) 
				{
					if(_animation[key] != null){
						if(_animation[key].parent){
							_animation[key].parent.removeChild(_animation[key]);
						}
						if(_animation[key].bitmapData)
							_animation[key].bitmapData = null;
						_animation[key] = null;
						delete _animation[key];
					}
				}
				//_animation.dispose();
				_animation = null;
			}
			this._timer = null;
			super.dispose();
		}

		/**
		 * 每一帧事件
		 *
		 */
		protected function playFrame(e : AnimationEventArgs) : void
		{

		}

		/**
		 * 播放完成一次动画事件
		 *
		 */
		protected function playComplete(e : AnimationEventArgs) : void
		{

		}
	}
}