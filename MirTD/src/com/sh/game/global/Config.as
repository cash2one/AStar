package com.sh.game.global
{
	import com.sh.game.consts.ResourceType;

	public class Config
	{
		/** 游戏内存上限（默认512MB） */
		public static var memoryLimit : int             = 524288000;
		/** 游戏内存回收间隔时间（默认10分钟） */
		public static var memoryInterval : int          = 10000;
		
		public static var gameParams:Object;
		/**
		 * 是否启用测试代码
		 */
		public static var testCode:Boolean = false;
		
		public static var testZone:Boolean = true;
		
		public static var fps:int = 60;
		/**正常情况帧上传纹理限制*/
		public static var frameUploadMax:int = 200000;
		/**传送后帧上传纹理限制*/
		public static var deliverFrameUploadMax:int = 300000;
		
		/** 玩家皮肤路径 */
		public static var clothSkinPath : String        = "assets/models/roles/";
		/** 玩家影子皮肤路径 */
		public static var shadowPath : String        = "assets/models/shadow/";
		/** 武器皮肤路径 */
		public static var weaponSkinPath : String        = "assets/models/arm/";
		/** 翅膀坐骑皮肤路径 */
		public static var wingSkinPath : String          = "assets/models/wing/";
		
		public static var monsterPath:String 		     = "assets/models/monster/";
		
		public static var npcPath:String				 = "assets/models/npc/";
		
		/** 玩家皮肤路径 */
		public static var roleSkinPath : String        = "assets/models/roles/";
		/** 物体皮肤路径 */
		public static var bodySkinPath : String        = "assets/images/effects/";
		
		/** 地图路径 */
		public static var mapPath : String        = "assets/images/maps/";
		/** 地图路径 */
		public static var mapDataPath : String        = "assets/data/map/";
		
		public static var NewBirdCity:int = 1001;
		
		/** 玩家皮肤文件后缀 */
		public static var SkinExt : String        = ".dat";
		
		/** 玩家皮肤文件后缀 */
		public static var JPGExt : String        = ".jpg";
		
		/**
		 * 全自动游戏
		 */
		public static var autoCreate:Boolean = false;
		
		public static var debug:Boolean = true;
		
		public static const IconExtension:String = ".png";
		
		public static var hexie:Boolean = false;
		
		public static var swfHead:Array = [67,87,83,11];
		
		public static var applyBlendMode:Boolean = false;
		
		public static var isRightMouse:Boolean = true;
		
		public static const LostContext:String = "Disposed";
		
		public static var isYaCe:Boolean = true;
		
		public static var versionUrl:String = "";
		
		public static var swfkey:String = "368f9d93515d1c7d94f73b3c1a97ab9d";
		
		public static var mswfkey:String = "98dfvkjhriuytjojxcbvl";
		
		public static var modelKye:String = "v0s3s9df5425fuckyoubitch8239";
		
		public static var defaultVersion:String = "";
		
		public static var resVersions:Object = new Object();
		
		public static var resDics:Object = new Object();
		
		public static var errors:Object = new Object();
		
		public static var BytesCacheMax:int = 30 * 1024 * 1024;
		
		public static var Encrypt:Boolean = false;
		
		/**
		 * 商店出售所有道具
		 */
		public static var sellAll:Boolean = false;
		
		/**
		 * 输出限制   
		 * 0 ： 什么都不输出 
		 * 1: error 		
		 * 2：info 		
		 * 3：debug 
		 */
		public static var Log:int = 0;
		
		public static function get resourceRoot():String{
			var url:String = "";
			if(Config.gameParams && Config.gameParams.hasOwnProperty("imageserver")){
				url = Config.gameParams.imageserver; 
			}
			return url;
		}
		
		public static function get swfPath():String{
			var url:String = "";
			if(Config.gameParams){
				if(Config.gameParams.hasOwnProperty("pluginserver"))
					url = Config.gameParams.pluginserver;
				else if(Config.gameParams.hasOwnProperty("imageserver"))
					url = Config.gameParams.imageserver;
					
			}
			return url;
		}
		
		public static function get dataPath():String{
			var url:String = "";
			if(Config.gameParams){
				if(Config.gameParams.hasOwnProperty("configserver"))
					url = Config.gameParams.configserver;
				else if(Config.gameParams.hasOwnProperty("imageserver"))
					url = Config.gameParams.imageserver;
			}
			return url;
		}
		
		public static function getUrl(url:String,type:int = 1,param:String = null,uncomposedurl:String = null):String{
			var version:String;
			switch(type){
				case ResourceType.NORMAL:
					if(url in resVersions){
						version = "?version="+ resVersions[url];
					}else{
						version = "?version="+ Config.defaultVersion;
					}
					url = Config.resourceRoot + url +version;
					break;
				case ResourceType.DATA:
					version = Config.versionUrl;
					url = Config.dataPath + url + version;
					break;
				case ResourceType.SWF:
					version = Config.versionUrl;
					url = Config.swfPath + url + version;
					break;
				case ResourceType.MAP:
					if(param in resVersions){
						version = "?version="+ resVersions[param];
					}else{
						version = "?version="+ Config.defaultVersion;
					}
					url = Config.resourceRoot + url + version;
					break;
				case ResourceType.MODEL:
					if(param in resVersions){
						version = "?version="+ resVersions[param];
					}else{
						version = "?version="+ Config.defaultVersion;
					}
					url = Config.resourceRoot + url + version;
					break;
				default:
					url = url + Config.versionUrl;
					break;
			}
			return url;
		}
	}
}