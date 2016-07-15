package com.rpg.scene
{
	import com.rpg.framework.GameTime;
	import com.rpg.scene.SceneLayer;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-6-5 下午5:16:03
	 * 
	 */
	public class RoleSceneLayer extends SceneLayer
	{
		public function RoleSceneLayer(sortlayer:Boolean=true)
		{
			super(sortlayer);
		}
		
		/**
		 * 排序间隔时间
		 */
		private var _sortTime:int = 0;
		private var _passtime:int = 0;
		/**
		 * 元素数量 
		 */
		public var eleCount:int;
		/**
		 * 更新当前层元素数量
		 * 修改排序策略
		 * 如果数量大于100个，500毫秒更新排序
		 */
		public function updateElementCount():void{
			eleCount = components.length;
			if(eleCount > 100) {
				_sortTime = 1000;
			}else
				_sortTime = 500;
		}
		
		protected override function checkSort(gameTime:GameTime):void{
			_passtime += gameTime.elapsedGameTime;
			if(_passtime > _sortTime){
				_passtime = 0;
				super.checkSort(gameTime);
			}
		}
	}
}