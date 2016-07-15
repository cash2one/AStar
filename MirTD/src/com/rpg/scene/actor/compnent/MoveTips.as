package com.rpg.scene.actor.compnent
{
	
	import com.core.destroy.DestroyUtil;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	 
	public class MoveTips extends Sprite
	{
		private var _images:Vector.<Bitmap>;
		private var _type:Bitmap;
		
		public function MoveTips(value:int,type:int = 0,plus:int = 1)
		{
			var pre:String = "";
			if(type == 1){
				pre = "add_";
			}else{
				pre = "hurt_";
			}
			var plusX:int = 72;
			if(plus == 3){
				_type = new Bitmap(Resource.getRes("png.fire"));//new Image(ZoneBindAssets.getTexture("firehurt"));
				this.addChild(_type);
				plusX = 115;
			}else if(plus == 2){
				_type = new Bitmap(Resource.getRes("png.double"));
				this.addChild(_type);
				plusX = 98;
			}else if(plus == 0){
				_type = new Bitmap(Resource.getRes("png.miss"));
				this.addChild(_type);
			}
			
			if(value != 0)
				_images = ImageNumber.addNumber(pre,value + "",this,plus != 1?plusX:0,plus != 1?6:0);
		/*	this.pivotX = int(this.width / 2);
			this.pivotY = 10;*/
			this.scaleX = 0.5;
			this.scaleY = 0.5;
			//_type = new Image()
			//this.filter = BlurFilter.createGlow();
		}
		//private var tw:Tween;
		private var tw:TweenLite;
		public function startMove(dir:int = -1):void{
			var tox:int = int(this.x +50 +Math.random() * -100) ;
			if(dir == 2)
				tox += 100;
			else if(dir == 6)
				tox -= 100;
			var toy:int = int(this.y - 50 + Math.random() * -50);
			tw = TweenLite.to(this,0.1,{x:tox,y:toy,scaleX:1.5,scaleY:1.5,onComplete:onCom});
		}
		
		private function clear():void{
			if(tw){
				tw.kill();
				tw = null;
			}
			if(this.parent)
				this.parent.removeChild(this);
			if(_images){
				for each(var img:Bitmap in this._images){
					this.removeChild(img);
				}
				_images.length = 0;
				//DestroyUtil.destroyVector(_images);
			}
			if(_type){
				if(_type.parent){
					_type.parent.removeChild(_type);
				}
				_type.bitmapData = null;
				_type = null;
			}
			_images = null;
		}
		
		private function onCom():void{
			tw = TweenLite.to(this,0.1,{y:int(this.y + 10),scaleX:1,scaleY:1,onComplete:onCom2});
		}
		
		private function onCom2():void{
			tw = TweenLite.to(this,0.5,{y:int(this.y + 50),scaleX:1,scaleY:1,onComplete:clear});
		}
		
	}
}