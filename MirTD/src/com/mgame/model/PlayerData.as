package com.mgame.model
{
	import com.core.Facade;
	import com.rpg.enum.ActorType;
	import com.rpg.enum.ArmPosType;
	
	import consts.SkillID;

	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-8-1 下午1:49:43
	 * 
	 */
	public class PlayerData
	{
		public function PlayerData()
		{
		}
		
		public static const BASE_HP:int = 1000;
		public static const BASE_ATT:int = 10;
		public static const BASE_DEF:int = 10;
		public static const BASE_SPEED:int = 0;
		public static const BASE_CD:int = 0;
		
		public static var Tianfu:Array = [
			{id:1,name:"顽强身躯",desc:"增加自身生命值",maxlv:4},
			{id:2,name:"神速攻击",desc:"增加自身攻速",maxlv:4},
			{id:3,name:"神力攻击",desc:"增加自身基础攻击力",maxlv:4},
			{id:4,name:"固若金汤",desc:"增加自身防御力",maxlv:4},
			{id:5,name:"寒冰射手",desc:"增加寒冰掌伤害，到LV2开启定身效果",maxlv:4},
			{id:6,name:"火焰使者",desc:"增加流星火雨的伤害，到LV2开启灼烧效果",maxlv:4},
			{id:7,name:"寒冰精通",desc:"增加冰咆哮伤害，到LV2开启减速效果",maxlv:4},
			{id:8,name:"气定神闲",desc:"减少释放技能cd",maxlv:4}
		];
		
		public static function getRoleData():Object{
			var userAbility:Object = getPlayerData();
			return {rid:10001,name:"Player",unionid:1,unionname:"沙包可",dir:7,serverid:1,model:0,x:14,y:16,id:10001,type:ActorType.Actor,pkValue:-1,ability:userAbility,arms:[null,{pos:ArmPosType.PosWeapon,model:"1090/1090"}],fashions:[0,0,16]};
		}
		
		public static function initData():void{
			Facade.instance.setModel(ModelName.GOLD,getGold())
		}
		
		public static function getGoldLocal():int{
			return Facade.instance.getModel(ModelName.GOLD);
		}
		public static function setGoldLocal(gold:int):void{
			Facade.instance.setModel(ModelName.GOLD,gold);
		}
		
		public static function getMaxLevel():int{
			var lv:int = LocalCache.getInstance().getValue("level");
			return lv;
		}
		
		public static function setMaxLevel(lv:int):void{
			if(lv > getMaxLevel())
				LocalCache.getInstance().putValue("level",lv);
		}
		
		public static function getGold():int{
			var gold:int = LocalCache.getInstance().getValue("gold");
			return gold;
		}
		
		public static function setGold(gold:int):void{
			LocalCache.getInstance().putValue("gold",gold);
		}
		
		public static function save():void{
			LocalCache.getInstance().putValue("gold",getGoldLocal());
		}
		
		public static function clearAll():void{
			LocalCache.getInstance().clear();
		}
		
		public static function getSkills():Object{
			var skills:Object = new Object();
			var tianfu:Object = getTianfu();
			var cfg:Object = ConfigData.allCfgs[ConfigData.TIANFU];
			if(tianfu[5] > 0){
				skills[SkillID.HAN_BING_ZHANG] = {id:cfg[5][tianfu[5]].skillid};
			}/*else{
				skills[SkillID.HAN_BING_ZHANG] ={id:SkillID.HAN_BING_ZHANG + 10} ;
			}*/
			if(tianfu[7] > 0){
				skills[SkillID.BING_PAO_XIAO] = {id:cfg[7][tianfu[7]].skillid};
			}/*else{
				skills[SkillID.BING_PAO_XIAO] ={id:SkillID.BING_PAO_XIAO + 10} ;
			}*/
			if(tianfu[6] > 0){
				skills[SkillID.LIU_XING] = {id:cfg[6][tianfu[6]].skillid};
			}/*else{
				skills[SkillID.LIU_XING] ={id:SkillID.LIU_XING + 10} ;
			}*/
			return skills;
		}
		
		public static function getTianfu():Object{
			var tianfus:Object = LocalCache.getInstance().getValue("tianfu");
			if(tianfus == null){
				tianfus = new Object();
				tianfus = {1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0};
				setTianfu(tianfus);
			}
			return tianfus;
		}
		
		public static function setTianfu(tianfu:Object):void{
			LocalCache.getInstance().putValue("tianfu",tianfu);
		}
		
		public static function getPlayerData():Object{
			var tianfu:Object = getTianfu();
			var cfg:Object = ConfigData.allCfgs[ConfigData.TIANFU];
			var attadd:int = 0;
			var defadd:int = 0;
			var speedadd:int = 0;
			var hpadd:int = 0;
			var cdadd:int = 0;
			var id:int = 3;
			if(tianfu[id] > 0 && cfg[id][tianfu[id]]){
				attadd = cfg[id][tianfu[id]].att;
			}
			id = 4;
			if(tianfu[id] > 0 && cfg[id][tianfu[id]]){
				defadd = cfg[id][tianfu[id]].def;
			}
			id = 2;
			if(tianfu[id] > 0 && cfg[id][tianfu[id]]){
				speedadd = cfg[id][tianfu[id]].speed;
			}
			id = 1;
			if(tianfu[id] > 0 && cfg[id][tianfu[id]]){
				hpadd = cfg[id][tianfu[id]].hp;
			}
			id = 8;
			if(tianfu[id] > 0 && cfg[id][tianfu[id]]){
				cdadd = cfg[id][tianfu[id]].cd;
			}
			var data:Object = new Object();
			data.maxHp = BASE_HP + hpadd;
			data.hp = data.maxHp;
			data.def = BASE_DEF + defadd;
			data.att = BASE_ATT + attadd;
			data.speed = BASE_SPEED + speedadd;
			data.cd = BASE_CD + cdadd;
			return data;
		}
		
	}
}