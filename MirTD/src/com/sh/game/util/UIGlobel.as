package com.sh.game.util
{
	import com.core.ModelProxy;
	import com.core.utils.StringTrie;
	

	public class UIGlobel
	{
		public static var Dragtexturestr:String = "s9_frame";
		public static function minggan(str:String):Boolean
		{
			var st:StringTrie = ModelProxy.getValue('data','configs1.banednames');
			var newtext:String = st.replaceAll(str);
			if(newtext !=str){
				return true;
			}
			return false;
		}
		
		/**
		 * 
		 * @param type
		 * 1、道具，2装备，3技能
		 */		
		public static function getItemd(type:int):String
		{
			var t:String = "assets/images/icon/tools/";
			var s:String = "assets/images/icon/skill/";
			var a:String = "assets/images/arms/";
			var d:String = "";
			if(type==2){
				d = t;
			}else if(type == 1){
				d = t;
			}else if(type == 3){
				d = s;
			}
			
			return d;
		}
		public static function getItemd2(data:Object):String
		{
			var d:String = "assets/images/icon/tools/";
			var s:String = "assets/images/icon/skill/";
			if(!data.hasOwnProperty("itemid"))
			{
				d = s;
			}
			return d;
		}
		public static function setNumTxt(value:int = 0):String
		{
			var newstr:String = "";
			var valuestr:String = value.toString();
			var len:int =valuestr.length;
			for(var i:int = len;i>=0;i--){  
				newstr =valuestr.charAt(i)+newstr;
				if((len-i)%3==0&&i!=len&&i!=0){
					newstr=","+newstr;
				}
			}
			return newstr;
		}
		/** 
		 *频道类别 
		 * 1商贸 深蓝色
		 * 2世界 黄色1
		 * 3普通 白色
		 * 4队伍 浅蓝色
		 * 5行会 绿色
		 * 6私聊 粉红色
		 * 7喇叭 橙色 
		 */	
		public static function chanel2color(type:int):uint
		{
			var color:uint;
			switch(type){
				case 1:
					color = 0xcd27a5;
					break;
				case 2:
					color = 0xe1a022;
					break;
				case 3:
					color = 0xffe4c7;
					break;
				case 4:
					color = 0x4ca0e0;
					break;
				case 5:
					color =0x54b437;
					break;
				case 6:
					color = 0xce6fa9; 
					break;
				case 7:
					color = 0xf47a17;
					break;
				default:
					color = 0xcc2541;
					break;
			}
			return color
		}
		public static function chanel2color2(type:int):String
		{
			var color:String = "";
			switch(type){
				case 1:
					color = "#cd27a5";
					break;
				case 2:
					color = "#e1a022";
					break;
				case 3:
					color = "#ffe4c7";
					break;
				case 4:
					color = "#4ca0e0";
					break;
				case 5:
					color ="#54b437";
					break;
				case 6:
					color = "#ce6fa9"; 
					break;
				case 7:
					color = "#f47a17";
					break;
				default:
					color = "#cc2541";
					break;
			}
			return color
		}
		/** 
		 *频道类别 
		 * 1商贸 深蓝色
		 * 2世界 黄色
		 * 3普通 白色
		 * 4队伍 浅蓝色
		 * 5行会 绿色
		 * 6私聊 粉红色
		 * 7喇叭 橙色 
		 */	
		public static function chanelToname(type:int):String
		{
			var name:String
			switch(type){
				case 1:
					name = "商贸";
					break;
				case 2:
					name = "世界";
					break;
				case 3:
					name = "普通";
					break;
				case 4:
					name = "队伍";
					break;
				case 5:
					name = "行会";
					break;
				case 6:
					name = "私聊";
					break;
				
				case 7:
					name = "喇叭";
					break;
				case 8:
					name = "系统";
					break;
			}
			return name
		}
		
		public static function getCareer(num:int):String
		{
			var str:String = "通用";
			switch(num)
			{
				case 0:
				{
					str = "通用"
					break;
				}
				case 1:
				{
					str = "战士"
					break;
				}
				case 2:
				{
					str = "法师"
					break;
				}
				case 3:
				{
					str ="道士"
					break;
				}
					
				default:
				{
					break;
				}
			}
			return str;
		}
		public static function getPosName(pos:int):String
		{
			var str:String ="";
			switch(pos)
			{
				case 1:
				{
					str = "武器"
					break;
				}
				case 2:
				case 9:
				{
					str = "戒指"
					break;
				}
				case 3:
				case 10:
				{
					str = "护腕"
					break;
				}
				case 4:
				{
					str = "头盔"
					break;
				}
				case 5:
				{
					str = "衣服"
					break;
				}
				case 6:
				{
					str = "鞋子"
					break;
				}
				case 7:
				{
					str = "腰带"
					break;
				}
				case 8:
				{
					str = "项链"
					break;
				}
				case 11:
				{
					str = "官印"
					break;
				}
				case 15:
				{
					str = "倚天"
					break;
				}
				case 14:
				{
					str = "特戒"
					break;
				}
				case 12:
				{
					str = "护身符"
					break;
				}
				case 13:
				{
					str = "勋章"
					break;
				}
				case 101:
				{
					str = "坐骑缰绳"
					break;
				}
				case 102:
				{
					str = "坐骑马鞍"
					break;
				}
				case 103:
				{
					str = "坐骑战蹄"
					break;
				}
				case 104:
				{
					str = "坐骑盔甲"
					break;
				}
				case 201:
				{
					str = "羽翼之魂"
					break;
				}
				case 202:
				{
					str = "羽翼之魄"
					break;
				}
				case 203:
				{
					str = "羽翼之灵"
					break;
				}
				case 204:
				{
					str = "羽翼之怒"
					break;
				}
					
				default:
				{
					break;
				}
			}
			return str;
		}
		public static function ToolType(pos:int):String
		{
			var str:String ="";
			switch(pos)
			{
				case 1:
				{
					str = "药品类"
					break;
				}
				case 2:
				{
					str = "消耗类"
					break;
				}
				case 3:
				{
					str = "经验丹"
					break;
				}
				case 4:
				{
					str = "经验珠"
					break;
				}
				case 5:
				{
					str = "经验卷轴"
					break;
				}
				case 6:
				{
					str = "传送类"
					break;
				}
				case 7:
				{
					str = "宝箱类"
					break;
				}
				case 8:
				{
					str = "召唤书"
					break;
				}
				case 9:
				{
					str = "技能书"
					break;
				}
				case 10:
				{
					str = "任务类"
					break;
				}
				case 11:
				{
					str = "材料类"
					break;
				}
				case 22:
				{
					str = "时装类"
					break;
				}
				case 21 :
				{
					str = "资质丹"
					break;
				}
				case 23 :
				{
					str = "书籍"
					break;
				}
				default:
				{
					break;
				}
			}
			return str;
		}
		
		
		public static function getSex(type:int):String
		{
			switch(type)
			{
				case 0:
					return "女";
					break;
				case 1:
					return "男";
					break;
			}
			return "通用";
		}
		public static var ch_num:Array = ["零","一","二","三","四","五","六","七","八","九"];
		
		public static var pointsDic:Object = new Object;
		public static function nummax(num:Number):int
		{
			return int(num>>32);
		}
		public static function numTarget(num:Number):int
		{
			var min:int = num;
			var max:int = num>>32;
			return min+max;
		}
		
	}
}