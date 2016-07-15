package com.rpg.entity
{
	import com.rpg.entity.animation.AnimationClip;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.entity.animation.AnimationPlayerData;
	import com.rpg.framework.loader.ActionAssets;
	import com.rpg.framework.system.thread.IThreadProcess;
	import com.rpg.framework.system.thread.ThreadManager;
	import com.sh.game.util.ModelName;
	import com.sh.game.util.ObjectUtil;
	
	import define.FilterSet;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ShadowSkinData2 extends AnimationPlayerData implements IThreadProcess
	{
		
		/** 动画解析完成事件 */		
		public var analyzeComplete : Function;
		protected var _completed : Boolean;
		protected var _isThread  : Boolean;
		//protected var _items 	 : Vector.<AnimalSkinDataClipItem>;
		protected var _item 	 : AnimalSkinDataClipItem;
		public var totalDir:int = 8;
		protected var _reader:ActionAssets;
		protected var _bturn   :Boolean;
		public var interval	   : int;
		public var playCount   : int = AnimationPlayer.LOOP;
		protected var _clip: AnimationClip;
		public function ShadowSkinData2(model:String,reader:ActionAssets,action:int,dir:int,isThread : Boolean = false,item:AnimalSkinDataClipItem = null,clip:AnimationClip = null,bturn:Boolean = false)
		{
			super();
			_reader = reader;
			this.model = model;
			this.fileName = ModelName.getSource(model ,action,dir);
			_isThread = isThread;
			_item     = item;
			_clip     = clip;
			_bturn   = bturn;
			this.action = action;
			this.dir = dir;
			ThreadManager.instance.add("shadowthread", this);
		}
		
		public function get id():String
		{
			return fileName;
		}
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function process():void
		{
			if (_reader.isNull)
			{
				this.dispose();
			}
			else
			{
				if(!this.clip)
					this.createClip();
				if(this.processFrame(this.clip)){
					_completed = true;
					
					if (analyzeComplete != null)
					{
						analyzeComplete(this);
					}
				}
			}
				
		}
		public override function dispose() : void
		{
			_completed		= true;
			analyzeComplete = null;
			ThreadManager.instance.remove("shadowthread", this);
			super.dispose();
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
			this.clip = clip;
			//this.processFrame( clip);
		}
		
		private var _curid:int = 0;
		
		protected function processFrame( clip : AnimationClip) :Boolean
		{
			if(this._reader.frameNames.length > _curid){
				var name:String = _reader.frameNames[_curid];
				var o:Object = _reader.frameSet[name];
				var angle:Number = 30*Math.PI/180;
				var newangle:Number = Math.tan(angle);
				var addw:int = 0;
				addw = (o.h+o.y-_item.standY)*newangle;
				var standX:int = _item.standX;
				var standY:int = _item.standY;
				if(_bturn){
					standX = standX - (standX-(o.x+o.w/2))*2
				}
				clip.frames.push(this.createFrame(_curid,o, createFrameShadow(_clip.frames[_curid].data,_reader.frameSet[name]),standX+addw,_item.standY+(o.h+o.y-standY)*.4+4));
				_curid ++;
			}
			if(_curid >= this._reader.frameNames.length ){
				return true;
			}
			return false;
		}
		
		private static const trans:ColorTransform = new ColorTransform(0,0,0,0.6);
		private static var linerBitmapData:BitmapData;
		private static const MaxW:int = 800;
		private static const MaxH:int = 100;
		
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
			var bitmapdata1:BitmapData;
			if(linerBitmapData == null){
				bitmapdata1 = new BitmapData(MaxW , MaxH, true, 0xFFFFFF);
				var matrix:Matrix
				matrix = new Matrix();
				matrix.createGradientBox(MaxW, MaxH, Math.PI *3.0 / 2.0);
				var sprite:Shape = new Shape();
				sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000, 0x000000], [1, 0.6, 0.1, 0], [0, 64, 128, 255], matrix);
				sprite.graphics.drawRect(0, 0, MaxW , MaxH);
				sprite.graphics.endFill();
				bitmapdata1.draw(sprite);
				sprite.graphics.clear();
				linerBitmapData = bitmapdata1;
			}else{
				bitmapdata1 = linerBitmapData;
			}
			var mat :Matrix;
			//var obj:Object = ObjectUtil.clone(o);
			var angle:Number = 30*Math.PI/180;
			var newangle:Number = Math.tan(angle);	
			var addw:int = Math.tan(30*Math.PI/180)*o.h;
			var newwidth:int = (o.w +addw);
			var shadow:BitmapData = new BitmapData(newwidth,o.h,true,0);
			shadow.lock();
			//shadow.copyPixels(bitmapdata1,new Rectangle(0,0,newwidth,o.h),new Point());
			if(_bturn){
				mat = new Matrix(-1,0,-newangle,0.5,(o.w +newangle*o.h),0.5*o.h);
			}else{
				mat = new Matrix(1,0,-newangle,0.5,newangle*o.h,0.5*o.h);
			}
			
			shadow.draw(bmd,mat,null,null);
			shadow.copyPixels(bitmapdata1,shadow.rect,new Point(),shadow)
			shadow.applyFilter(shadow, shadow.rect, new Point(0, 0), FilterSet.blurFilter);
			shadow.unlock();
			//bitmapdata1.dispose();
			//bitmapdata2.dispose();
		
			return shadow;
		}
	}
}