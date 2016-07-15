package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationFrame;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.framework.system.thread.IThreadProcess;
	import com.rpg.framework.system.thread.ThreadManager;
	import com.sh.game.util.ModelName;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import util.FilterSet;
	
	public class ShadowSkinData extends AnimationPlayerData implements IThreadProcess
	{
		
		/** 动画解析完成事件 */		
		public var analyzeComplete : Function;
		protected var _completed : Boolean;
		protected var _isThread  : Boolean;
		//protected var _items 	 : Vector.<AnimalSkinDataClipItem>;
		protected var _item 	 : AnimalSkinDataClipItem;
		public var totalDir:int = 8;
		protected var _bturn   :Boolean;
		public var interval	   : int;
		public var playCount   : int = AnimationPlayer.LOOP;
		protected var _parent:AnimalSkinData;
		//private static var sprite:Shape = new Shape();
		public var frameSet:Dictionary;
		public var frameNames:Array;
		public var processFrameCount:int = 0;
		private var _processCount:int = 0;
		public static var frameProcess:int = 0;
		public static var frameMax:int = 2;
		
		public function ShadowSkinData(model:String,frameSet:Dictionary,frameNames:Array,processFrameCount:int,action:int,dir:int,isThread : Boolean = false,item:AnimalSkinDataClipItem = null,data:AnimalSkinData = null,bturn:Boolean = false)
		{
			super();
			this.frameNames = frameNames;
			this.processFrameCount = processFrameCount;
			this.frameSet = frameSet;
			this.model = model;
			this.fileName = ModelName.getSource(model ,action ,dir) ;
			_isThread = isThread;
			_item     = item;
			_parent     = data;
			_bturn   = bturn;
			this.action = action;
			this.dir = dir;
			//ThreadManager.instance.add("shadowthread", this);
		}
		
		public function get failMaxCount():int{
			return 0;
		}
		
		public function get id():String
		{
			return fileName + "";
		}
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function process():void
		{
			if (frameNames == null || frameNames.length == 0)
			{
				this.dispose();
			}
			else
			{
				if(!this.clip)
					this.createClip(frameNames.length);
				if (analyzeComplete != null)
				{
					analyzeComplete(this);
				}
				/*if(_processCount <= 10){
					_processCount++;
					return;
				}
				_processCount = 0;*/
				/*if(this.processFrame(this.clip)){
					_completed = true;
					
					if (analyzeComplete != null)
					{
						analyzeComplete(this);
					}
				}*/
			}
				
		}
		public override function dispose() : void
		{
			_completed		= true;
			analyzeComplete = null;
			frameSet = null;
			frameNames = null;
			processFrameCount = 0;
			//ThreadManager.instance.remove("shadowthread", this);
			super.dispose();
		}
		/** 生成影片剪辑  */
		protected function createClip(len:int ) : void
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
		
		private var _curid:int = 0;
		
		protected function processFrame( clip : AnimationClip,index:int) :Boolean
		{
			if(frameProcess < frameMax){
				if(this.frameNames.length > index){
					var name:String = frameNames[index];
					var o:Object = frameSet[name];
					var angle:Number = 30*Math.PI/180;
					var newangle:Number = Math.tan(angle);
					var addw:int = 0;
					addw = (o.h+o.y-_item.standY)*newangle;
					var standX:int = _item.standX;
					var standY:int = _item.standY;
					if(_bturn){
						standX = standX - (standX-(o.x+o.w/2))*2
					}
					var frame  : AnimationFrame     = this._parent.clip.frames[index];
					if(frame == null)
						frame = _parent.getClipFrame(index);
					if(frame != null)
						clip.frames[index] = this.createFrame(index,o, createFrameShadow(frame.data,frameSet[name]),standX+addw,_item.standY+(o.h+o.y-standY)*.4+4);
					frameProcess++;
					return true;
				}
			}
			return false;
			/*if(index >= this.frameNames.length ){
				return true;
			}
			return false;*/
		}
		
		private static const trans:ColorTransform = new ColorTransform(0,0,0,0.6);
		
		private function createFrameShadow(bmd:BitmapData,o:Object):BitmapData{
			//var bitmapdata1:BitmapData = new BitmapData(o.w , o.h, true, 0xFFFFFF);
			
			/*var matrix:Matrix
			matrix = new Matrix();
			matrix.createGradientBox(o.w, o.h, Math.PI *3.0 / 2.0);
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000, 0x000000], [0.7, 0.7, 0.6, 0.4], [0, 64, 128, 255], matrix);
			sprite.graphics.drawRect(0, 0, o.w , o.h);
			sprite.graphics.endFill();
			bitmapdata1.draw(sprite);
			sprite.graphics.clear();
			var bitmapdata2:BitmapData = new BitmapData(o.w,o.h,true,0);			
			bitmapdata2.copyPixels(bitmapdata1, new Rectangle(0,0,o.w,o.h), new Point(0, 0), bmd,new Point(0,0),true);*/
			var mat :Matrix;
			//var obj:Object = ObjectUtil.clone(o);
			var angle:Number = 30*Math.PI/180;
			var newangle:Number = Math.tan(angle);	
			var addw:int = Math.tan(30*Math.PI/180)*o.h;
			var newwidth:int = (o.w +addw);
			var shadow:BitmapData 
			if(newwidth > 0 && o.h > 0){
				shadow = new BitmapData(newwidth,o.h,true,0);
				if(_bturn){
					mat = new Matrix(-1,0,-newangle,0.5,(o.w +newangle*o.h),0.5*o.h);
				}else{
					mat = new Matrix(1,0,-newangle,0.5,newangle*o.h,0.5*o.h);
				}
				shadow.lock();
				shadow.draw(bmd,mat,trans,null);
				shadow.applyFilter(shadow, shadow.rect, new Point(0, 0), FilterSet.blurFilter);
				shadow.unlock();
			}
			
			//bitmapdata1.dispose();
			//bitmapdata2.dispose();
		
			return shadow;
		}
		
		public override function getClipFrame(index:int):AnimationFrame{
			if(clip){
				if(this.processFrame(clip,index))
					return clip.frames[index];
				else
					return null;
			}
			return null;
		}
	}
}