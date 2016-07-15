package com.rpg.scene.actor.compnent
{
	
	
	import com.rpg.entity.GameSprite;
	import com.sh.game.ui.text.RichTextField;
	import com.sh.game.util.BitmapScale9Grid;
	import com.sh.game.util.Trie;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	

	public class Nonsense extends Sprite
	{
//		private var _text:RichTextField;
		private var _rtf:RichTextField;
		private var _bg:BitmapScale9Grid;
		
		private var _clearTimeOut:uint;
		private var _visible:Boolean = true;
		private var _cont:Sprite;
		private static var w:int = 160;
		
		private var _x:int = 0;
		private var _y:int = 0;
		private var faceVec:Vector.<Clip> = new Vector.<Clip>();
		/**
		 * 怪物无聊瞎扯淡
		 */
		public function Nonsense(container:Sprite)
		{
			_cont = container;
		}
		override public function set x(value:Number):void{
			this._x = value;
			if(_bg)
				_bg.x =Math.round( value-w/2);
			if(_rtf)
				_rtf.x = Math.round(value-w/2 + 10);
		}
		
		override public function set visible(value:Boolean):void{
			if(this._bg){
				this._bg.visible = false;
			}
			if(this._rtf)
				this._rtf.visible = false;
			_visible = value;
		}
		
		override public function set y(value:Number):void{
			this._y = value;
			if(_rtf)
				_rtf.y = Math.round(value + 10 - _bg.height);
			if(_bg)
				_bg.y =Math.round( value - _bg.height);
		}
		public var mFilter:DropShadowFilter = new DropShadowFilter(0,0,0x000000,0.8,2,2,10,1);
		/**
		 * 扯个淡
		 */
		public function talkNonsense(str:String):void{
			if(!_visible)
				return;
			if(_clearTimeOut > 0){
				clearTimeout(_clearTimeOut);
				_clearTimeOut = 0;
			}
			
			clearRtf();
			_rtf = new RichTextField();
//			_rtf.setSize(140,30);
			_rtf.type = RichTextField.DYNAMIC;
			_rtf.html = true;
			_rtf.textfield.selectable = false;
			_rtf.textfield.filters = [mFilter];
			var sprites:Array = [];
			_rtf.append("<font color='#ffffff'>"+getMsg(str)+"</font>", sprites,false,null,false);//,false,null,false);
//			_rtf.append(getMsg(str), sprites,false,null,false);
			_rtf.setSize(140,_rtf.height);
//			if(!_text){
//				text.htmlText = str;
//				_text = addText(text.text,0xffffff);
//				_text.x = 10;
//				_text.y = 10;
//				_cont.display.addChild(_text);
//			}else{
//				_text.htmlText = str;
//				if(_text.parent == null)
//					_cont.display.addChild(_text);
//			}
			if(_bg == null)
			{
				_bg = new BitmapScale9Grid(new Bitmap(Resource.getRes("png.talkBg")),10,20,10,20);
				_cont.addChild(_bg);
				_bg.height = _rtf.height+40;
			}else
			{
				_bg.height = _rtf.height+40;
				if(_bg.parent == null)
					_cont.addChild(_bg);
			}
			_cont.addChild(_rtf);
			_clearTimeOut  = setTimeout(hide,5000);
		}
		private static var text:TextField = new TextField();

		/** 添加一个文本提示项 */
//		public function addText(key : String,color:uint = 0xFFFFFF) : RichTextField
//		{
//			var t : TextField = new TextField();
//			t.cacheAsBitmap = true;
//			t.mouseEnabled = false;
//			t.mouseWheelEnabled = false;
//			t.selectable = false;
//			t.wordWrap = true;
//			t.type = TextFieldType.DYNAMIC;
//			t.width = w - 14;
//			t.textColor = color;
//			t.filters = [FilterSet.miaobian];
//			t.autoSize = TextFieldAutoSize.LEFT;
//			var tf : TextFormat = new TextFormat();
//			tf.align = TextFormatAlign.LEFT;
//			tf.size = 12;
//			tf.font = "宋体";//Config.deviceFonts;
//			t.defaultTextFormat = tf;
//			t.htmlText = key;
//			var rtf:RichTextField = new RichTextField();
//			rtf.setSize(390, 100);
//			rtf.type = RichTextField.DYNAMIC;
//			rtf.html = true;
//			rtf.textfield.selectable = false;
//			rtf.textfield.filters = [mFilter];
//			var sprites:Array = [];
//			return rtf;
//		}
		public function hide():void
		{
			_clearTimeOut = 0;
			if(this._bg&&this._bg.parent){
				_cont.removeChild(_bg);
			}
			clearRtf();
//			if(this._text&&this._text.parent){
//				_cont.display.removeChild(_text);
//			}
		}
		
		public function clearRtf():void
		{
			if(_rtf)
			{
				if(_rtf.parent)
					_rtf.parent.removeChild(_rtf);
				_rtf.dispose();
				_rtf = null;
				while(faceVec.length>0)//销毁表情
				{
					var clip:Clip = faceVec.shift();
					if(clip.parent)
					{
						clip.parent.removeChild(clip);
					}
					clip = null;
				}
			}
		}
		
		public function clear():void{
			if(this._bg){
				if(this._bg.parent){
					this._bg.parent.removeChild(_bg);
					_bg = null;
				}
			}
			clearRtf();
//			if(this._text){
//				if(this._text.parent){
//					this._text.parent.removeChild(_text);
//					_text = null;
//				}
//			}
		}
		
		private var isChecking:Boolean = false;
		
		
		private function getMsg(content:String):String
		{
				return content;
		}
	}
}