package com.core
{
	import com.core.inter.IControl;
	
	import flash.utils.Dictionary;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午7:28:31
	 * 
	 */
	public class Facade
	{
		private static var _instance:Facade;
		private var _controls:Array;
		private var _models:Array;
		private var _views:Array;
		public function Facade()
		{
			this._models = new Array();
			this._controls = new Array();
			this._views = new Array();
		}
		public static function get instance():Facade{
			if(!_instance)
				_instance = new Facade();
			return _instance;
		}
		
		/**
		 * 获得全局数据 
		 * @param name
		 * @return 
		 */
		public function getModel(name:int):*{
			return _models[name];
		}
		
		/**
		 * 存储全局数据
		 * @param name
		 * @param data
		 */
		public function setModel(name:int,data:*):void{
			this._models[name] = data;
		}
		
		public function getView(name:int):Object{
			return _views[name];
		}
		
		public function setView(name:int,data:Object):void{
			this._views[name] = data;
		}
		
		/**
		 * 对某个命令组添加观察 ,事件的简化
		 * @param target
		 * @param control
		 */
		public function addObserver(group:int,control:IControl):void{
			if(!this._controls[group]){
				this._controls[group] = new Vector.<IControl>();
				this._controls[group].push(control);
			}else{
				if(this._controls[group].indexOf(control) < 0){
					this._controls[group].push(control);
				}
			}
		}
		
		/**
		 * 移除观察 
		 * @param target
		 * @param control
		 */
		public function removeObserver(group:int,control:IControl):void{
			if(this._controls[group]){
				var index:int = this._controls[group].indexOf(control);
				if(index > -1)
					this._controls[group].splice(index,1);
			}
		}
		
		/**
		 * 广播消息 ，通知所有观察者
		 * @param group
		 * @param command
		 * @param data
		 */
		public function sendNotification(group:int,command:int,data:* = null):void{
			if(_controls[group]){
				var vec:Vector.<IControl> = this._controls[group];
				for each (var control:IControl in vec) 
				{
					control.update(group,command,data);
				}
			}
		}
	}
}