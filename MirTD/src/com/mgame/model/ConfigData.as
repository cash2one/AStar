package com.mgame.model
{
	import com.core.Facade;
	import com.sh.game.util.CSVDataUtil;
	
	import flash.utils.ByteArray;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 上午10:25:08
	 * 游戏所有配置管理
	 */
	public class ConfigData
	{
		/**
		 * 关卡配置
		 */
		public static const LEVELS:int = 1;
		/**模型配置 	 */
		public static const MODELS:int = 2;
		/**怪物配置 	 */
		public static const MONSTER:int = 3;
		/** 关卡怪物配置 	 */
		public static const LEVEL_MONSTER:int = 4;
		
		/** 技能配置 	 */
		public static const SKILL:int = 5;
		
		/** 特效配置 	 */
		public static const EFFECT:int = 6;
		
		/** 技能特效配置 	 */
		public static const SKILL_EFFECT:int = 7;
		
		/** 技能特效配置 	 */
		public static const SKILL_GROUP:int = 8;
		
		/** 天赋	 */
		public static const TIANFU:int = 9;
		
		public static const cfgUrls:Array = [
			"assets/data/cfg_levels.csv",
			"assets/data/cfg_model_info.csv",
			"assets/data/cfg_monsters.csv",
			"assets/data/cfg_level_monster.csv",
			"assets/data/cfg_skills.csv",
			"assets/data/cfg_skill_effects.csv",
			"assets/data/cfg_effects.csv",
			"assets/data/cfg_tianfu_level.csv"
		];
		public function ConfigData()
		{
		}
		
		public static var allCfgs:Array;
		
		public static function initDebug(cfgsarr:Array):void{
			allCfgs = new Array();
			var cfgs:Object = cfgsarr.shift();
			var tempData:Array = new Array();
			var o:Object;
			var temp:Object;
			for each (temp in cfgs) 
			{
				tempData[temp.id] =  temp;
			}
			allCfgs[LEVELS] = tempData;
			
			cfgs = cfgsarr.shift();
			var models:Object = new Object();
			var standX:int;
			var standY:int;
			for each(o in cfgs)
			{
				if(!models[o.id]){
					models[o.id] = [];
				}
				standX = int(o.standx) ;
				standY = int(o.standy) ;
				if(standX <= 0){
					standX = 320;
				}
				if(standY <= 0){
					standY = 372;
				}
				models[o.id][o.action] = [int(o.totaldir),int(o.intval),standX,standY];
			}
			allCfgs[MODELS] = models;
			
			cfgs = cfgsarr.shift();
			tempData = new Array();
			for each (temp in cfgs) 
			{
				tempData[temp.mid] =  temp;
			}
			allCfgs[MONSTER] = tempData;
			
			cfgs = cfgsarr.shift();
			o = new Object();
			for each (temp in cfgs) 
			{
				if(!o[temp.id]){
					o[temp.id] = new Array();
				}
				if(!o[temp.id][temp.sort])
					o[temp.id][temp.sort] = new Array();
				o[temp.id][temp.sort].push(temp);
			}
			allCfgs[LEVEL_MONSTER] = o;
			
			cfgs = cfgsarr.shift();
			var skill:Array = new Array();
			var skillgroup:Array = new Array();
			for each(o in cfgs){
				skill[o.skillid] = o;
				if(!skillgroup[o.groupid]){
					skillgroup[o.groupid] = new Object();
					skillgroup[o.groupid].careertype = o.careertype;
					skillgroup[o.groupid].skilltype = o.skilltype;
					skillgroup[o.groupid].player = o.player;
				}
				skillgroup[o.groupid][o.level] = o;
			}
			var skillEffects:Array = new Array();
			cfgs = cfgsarr.shift();
			for each(o in cfgs){
				if(o.efftype == 0){
					if(!skillEffects[o.skillid])
						skillEffects[o.skillid] = new Array();
					skillEffects[o.skillid].push(o);
				}
			}
			allCfgs[SKILL_EFFECT] = skillEffects;
			allCfgs[SKILL] = skill;
			allCfgs[SKILL_GROUP] = skillgroup;
			
			var effects:Array = new Array();
			cfgs = cfgsarr.shift();
			for each(o in cfgs){
				effects[o.id] = o;
			}
			allCfgs[EFFECT] = effects;
			
			var tianfu:Array = new Array();
			cfgs = cfgsarr.shift();
			for each(o in cfgs){
				if(!tianfu[o.id])
					tianfu[o.id] = new Array();
				tianfu[o.id][o.level] = o;
			}
			allCfgs[TIANFU] = tianfu;
			
			Facade.instance.setModel(ModelName.GAME_CONFIG,allCfgs);
		}
		
		public static function init():void{
			allCfgs = new Array();
			var bytes:ByteArray = new ResourceEmbed.levelsCfg() as ByteArray;
			var cfgs:Object = CSVDataUtil.listData(String(bytes));
			var tempData:Array = new Array();
			var o:Object;
			var temp:Object;
			for each (temp in cfgs) 
			{
				tempData[temp.id] =  temp;
			}
			allCfgs[LEVELS] = tempData;
			
			bytes = new ResourceEmbed.modelResCfg() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			var models:Object = new Object();
			var standX:int;
			var standY:int;
			for each(o in cfgs)
			{
				if(!models[o.id]){
					models[o.id] = [];
				}
				standX = int(o.standx) ;
				standY = int(o.standy) ;
				if(standX <= 0){
					standX = 320;
				}
				if(standY <= 0){
					standY = 372;
				}
				models[o.id][o.action] = [int(o.totaldir),int(o.intval),standX,standY];
			}
			allCfgs[MODELS] = models;
			
			bytes = new ResourceEmbed.monstersCfg() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			tempData = new Array();
			for each (temp in cfgs) 
			{
				tempData[temp.mid] =  temp;
			}
			allCfgs[MONSTER] = tempData;
			
			bytes = new ResourceEmbed.levelMonstersCfg() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			o = new Object();
			for each (temp in cfgs) 
			{
				if(!o[temp.id]){
					o[temp.id] = new Array();
				}
				if(!o[temp.id][temp.sort])
					o[temp.id][temp.sort] = new Array();
				o[temp.id][temp.sort].push(temp);
			}
			allCfgs[LEVEL_MONSTER] = o;
			
			bytes = new ResourceEmbed.skills() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			var skill:Array = new Array();
			var skillgroup:Array = new Array();
			for each(o in cfgs){
				skill[o.skillid] = o;
				if(!skillgroup[o.groupid]){
					skillgroup[o.groupid] = new Object();
					skillgroup[o.groupid].careertype = o.careertype;
					skillgroup[o.groupid].skilltype = o.skilltype;
					skillgroup[o.groupid].player = o.player;
				}
				skillgroup[o.groupid][o.level] = o;
			}
			var skillEffects:Array = new Array();
			bytes = new ResourceEmbed.skillEffects() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			for each(o in cfgs){
				if(o.efftype == 0){
					if(!skillEffects[o.skillid])
						skillEffects[o.skillid] = new Array();
					skillEffects[o.skillid].push(o);
				}
			}
			allCfgs[SKILL_EFFECT] = skillEffects;
			allCfgs[SKILL] = skill;
			allCfgs[SKILL_GROUP] = skillgroup;
			
			var effects:Array = new Array();
			bytes = new ResourceEmbed.effectsCfg() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			for each(o in cfgs){
				effects[o.id] = o;
			}
			allCfgs[EFFECT] = effects;
			
			var tianfu:Array = new Array();
			bytes = new ResourceEmbed.tianfuCfg() as ByteArray;
			cfgs = CSVDataUtil.listData(String(bytes));
			for each(o in cfgs){
				if(!tianfu[o.id])
					tianfu[o.id] = new Array();
				tianfu[o.id][o.level] = o;
			}
			allCfgs[TIANFU] = tianfu;
			
			Facade.instance.setModel(ModelName.GAME_CONFIG,allCfgs);
		}
	}
}