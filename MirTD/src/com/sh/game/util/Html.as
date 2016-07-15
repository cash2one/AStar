package com.sh.game.util
{
	import com.core.utils.StringUtil;

	public class Html
	{
		public function Html()
		{
		}
		
		/**
		 * 简化标签使用 <br>
		 * '''加粗''' => <b>加粗</b><br>
		 * ''斜体'' => <i>斜体</i><br>
		 * $ => 换行<br>
		 * {FF0000#12#颜色} => <font color=“#FF0000”/>颜色</font><br>
		 * [eventstr content] => <a href='event:eventstr'>content</a> [story,1001 战役]
		 * @param str
		 * @return 
		 * 
		 */		
		public static function covert(str:String):String
		{
			if(str == null || StringUtil.isEmpty(str) || StringUtil.mayBeNULL(str)){
				return "";
			}
			var pre:Array = [];
			var pretag:String = "";
			var newstr:String = "";
			var linkobj:Array = new Array(3);
			var ischange:Boolean = false;
			for(var i:int = 0;i<str.length;){
				if(ischange){
					newstr += str.charAt(i);
					i++;
					ischange = false;
					continue;
				}
				if(str.charAt(i) == "\\"){
					ischange = true;
					i++;
					continue;
				}
				if(str.substr(i,3) == "'''"){
					pretag = "<b>";
					i+=3;
					if(pre[0] == pretag){
						pretag = '</b>';
						pre.shift();
					}
					else
					{
						pre.unshift(pretag);
					}
					newstr += pretag;
				}
				else if(str.substr(i,2) == "''"){
					pretag = "<i>";
					i+=2;
					if(pre[0] == pretag){
						pretag = '</i>';
						pre.shift();
					}
					else
					{
						pre.unshift(pretag);
					}
					newstr += pretag;
				} else if(str.charAt(i) == "$"){
					newstr += "<br>";
					i++;
				} else if(str.charAt(i) == "{"){
					var endindex:int = str.indexOf("}",i);
					if(endindex<=i){
						endindex = str.length;
					}
					var fontstr:String = str.substr(i+1,endindex-i-1);
					var arr:Array = fontstr.split("#");
					if(arr.length == 2){
						newstr += "<font color='#"+arr[0]+"'>"+arr[1]+"</font>";
					}
					else if(arr.length == 3){
						newstr += "<font color='#"+arr[0]+"' size='"+arr[1]+"'>"+arr[2]+"</font>";
					}
					else if(arr.length == 1)
					{
						newstr += fontstr;
					}
					i = endindex+1;
				} else if(str.charAt(i) == "["){
					var nextindex:int = str.indexOf(' ',i);
					if(nextindex == -1){
						i++;
					}
					else
					{
						var link:String = str.substr(i+1,nextindex-i-1);
						newstr += "<U><a href='event:"+link+"'>";
						i+=nextindex-i+1;
					}
				} else if(str.charAt(i) == "]"){
					newstr += "</a></U>";
					i++;
				} else {
					newstr += str.charAt(i);
					i++;
				}
			}
			return newstr;
		}
	}
}