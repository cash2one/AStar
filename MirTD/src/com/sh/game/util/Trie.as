package com.sh.game.util
{
	import flash.utils.Dictionary;
	
	/**
	 * 某东一怒之下写的一个树结构，管理树形数据，支队字符串有用其他的不考虑
	 * @author saint
	 * 2014.9.12
	 */	
	public class Trie
	{
		/**
		 * 树数据
		 */		
		private var trieDic:Dictionary = new Dictionary();
		/**
		 * 某构造器
		 */		
		public function Trie(){		}
		/**
		 * 添加一个信息
		 * @param value 信息字符串
		 */		
		public function add(value:String):void
		{
			var len:int = value.length;
			var curDic:Dictionary = trieDic;
			for (var i:int = 0; i < len; i++) 
			{
				var ch:String = value.charAt(i);
				var dic:Dictionary = curDic[ch];
				if(!dic)
				{
					curDic[ch] = dic = new Dictionary();
				}
				curDic = dic;
			}
			if(!curDic[""])//定制节点
			{
				curDic[""] = new Dictionary();
			}
		}
		
		/**
		 * 添加一个信息
		 * @param value 信息字符串
		 */		
		public function multAdd(values:Array):void
		{
			for each (var value:String in values) 
			{
				add(value);
			}
		}
		/**
		 * 获取的存储的数据
		 * @return 
		 */		
		public function getRoot():Dictionary
		{
			return trieDic;
		}
		/**
		 * 输出每一行信息，用于测试的，小朋友们不要乱用
		 */		
		public function traceEach():void
		{
			doTrace(trieDic,"");
		}
		/**
		 * 迭代输出每一行
		 * @param dic 对待的字典
		 * @param value 信息数据
		 */		
		private function doTrace(dic:Dictionary, value:String):void
		{
			for(var key:String in dic) 
			{
				if(key == "")
				{
					trace(value)
				}
				else
				{
					doTrace(dic[key],value+key);
				}
			}
		}
		
	}
}

