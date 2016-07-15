package com.sh.game.util
{
	/**
	 * 位运算代替boolean型数组。。。
	 * 至于最高多少位，2的几次方是uint最大值？
	 * @author Administrator
	 * 
	 */
	public class BooleanArray
	{
		private var keys:uint = 0;
		public function BooleanArray(value:uint = 0)
		{
			this.keys = value;
		}
		
		public function setValue(index:int,value:Boolean = true):void{
			if(value)
				keys = keys | Math.pow(2,index);
			else if(getValue(index))
				keys = keys ^ Math.pow(2,index);
		}
		
		public function setAll(value:uint = 0):void{
			this.keys = value;
		}
		
		public function getValue(index:int):Boolean{
			return (keys & Math.pow(2,index)) >> index == 1;
		}
		public function getKey():uint
		{
			return keys;
		}
	}
}