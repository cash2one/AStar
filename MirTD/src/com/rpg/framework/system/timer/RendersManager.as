package com.rpg.framework.system.timer
{
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IDisposable;
	import com.rpg.framework.ITweenRender;
	import com.rpg.framework.IUpdateable;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-11 上午10:48:03
	 * 场景主循环外部渲染器，执行于主循环之后
	 */
	public class RendersManager implements IUpdateable
	{
		private var updatePlus:Vector.<ITweenRender>;
		
		private static var _instance:RendersManager = null;
		
		
		public static function get instance():RendersManager{
			if(_instance == null){
				_instance = new RendersManager();
			}
			return _instance;
		}
		
		public function RendersManager()
		{
			updatePlus = new Vector.<ITweenRender>();
		}
		
		
		public function addCompnent(render:ITweenRender):void{
			var index:int = this.updatePlus.indexOf(render);
			if(index == -1)
				this.updatePlus.push(render);
		}
		
		public function removeCompnent(render:ITweenRender):void{
			var index:int = this.updatePlus.indexOf(render);
			if(index > -1){
				updatePlus.splice(index,1);
			}
		}
		
		public function update(gameTime:GameTime):void
		{
			var i:int = updatePlus.length - 1;
			while(i>=0){
				var updateable :ITweenRender = updatePlus[i];
				/*if (updateable.enabled)
				{*/
					if(updateable.render(gameTime)){
						updatePlus.splice(i,1);
					}
				//}
				i--;
			}
		}
		
		public function get enabled():Boolean
		{
			return true;
		}
	}
}