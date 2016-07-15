package com.rpg.scene.actor.skin
{
	import com.rpg.entity.AnimalSkinDataClipItem;
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.enum.SkinConfig;
	import com.rpg.framework.loader.ActionAssets;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 *  默认人物动画资源
	 * @author mtw
	 */
	public class DefaultRoleSkinData extends AnimationPlayerData
	{
		protected var _completed : Boolean;
		protected var _isThread  : Boolean;
		protected var _item 	 : AnimalSkinDataClipItem;
		public var totalDir:int = 8;
		private var _domain:ApplicationDomain;
		private var _xml:XML;
		public var frameSet:Dictionary;
		public var frameNames:Array;
		public function DefaultRoleSkinData(model:String,action:int,dir:int,domain:ApplicationDomain,xml:XML)
		{
			super();
			this.model = model;
			this.action = action;
			this._xml = xml;
			this._domain = domain;
			this.dir = dir;
			this.frameSet = new Dictionary;
			this.frameNames = [];
			for each(var subtexture:Object in _xml.children()){
				var name:String = new String(subtexture.@name);
				frameNames.push(name);
				frameSet[name] = {
					x:int(subtexture.@x),
					y:int(subtexture.@y),
					w:int(subtexture.@width),
					h:int(subtexture.@height),
					fx:int(subtexture.@frameX),
					fy:int(subtexture.@frameY),
					fw:int(subtexture.@frameWidth) == 0?int(subtexture.@width):int(subtexture.@frameWidth) ,
						fh:int(subtexture.@frameHeight) == 0?int(subtexture.@height):int(subtexture.@frameHeight) 
				};
			}
			frameNames.sort();
			var _action:Dictionary = SkinConfig.getPlayer();
			this.createActionClips(action      , dir,_action[action],SkinConfig.getLoop(action));
			createClip();
		}
		
		/** 生成一个动做的所有影片剪辑（针对5方向动画数据有效） */
		protected function createActionClips(action : int,dir:int, data : Array,loop:int) : void
		{
			//_items.push(new AnimalSkinDataClipItem(action, data[0],data[1], data[2], 0));
			this._item = new AnimalSkinDataClipItem(action,data[1],data[0], loop, dir,data[2],data[3]);
			totalDir = data[0];
		}
		
		/** 生成影片剪辑  */
		protected function createClip() : void
		{
			// 创建影片剪辑
			var clip : AnimationClip = new AnimationClip();
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
			
			
			this.processFrame( clip);
		}
		
		/**
		 * 获取类定义
		 * @return
		 */
		public function getClass(className : String) : Class
		{
			var cla : Class;
			if (_domain.hasDefinition(className))
			{
				cla = _domain.getDefinition(className) as Class;
			}
			return cla;
		}
		
		protected function processFrame( clip : AnimationClip) : void
		{
			var ret:Vector.<Object> = new Vector.<Object>;
			for (var i:int = 0; i < frameNames.length; i++) 
			{
				var name:String = frameNames[i];
				var cls:Class = getClass(name);
				clip.frames.push(this.createFrame(i,frameSet[name],(new cls) as BitmapData,_item.standX,_item.standY));
			}
			this.clip = clip;
		}
	}
}