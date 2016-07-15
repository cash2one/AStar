package com.rpg.framework.loader
{
	import com.sh.game.pool.IPoolItem;
	import com.sh.game.pool.ObjectPoolManager;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import define.Constant;
	
	
	public class ActionBmpAssets implements IPoolItem
	{
		public function ActionBmpAssets()
		{
			
		}
		
		public function init(bytes:ByteArray,name:String,type:String,callback:Function,args:Array):void{
			this._args = args;
			this._name = name;
			this.callBack = callback;
			this._bytes = bytes;
			this.type = type;
		}
		
		public function reset():void{
			this.clear();
		}
		
		public function dispose():void{
			this.clear();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public var type:String;
		private var _loader:Loader;
		private var _name:String;
		private var callBack:Function;
		private var _xml:XML;
		private var _args:Array;
		private var _bytes:ByteArray;
		private var _loadInfo:LoaderInfo;
		public var frameSet:Dictionary;
		public var frameNames:Array;
		public var processFrame:int = 0;
		public var totalSize:int = 0;
		
		public function read():void{
			//time = getTimer();
			var bytes:ByteArray = this._bytes;
			_bytes = null;
			if(bytes == null){
				if(callBack != null)
					this.callBack.apply(null,_args.concat(null) );
				ObjectPoolManager.getInstance().returnItem(Constant.ActionAssetsClass,this);
				return;
			}
			try
			{
				var swf:ByteArray = new ByteArray();
				var size:int = bytes.readInt();
				var xmlBytes:ByteArray = new ByteArray();
				bytes.readBytes(xmlBytes,0,size);
				xmlBytes.uncompress()
				_xml = new XML(xmlBytes);
				
				if(!_loader){
					_loader = new Loader();
				}
				bytes.readBytes(swf,3,bytes.bytesAvailable);
				swf.position = 0;
				swf.writeUTFBytes("CWS");
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfLoadComplete);
				totalSize = swf.length;
				//time = getTimer()-time;
			//	trace("解析耗时"+ time);
				//time = getTimer();
				_loader.loadBytes(swf);
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
				
				this.processFrame =  totalSize/10000;///(swf.length/20000) ;
				//trace("资源大小：" + totalSize / 1000 + "K  size: "  +  frameNames.length);
				//bytes.clear();
				swf.clear();
				if(_bytes){
					_bytes.clear();
					this._bytes = null;
				}
			} 
			catch(error:Error) 
			{
				trace("资源" + this._name  + "出错： "+ error.message);
				if(callBack != null)
					this.callBack.apply(null,_args.concat(null) );
				ObjectPoolManager.getInstance().returnItem(Constant.ActionAssetsClass,this);
				return;
			}
			
		}
		
		private var time:int ;
		
		protected function swfLoadComplete(event:Event):void
		{
			_loadInfo = event.currentTarget as LoaderInfo;
			_loadInfo.removeEventListener(Event.COMPLETE,swfLoadComplete);
			if(callBack != null)
				this.callBack.apply(null,_args.concat(this) );
			_args = null;
		}
		
		/**
		 * 获取类定义
		 * @return
		 */
		public function getClass(className : String) : Class
		{
			var cla : Class;
			if (_loadInfo.applicationDomain.hasDefinition(className))
			{
				cla = _loadInfo.applicationDomain.getDefinition(className) as Class;
			}
			return cla;
		}
		
		public function get isNull():Boolean{
			return _loader == null;
		}
		
		
		public function clear():void{
			if(callBack){
				callBack = null;
			}
			this.frameNames = null;
			this.frameSet = null;
			_xml = null;
			if(_args){
				_args.length = 0;
				_args = null;
			}
			_name = null;
			if(_loader){
				try{
					_loader.unload();
				}
				catch(e:Error){
				}
				_loader = null;
			}
			if(_loadInfo)
				_loadInfo = null;
		}
	}
}

