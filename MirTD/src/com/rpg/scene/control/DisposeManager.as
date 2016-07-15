package com.rpg.scene.control
{
	import com.rpg.enum.Constant;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IDisposable;
	import com.rpg.framework.ITweenRender;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.actor.Effect;
	
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-20 下午1:32:18
	 * 
	 */
	public class DisposeManager implements ITweenRender
	{
		private var _disposeList:Vector.<IDisposable>;
		private var _effects:Vector.<Effect>;
		public function DisposeManager()
		{
			_disposeList = new Vector.<IDisposable>();
			_effects = new Vector.<Effect>();
		}
		
		private static var _instance:DisposeManager = null;
		
		public static function get instance():DisposeManager{
			if(_instance == null){
				_instance = new DisposeManager();
			}
			return _instance;
		}
		
		public function render(gameTime:GameTime):Boolean
		{
			for each (var disposer:IDisposable in _disposeList) 
			{
				if(disposer != null)
					disposer.dispose();
			}
			_disposeList.length = 0;
			for each (var effect:Effect in _effects) 
			{
				if(!effect.reseted)
					ObjectPoolManager.getInstance().returnItem(Constant.EffectClass,effect);
			}
			_effects.length = 0;
			return false;
		}
		
		public function disposeLater(disposer:IDisposable):void{
			this._disposeList.push(disposer);
		}
		
		public function disposeEffectLater(disposer:Effect):void{
			this._effects.push(disposer);
		}
		
		public function get enabled():Boolean
		{
			return true;
		}
	}
}