package com.rpg.pool
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 对象池 
	 * @author mtw
	 * 
	 */
	public class ObjectPoolManager
	{
		//dictionary
		private var pools:HashMap=new HashMap();
		private var _maxDic:Dictionary = new Dictionary();
		//private var _useingCount:Dictionary = new Dictionary();
		
		/**
		 * @param classType:ClassName String
		 * @param maxSize
		 */        
		public function initPool(classType:String,maxSize:int):void
		{
			//create all item by once
			//trace("Created pool of "+classType);
			if(pools.containsKey(classType))
				return;
			var itemAry:Array=[];
			pools.add(classType,itemAry);
			_maxDic[classType] = maxSize;
			//_useingCount[classType] = 0;
		}
		/**
		 * 使用完了丢回池子里，池子满了的话就直接销毁 
		 * @param classType
		 * @param item
		 * 
		 */
		public function returnItem(classType:String,item:IPoolItem):void
		{
			if(!pools.containsKey(classType))
			{
				throw new Error("Not find："+classType+" pool");
				return;
			}
			//trace("Give back item："+classType);
			//_useingCount[classType]--;
			item.reset();
			var clsarr:Array = pools.getValue(classType);
			if(_maxDic[classType] > clsarr.length)
				clsarr.push(item);
			else
				item.dispose();
		}
		/**
		 * 获得实例，池子里没有就new一个
		 * @param classType：
		 * @return 
		 */        
		public function borrowItem(classType:String):IPoolItem
		{
			if(!pools.containsKey(classType))
			{
				throw new Error("Not find："+classType+" pool");
			}
			//_useingCount[classType]++;
			if((pools.getValue(classType) as Array).length==0)
			{
				var cls:Class=getDefinitionByName(classType) as Class;
				return new cls();
			}
			return (pools.getValue(classType) as Array).pop();
		}
		/**
		 * 销毁一个池 
		 * @param classType
		 * 
		 */
		public function disposePool(classType:String):void
		{
			if(!pools.containsKey(classType))
				return;
			var itemAry:Array=pools.getValue(classType) as Array;
			for(var i:int=0;i<itemAry.length;i++)
			{
				(itemAry[i] as IPoolItem).dispose();
			}
			itemAry=null;
			pools.remove(classType);
		}
		public function ObjectPoolManager(_sig:Sig)
		{
		}
		private  static var _instance:ObjectPoolManager;
		public static function getInstance():ObjectPoolManager
		{
			if(!_instance)
				_instance=new ObjectPoolManager(new Sig());
			return _instance;
		}
	}
}
final class Sig{}