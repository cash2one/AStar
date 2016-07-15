package com.sh.game.util
{
	public class TimeDataFormatUtil
	{
		public static function getTimeStr(tme:int):String
		{
			if(tme <= 0)
				return "";
			var date:Date = new Date(tme * 1000);
			var year:int=date.getFullYear()-2000;
			var ret:String="";
			if(year<10)
			{
				ret+="0";
			}
			ret+=year.toString()+"年";
			//月
			var month : int = date.getMonth();
			month++;
			if (month < 10)
			{
				ret += "0" + month.toString(); 
			}
			else
			{
				ret += month.toString();
			}
			ret += "月";
			//日
			var day:int = date.getDate();
			if (day < 10)
			{
				ret += "0" + day.toString();
			}
			else
			{
				ret += day.toString();
			}
			ret += "日"+" ";
			//时
			var hour:int = date.getHours();
			if (hour < 10)
			{
				ret += "0" + hour.toString();
			}
			else
			{
				ret += hour.toString();
			}
			ret += ":";
			//分
			var minute:int = date.getMinutes();
			if (minute < 10)
			{
				ret += "0" + minute.toString();
			}
			else
			{
				ret += minute.toString();
			}
			return ret;
		}		
		public static function getTimeStr1(time:int):String
		{
			if(time <= 0)
				return "";
			var date:Date = new Date(time * 1000);
			var year:int=date.getFullYear()-2000;
			var ret:String="";
			if(year<10)
			{
				ret+="0";
			}
			ret+=year.toString()+"-";
			//			月
			var month : int = date.getMonth();
			month++;
			if (month < 10)
			{
				ret += "0" + month.toString(); 
			}
			else
			{
				ret += month.toString();
			}
			ret += "-";
			//日
			var day:int = date.getDate();
			if (day < 10)
			{
				ret += "0" + day.toString();
			}
			else
			{
				ret += day.toString();
			}
			return ret;
		}		
		public static function getTimeHour(time:int):String
		{
			if(time <= 0)
				return "";
			var ret:String="";
			var date:Date = new Date(time * 1000);
			//			小时
			var hour : int = date.getHours();
			ret +=hour.toString()+":";
			//分钟
			var Min:int = date.getMinutes();
			if(Min==0)
				ret +="00";
			else
				ret +=Min.toString();
			return ret;
		}		
		public static function getLeftTimeStr(time:int):String
		{
			if(time <= 0)
				return "--";
			var des:String = '';
			var h:int = Math.floor(time/3600);
			if(h>0)
				des = h.toString() + "小时";
			time = time - h*3600;
			h=Math.floor(time/60);
			if(h>0)
				des += h.toString() + "分";
			time = time - h * 60;
			if(time > 0)
				des += time.toString() + "秒";        		
			return des;		
		}
		
		public static function getLeftTimeStr3(time:int):String
		{
			if(time <= 0)
				return "--";
			var des:String = '';
			var h:int=Math.floor(time/60);
			if(h>0)
				des += h.toString() + "分";
			time = time - h * 60;
			if(time > 0)
				des += time.toString() + "秒";        		
			return des;		
		}
		
		public static function getLeftTimeStr1(time:int):String
		{
			if(time <= 0)
				return "--";
			var des:String = '';
			var h:int = Math.floor(time/3600);
			if(h>0)
				des = h.toString() + "小时";
			time = time - h*3600;
			h=Math.floor(time/60);
			if(h>0)
				des += h.toString() + "分";
			return des;		
		}
		public static function getLeftTimeStr2(time:int,num:int=3):String
		{
			if(time <= 0)
				return "--";
			var des:String = '';
			var day:int = Math.floor(time/(3600 * 24));//天
			time = time - day * (3600 * 24);
			if(day > 0)
				des = day.toString() + "天";
			if(num==1){
				return des;	
			}
			var h:int = Math.floor(time/3600);
			if(h>0)
				des += h.toString() + "小时";
			if(num==2){
				return des;		
			}
			time = time - h*3600;
			h=Math.floor(time/60);
			if(h>0)
				des += h.toString() + "分";
			return des;		
		}
		public static function getLeftTimeStr4(time:int,num:int=3):String
		{
			if(time <= 0)
				return "--";
			var des:String = '';
			var day:int = Math.floor(time/(3600 * 24));//天
			time = time - day * (3600 * 24);
			if(day > 0)
				des = day.toString() + "天";
			if(num==1){
				return des;	
			}
			var h:int = Math.floor(time/3600);
			if(h>0)
				des += h.toString() + "时";
			if(num==2){
				return des;		
			}
			time = time - h*3600;
			h=Math.floor(time/60);
			if(h>0)
				des += h.toString() + "分";
			return des;		
		}
		public static function getLeftTime(time:int):String
		{
			if(time <= 0)
				return "00:00:00";
			var des:String = '';
			var h:int = Math.floor(time/3600);
			if(h>0){
				des += h.toString() + ":";
			}else 
			{
				des+= "00:";
			}
			time = time - h*3600;
			var m:int=Math.floor(time/60);
			if(m>=10)
				des += m.toString() + ":";
			if(m<=9)
				des +="0"+m.toString()+":";
			time = time - m * 60;
			if(time >= 10)
				des += time.toString();
			if(time<=9)
				des += "0"+time.toString();
			return des;	
		}
		public static function getLeftTime2(time:int):String
		{
			if(time <= 0)
				return "00:00:00";
			var des:String = '';
			var h:int = Math.floor(time/3600);
			if(h<10)
				des = "0"+h.toString() + ":";
			else
				des = h.toString() + ":";
			time = time - h*3600;
			h=Math.floor(time/60);
			if(h<10)
				des += "0"+h.toString() + ":";
			else
				des += h.toString() + ":";
			time = time - h * 60;
			if(time < 10)
				des += "0"+time.toString();     
			else
				des += time.toString();     
			return des;		
		}
	}
}