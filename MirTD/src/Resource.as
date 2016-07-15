package
{
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-3 上午9:12:53
	 * 
	 */
	public class Resource
	{
		private static var _resourceDic:Dictionary = new Dictionary();
		
		public function Resource()
		{
		}
		
		public static function getRes(name:String):*{
			if(name in _resourceDic){
				return _resourceDic[name];
			}
			if(ApplicationDomain.currentDomain.hasDefinition(name)){
				var cls:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
				_resourceDic[name] = new cls();
				return _resourceDic[name];
			}
			return null;
		}
		
		public static function initModelsData():Object{
			var bytes:ByteArray = new ResourceEmbed.TDresDat() as ByteArray;
			bytes.uncompress();
			var obj:Object = bytes.readObject();
			return obj;
		}
		
		public static function initModelsRes():Dictionary{
			var bytes:ByteArray = new ResourceEmbed.TDresRes() as ByteArray;
			var dic:Dictionary = new Dictionary();
			bytes.uncompress();
			while(bytes.bytesAvailable > 4){
				var sname:int = bytes.readInt();
				var len:int = bytes.readByte();
				var bmpArr:Array = [];
				for (var i:int = 0; i < len; i++) 
				{
					var blen:int = bytes.readInt();
				/*	var w:int = bytes.readShort();
					var h:int = bytes.readShort();*/
					var bmpBytes:ByteArray = new ByteArray();
					bytes.readBytes(bmpBytes,0,blen);
					bmpBytes.position = 0;
					bmpArr.push(bmpBytes);
				}
				dic[sname] = bmpArr;
			}
			return dic;
		}
	}
}