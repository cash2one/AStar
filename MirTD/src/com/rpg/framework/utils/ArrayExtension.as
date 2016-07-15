package com.rpg.framework.utils
{
	public class ArrayExtension
	{
		/** 
		 * 返回一个数组，从第一个数字到第二个数间的数组
		 * createBetweenTwoNumbersArray（3,5）
		 * 返回数组 3，4，5
		 */
		public static function createBetweenTwoNumbersArray(n01:uint, n02:uint):Array 
		{
			var local2:Array = new Array();
			var local1:uint = n01;
			while (local1 <= n02) 
			{
				local2.push(local1);
				local1++;
			}
			return local2;
		}
		/** 
		 * 将数组2的内容，加到数组1中，返回一个新的数组
		 * var arr01:Array=new Array(1,2,3)
		 * var arr02:Array=new Array(4,5,6)
		 * var arr03:Array=addArray(arr01,arr02)
		 * 返回数组 1,2,3,4,5,6
		 */
		public static function addArray(ary01:Array, ary02:Array):Array 
		{
			var i:uint = 0;
			while (i < ary02.length) 
			{
				ary01.push(ary02[i]);
				i++;
			}
			return ary01;
		}
		
		/** 
		 * 从 参数(数组) 中 返回一个数组
		 * 返回的数组中没有重复的项目
		 * var arr01:Array=new Array(1,2,3)
		 * var arr02:Array=new Array(2,3,6)
		 * var arr03:Array=noRepeatArray(arr01,arr02)
		 * 返回数组 1,2,3,6
		 */
		public static function noRepeatArray(ary:Array):Array 
		{
			var array:Array = new Array (0);
			var i:uint = 0;
			while (i < ary.length) 
			{
				var boolean:Boolean = false;
				var j:uint = 0;
				while (j <array.length) 
				{
					if (array[j] == ary[i]) 
					{
						boolean = true;
						break;
					}
					j++;
				}
				if (!boolean) 
				{
					array.push(ary[i]);
				}
				i++;
			}
			return array;
		}
		
		/** 
		 * 从 参数a_ary 中 寻找 参数b_ary 中不存在的项目
		 * 返回的数组为 两个参数数组中 都不存在的项目组成的数组
		 * var arr01:Array=new Array(1,2,3)
		 * var arr02:Array=new Array(2,3,6)
		 * var arr03:Array=uniquArray(arr01,arr02)
		 * 返回数组 1,6
		 */
		public static function uniquArray(a_ary:Array, b_ary:Array):Array 
		{
			var array:Array = new Array ();
			var i:uint = 0;
			while (i < a_ary.length) 
			{
				var boolean:Boolean = true;
				var j:uint = 0;
				while (j < b_ary.length) 
				{
					if (b_ary[j] == a_ary[i]) 
					{
						boolean = false;
						break;
					}
					j++;
				}
				if (boolean) 
				{
					array.push(a_ary[i]);
				}
				i++;
			}
			return array;
		}
	
		/** 
		 * 返回数组中的数字合计值
		 * var arr03:Array=new Array(1,2,3,4)
		 * 返回数字 10
		 */
		public static function countNumberArray(arr:Array):Number
		{
			var count:Number=new Number();
			for (var i:uint=0; i<arr.length; i++) 
			{
				if (arr[i] is Number) 
				{
					count+=arr[i];
				}
			}
			return count;
		}
		
		/** 
		 * 复制数组或者对象
		 * 参数 oArray 想要复制的对象或数组
		 * 参数 bRecursive 是否复制深层次的内容，false为默认值 只复制一层数组，true是则是递归复制
		 * 返回数字 一个数组
		 */	
		public static function clone(oArray:Object, bRecursive:Boolean = false):Object 
		{
      		var oDuplicate:Object;
      		if(bRecursive) 
      		{
        		if(oArray is Array) 
        		{
          			oDuplicate = new Array();
          			for(var i:Number = 0; i < oArray.length; i++) 
          			{
            			if(oArray[i] is Object) 
            			{
             				oDuplicate[i] = clone(oArray[i]);
            			}
            			else 
            			{
              				oDuplicate[i] = oArray[i];
            			}
          			}
          		return oDuplicate;
        		}
        		else 
        		{
          			oDuplicate = new Object();
          			for(var sItem:String in oArray) 
          			{
            			if(oArray[sItem] is Object && !(oArray[sItem] is String) && !(oArray[sItem] is Boolean) && !(oArray[sItem] is Number)) 
            			{
              				oDuplicate[sItem] = clone(oArray[sItem], bRecursive);
            			}
            			else 
            			{
              				oDuplicate[sItem] = oArray[sItem];
            			}
          			}
         			return oDuplicate;
        		}
			}
      		else 
      		{
        		if(oArray is Array) 
        		{
         	 		return oArray.concat();
        		}
        		else 
        		{
          			oDuplicate = new Object();
          			for(sItem in oArray) 
          			{
            			oDuplicate[sItem] = oArray[sItem];
          			}
          			return oDuplicate;
        		}
      		}
    	}
	}
}