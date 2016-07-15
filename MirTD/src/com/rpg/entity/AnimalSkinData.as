package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationFrame;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.enum.Constant;
	import com.rpg.framework.loader.ActionAssets;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.framework.system.thread.IThreadProcess;
	import com.rpg.framework.system.thread.ThreadManager;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneCacheManager;
	import com.sh.game.util.ModelName;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	

	public class AnimalSkinData extends AnimationPlayerData implements IThreadProcess
	{
		/** 动画解析完成事件 */		
		public var analyzeComplete : Function;
		protected var _completed : Boolean;
		protected var _isThread  : Boolean;
		protected var _item 	 : AnimalSkinDataClipItem;
		public var totalDir:int = 8;
		//public static var flagcount:int = 0;
		protected var _bshadow:Array = null;
		
		public var interval	   : int;
		public var playCount   : int = AnimationPlayer.LOOP;
		/**
		 * 处理到某一帧 
		 */
		private var _curid:int = 0;
		private var _frameRender:int = 5;
		
		//private var _shadowProcess:Dictionary = new Dictionary();
		
		public var frameSet:Array;
		public var processFrameCount:int = 0;
		protected var _reader:ActionAssets;
		private var _shadows:Array = new Array();
		
		//protected var _items 	 :Dictionary;
		/**
		 *  人物皮肤数据解析
		 * @param model
		 * @param reader
		 * @param action
		 * @param dir
		 * @param sourcename
		 * @param isThread
		 * @param bshadow
		 * @param frameRender
		 * 
		 */
		public function AnimalSkinData(model:String,reader:ActionAssets,action:int,dir:int,sourcename:int,isThread : Boolean = true,bshadow:Array = null)
		{
			super();
			_reader = reader;
			if(!_reader.isNull){
				_frameRender = -1;
				//this._frameRender =  processFrameCount==0?frameNames.length:Math.ceil(frameNames.length/processFrameCount);
				this.frameSet = _reader.data as Array;
			}
			
			this.model = model;
			_isThread = isThread;
			_bshadow = bshadow;
			this.action = action;
			this.dir = dir;
			this.fileName = sourcename;
		//	trace("预计帧处理" + frameRender);
			if(_isThread)
				ThreadManager.instance.add("skinthread", this);
			//flagcount++;
		}
		
		public function get failMaxCount():int{
			return 0;
		}
		
		public function get id() : String
		{
			return fileName + "";
		}
		
		public function get completed() : Boolean
		{
			return _completed;
		}
		
		public function process() : void
		{
			if (frameSet == null || frameSet.length == 0)
			{
				this.dispose();
			}
			else
			{
				if(!this.clip)
					this.createClip(frameSet.length);
				if (analyzeComplete != null)
				{
					analyzeComplete(this);
				}
			}
		}
		
		public override function getClipFrame(index:int):AnimationFrame{
			if(clip){
				this.processFrame(clip,index);
				return clip.frames[index];
			}
			return null;
		}
		
		public override function dispose() : void
		{
			//flagcount--;
			_completed		= true;
			analyzeComplete = null;
			frameSet = null;
			frameSet = null;
			if(_bshadow){
				_bshadow.length = 0;
				_bshadow = null;
			}
			interval = 0;
			totalDir = 0;
			_item = null;
			//_curid = 0;
			if(_isThread)
				ThreadManager.instance.remove("skinthread", this);
			if(_shadows){
				for each (var shadow:ShadowSkinData in _shadows) 
				{
					SceneCacheManager.instance.shadowSkin.removeNow(shadow.fileName);
				}
				_shadows = null;
			}
			/*if(_shadowProcess){
				for each (var data:ShadowSkinData in _shadowProcess) 
				{
					if(data != null){
						data.dispose();
					}
				}
				_shadowProcess = null;
			}*/
			//Component.thread.remove(Component.THREAD_SKIN_ANALYZE, this);
			if(_reader)
				ObjectPoolManager.getInstance().returnItem(Constant.ActionAssetsClass,_reader);
			_reader = null;
			super.dispose();
			//trace("资源总量: " + flagcount);
		}
		
		/** 生成一个动做的所有影片剪辑（针对5方向动画数据有效） */
		protected function createActionClips(action : int,dir:int, data : Array,loop:int) : void
		{
			//_items.push(new AnimalSkinDataClipItem(action, data[0],data[1], data[2], 0));
			this._item = new AnimalSkinDataClipItem(action,data[1],data[0], loop, dir,data[2],data[3]);
			totalDir = data[0];
		}

		/** 生成影片剪辑  */
		protected function createClip(len:int) : void
		{
			// 创建影片剪辑
			var clip : AnimationClip = new AnimationClip(len);
			//clip.name = action + "_" +dir ;
			// 镜像
			if (totalDir == 5 && (dir == 5 || dir == 6 || dir == 7))
			{
				clip.turn = -1;
			}
			else
			{
				clip.turn = 1;
			}
			
			clip.interval  = _item.interval;
			clip.playCount = _item.playCount;
			this.clip = clip;
			
			//this.processFrame( clip);
		}
		
		public function doLoop(param:Object):void
		{
			for each(var func:Function in _bshadow){
				if(func != null)
					func(param);
			}
		}
	
		protected function processFrame( clip : AnimationClip,index:int) : Boolean
		{
			if(this.frameSet.length > index){
				if(_reader)
				{
					var cls:BitmapData = _reader.getClass(index);
					clip.frames[index] = this.createFrame(index,frameSet[index],cls,_item.standX,_item.standY);
					clip.process++;
					if(clip.process >= clip.totalCount){//处理完了
						ObjectPoolManager.getInstance().returnItem(Constant.ActionAssetsClass,_reader);
						_reader = null;
					}
				}
			}
/*			if(_curid >= this.frameNames.length ){
				return true;
			}
			return false;*/
			return true;
		}

	}
}