package com.rpg.framework.provider
{
	import com.rpg.framework.IDisposable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public class ContentTypeReader implements IDisposable
	{
		private var _url : String; //资源地址
		private var _name : String; // 资源唯一编号
		private var _content : *; // 资源内容

		public function get url() : String
		{
			return _url;
		}

		public function set url(value : String) : void
		{
			_url = value;
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(value : String) : void
		{
			_name = value
		}

		public function get content() : *
		{
			return _content;
		}

		public function set content(value : *) : void
		{
			_content = value;
		}

		/** 藜取字节数组数据  */
		public function getByteArray() : ByteArray
		{
			return ByteArray(_content);
		}

		/** 获取音频对象 */
		public function getSound() : Sound
		{
			return Sound(_content);
		}

		/** 获取XML对象 */
		public function getXML() : XML
		{
			return XML(_content);
		}

		public function getText() : String
		{
			return String(_content);
		}

		/** 获取 Sprite 对象 */
		public function getSprite() : Sprite
		{
			return Sprite(_content);
		}

		/** 获取影片剪辑对象 */
		public function getMovieClip() : MovieClip
		{
			return MovieClip(_content);
		}

		/** 获取加载信息 */
		public function getLoaderInfo() : LoaderInfo
		{
			return LoaderInfo(_content.loaderInfo);
		}

		/** 获取位图对象 */
		public function getBitmap() : Bitmap
		{
			return Bitmap(_content);
		}

		/** 获取位图对象数据源 */
		public function getBitmapData() : BitmapData
		{
			return Bitmap(_content).bitmapData;
		}

		/** 获取位图数据源对象 */
		public function getClassByBitmapData(className : String) : BitmapData
		{
			var tempClass : Class = Class(this.getClass(className));
			return BitmapData(new tempClass(0, 0));
		}

		/** 在库中获取位图对象 */
		public function getClassByBitmap(className : String) : Bitmap
		{
			return new Bitmap(this.getClassByBitmapData(className));
		}

		/** 在库中获取影片剪辑对象 */
		public function getClassByMovieClip(className : String) : MovieClip
		{
			var tempClass : Class = Class(this.getClass(className));
			return MovieClip(new tempClass());
		}

		/** 在库中获取按钮对象 */
		public function getClassByButton(className : String) : SimpleButton
		{
			var tempClass : Class = this.getClass(className);
			return SimpleButton(new tempClass());
		}

		/** 在库中获取 FLASH 自代组件对象 */
		public function getClassByFlashComponent(className : String) : Sprite
		{
			var tempClass : Class = this.getClass(className);
			return Sprite(new tempClass());
		}

		/** 获取声音数据源对象 */
		public function getClassBySound(className : String) : Sound
		{
			var tempClass : Class = this.getClass(className);
			return Sound(new tempClass());
		}

		/**
		 * 获取类定义
		 * @return
		 */
		public function getClass(className : String) : Class
		{
			var cla : Class;
			if (_content.loaderInfo.applicationDomain.hasDefinition(className))
			{
				cla = _content.loaderInfo.applicationDomain.getDefinition(className);
			}
			return cla;
		}

		public function dispose() : void
		{
			if (_content is IDisposable)
			{
				IDisposable(_content).dispose();
			}
			_content = null;
		}
	}
}
