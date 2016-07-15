package com.rpg.scene.actor.compnent
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	

	public class ImageNumber
	{
		public function ImageNumber()
		{
		}
		
		
		public static function addNumber(pre:String,num:String,container:Sprite,x:int,y:int):Vector.<Bitmap>{
			var len:int = num.length;
			var w:int = 0;
			var tx:int = x ;
			
			var imgs:Vector.<Bitmap> = new Vector.<Bitmap>();
			for(var i:int = 0; i < len;i++){
				var str:String = num.charAt(i);
				if(str == "-")
					str = "m";
				var texture:Bitmap = new Bitmap(Resource.getRes("png." + pre + str));
				if(texture){
					var image:Bitmap = texture;
					container.addChild(image);
					/*image.x = tx +  w;
					image.y = y;*/
					w += image.width - 4;
					imgs.push(image);
				}
			}
			var left:int = -w/2;
			w = 0;
			for each (var img:Bitmap in imgs) 
			{
				img.x = tx +  w + left;
				img.y = y;
				w += img.width - 4;
			}
			return imgs;
		}
	}
}