package com.rpg.scene
{
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.collections.DictionaryCollection;
	import com.rpg.framework.loader.ActionLoader;
	import com.rpg.framework.system.memory.CacheCollection;
	import com.rpg.framework.system.memory.CacheManager;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	
	
	
	/**
	 * 场景缓存管理组件
	 * 
	 */	
	public class SceneCacheManager
	{
		
		/** 所有皮肤线程处理对象集合 */
		public var skinProcess : DictionaryCollection;
		/** 其它动画皮肤数据（永久缓存） */	
		public var otherSkin   : CacheCollection;		// 已存动画资源:转场点
		
		/** 玩家人物皮肤数据 （有策略缓存） */		
		public var playerSkin  : DictionaryCollection;
		/** 技能特效数据 （有策略缓存） */
		public var skillSkin   : CacheCollection;
		/** 宠物人物皮肤数据 （有策略缓存） */		
		//public var petSkin     : CacheCollection;
		
		/** 怪物 皮肤数据 （转场时清除缓存）  */		
		public var monsterSkin : CacheCollection;
		/** NPC皮肤数据（转场时清除缓存） */	
		public var npcSkin     : CacheCollection;
		/** 场景元件皮肤数据（转场时清除缓存） */	
		public var bodySkin    : CacheCollection;
		/** 其他影子数据 */	
		public var shadowSkin  :CacheCollection;
		/** 玩家影子数据 */	
		public var playerShadowSkin  :CacheCollection;
		
		public var mapskin:CacheCollection;
		
		public var defaultSkin:CacheCollection;
		
		private static var _instance:SceneCacheManager = null;
		
		public static function get instance():SceneCacheManager{
			if(_instance == null){
				_instance = new SceneCacheManager();
			}
			return _instance;
		}
		
		public function addMapCaches(cache:Object):void{
			if(cache){
				for (var  key:String in cache) 
				{
					this.mapskin.add(key,cache[key]);
				}
			}
		}
		
		public function SceneCacheManager()
		{
			
			skinProcess = new DictionaryCollection();
			
			playerSkin = new DictionaryCollection();
			playerSkin.add(ElementSkinType.CLOTHING_FOOT, new CacheCollection());
			playerSkin.add(ElementSkinType.WEAPON_FOOT, new CacheCollection());
			playerSkin.add(ElementSkinType.MOUNT_PLUS, new CacheCollection());
			playerSkin.add(ElementSkinType.WING, new CacheCollection());
			
			skillSkin   = new CacheCollection();
			monsterSkin = new CacheCollection();
			npcSkin     = new CacheCollection();
			otherSkin   = new CacheCollection();
			shadowSkin  = new CacheCollection();
			playerShadowSkin  = new CacheCollection();
			mapskin = new CacheCollection();
			
			defaultSkin = new CacheCollection();
			// 定时资源内存监视，并清理
			for each (var skinCache : CacheCollection in playerSkin)
			{
				CacheManager.instance.add(skinCache);
			}
			CacheManager.instance.add(skillSkin);
			CacheManager.instance.add(monsterSkin);
			CacheManager.instance.add(npcSkin);
			//CacheManager.instance.add(shadowSkin);
			//CacheManager.instance.add(playerShadowSkin);
			CacheManager.instance.add(mapskin);
		}
		
		public function clear() : void
		{
			skinProcess.clear();
			monsterSkin.clear();
			npcSkin.clear();
			shadowSkin.clear();
			mapskin.clear();
			
			//trace("mapskin cache : " + mapskin.length);
			
			if(System.totalMemory > CacheManager.instance.limit){
				for each (var skinCache : CacheCollection in playerSkin)
				{
					skinCache.clear();
				}
				skillSkin.clear();
			}
			/*if (System.totalMemory > CacheManager.instance.limit || playerShadowSkin.length > 220)
			{
				playerShadowSkin.clear();
			}*/
			CacheManager.instance.timeToGc();
			/*if(shadowSkin.length > 0){
				throw(new Error("我嘞个擦，怪物模型影子缓存残留" + shadowSkin.getKeys()));
			}*/
		}

		/*public override function listNotificationInterests() : Array
		{
			return [
				SceneNotification.MEMORY_ADD_REFERENCE,
				SceneNotification.MEMORY_REMOVE_REFERENCE
			];
		}

		public override function handleNotification(notification : INotification) : void
		{
			switch (notification.getName())
			{
				case SceneNotification.MEMORY_ADD_REFERENCE:
					addReference(notification);
					break;
				case SceneNotification.MEMORY_REMOVE_REFERENCE:
					removeReference(notification);
					break;
				default:
					break;
			}
		}*/

		//private var countdic:Dictionary = new Dictionary();
		
		public function addReference(type:String,sourcename:int,plus:String = null) : void
		{
			switch(type)
			{
				case ElementSkinType.CLOTHING_FOOT:
				case ElementSkinType.WEAPON_FOOT:
				case ElementSkinType.WING:
					playerSkin[type].addReference(sourcename);
					break;
				case ElementSkinType.NPC:
					npcSkin.addReference(sourcename);
					break;
				case ElementSkinType.MONSTER:
					monsterSkin.addReference(sourcename);
					break;
				case ElementSkinType.SKILL:
					skillSkin.addReference(sourcename);
					break;
				case ElementSkinType.SHADOW_OUT:
					playerShadowSkin.addReference(sourcename);
					break;
				case ElementSkinType.SHADOW:
					/*if(plus == ElementSkinType.CLOTHING_FOOT)
						playerShadowSkin.addReference(sourcename);
					else*/
						shadowSkin.addReference(sourcename);
					break;
				default:
					break;
			}
		/*	if(!countdic[type])
				countdic[type] = 0;
			countdic[type]++;*/
		}

		public function checkReference(type:String,sourcename:int) : void
		{
			var url : int = sourcename;
			var item:Object ;
			switch(type)
			{
				case ElementSkinType.CLOTHING_FOOT:
				case ElementSkinType.WING:
				case ElementSkinType.WEAPON_FOOT:
					var c:CacheCollection = playerSkin[type];
					item = c.getItem(url);
					if(item && item.reference == 0){
						//c.removeNow(url);
					}
					break;
				case ElementSkinType.NPC:
					item = npcSkin.getItem(url);
					if(item && item.reference == 0){
						//npcSkin.removeNow(url);
					}
					break;
				case ElementSkinType.MONSTER:
					item = monsterSkin.getItem(url);
					if(item && item.reference == 0){
						//monsterSkin.removeNow(url);
					}
					break;
				case ElementSkinType.SKILL:
					item = skillSkin.getItem(url);
					if(item && item.reference == 0){
						//skillSkin.removeNow(url);
					}
					//skillSkin.removeReference(url) ;
					break;
				case ElementSkinType.SHADOW_OUT:
					item = playerShadowSkin.getItem(url);
					if(item && item.reference == 0){
						//playerShadowSkin.removeNow(url);
					}
					break;
				case ElementSkinType.SHADOW:
					item = shadowSkin.getItem(url);
					if(item && item.reference == 0){
						//shadowSkin.removeNow(url);
					}
					//shadowSkin.removeReference(url);
					break;
				default:
					break;
			}
		}
		
		public function removeReference(type:String,sourcename:int,plus:String = null) : void
		{
			if(sourcename == 0)
				return;
			var url : int = sourcename;
			switch(type)
			{
				case ElementSkinType.CLOTHING_FOOT:
				case ElementSkinType.WING:
				case ElementSkinType.WEAPON_FOOT:
					var c:CacheCollection = playerSkin[type];
					if(c.removeReference(url) == 1){
						//c.removeNow(url);
					}
					break;
				case ElementSkinType.NPC:
					if(npcSkin.removeReference(url) == 1){
						//npcSkin.removeNow(url);
					}
					break;
				case ElementSkinType.MONSTER:
					if(monsterSkin.removeReference(url) == 1){
						//monsterSkin.removeNow(url);
					}
					break;
				case ElementSkinType.SKILL:
					skillSkin.removeReference(url) ;
					//if(skillSkin.removeReference(url) == 1){
						//skillSkin.removeNow(url);
					//}
					break;
				case ElementSkinType.SHADOW_OUT:
					playerShadowSkin.removeReference(url) ;
					/*if(playerShadowSkin.removeReference(url) == 1){
						playerShadowSkin.removeNow(url);
					}*/
					break;
				case ElementSkinType.SHADOW:
					/*if(plus == ElementSkinType.CLOTHING_FOOT)
						playerShadowSkin.removeReference(url);
					else*/
					shadowSkin.removeReference(url);
					/*if(shadowSkin.removeReference(url) == 1){
						shadowSkin.removeNow(url);
					}*/
					break;
				default:
					break;
			}
			//countdic[type]--;
		}
	}
}