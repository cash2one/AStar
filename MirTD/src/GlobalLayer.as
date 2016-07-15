package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-31 下午5:31:42
	 * 
	 */
	public class GlobalLayer
	{
		
		private var _layers:Dictionary;
		private var _root:Stage;
		
		private static var _instance:GlobalLayer;
		public function GlobalLayer()
		{
		}
		
		public function init(stage:Stage):void{
			_root = stage;
			_layers = new Dictionary();
		}
		public function get root():Stage
		{
			return _root;
		}
		
		public static function get instance():GlobalLayer{
			if(!_instance){
				_instance = new GlobalLayer();
			}
			return _instance;
		}
		
		public function addLayer(name:String,index:int = -1):DisplayObjectContainer{
			var sp:Sprite = new Sprite();
			this._layers[name] = sp;
			this._root.addChild(sp);
			return sp;
		}
		
		public function regLayer(name:String,layer:Object):void{
			_layers[name] = layer;
		}
		
		public function getLayer(name:String):Object{
			return this._layers[name];
		}
	}
}