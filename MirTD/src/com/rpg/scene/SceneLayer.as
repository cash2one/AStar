package com.rpg.scene
{
	import com.rpg.entity.Body;
	import com.rpg.entity.GameSprite;
	import com.rpg.framework.GameTime;
	import com.sh.game.consts.DirectionType;
	
	
	/** 场景图层数据 */
	public class SceneLayer extends GameSprite
	{
		protected var _needSort:Boolean = false;
		/**
		 * 要排序的场景 
		 */
		private var _sort:Boolean = true;
		public function SceneLayer(sortlayer:Boolean = true)
		{
			_sort = sortlayer;
			this.display.mouseChildren = true;
		}

		public override function initialize() : void
		{
			_initialized = true;
			this.enabled = true;
		}
		
		public override function addChild(item : GameSprite) : void
		{
			super.addChild(item);
			if(_sort && item is Body)
				needSort();
		}
		
		public function needSort():void{
			this._needSort = true;
		}
		
		public override function update(gameTime:GameTime):void{
			checkSort(gameTime);
			super.update(gameTime);
		}
		
		protected function checkSort(gameTime:GameTime):void{
			if(_needSort){
				this.depthSort();
				_needSort = false;
			}
		}
		
		private var _curindex:int = 0;

		/** 元件深度交换 */
		public function depthSort(e : GameSprite = null, upOrDown : int = DirectionType.NONE) : void
		{
			try
			{
				this.components.sortOn("depth", Array.NUMERIC);
				
				var start : int;
				var end   : int;
				if(e!= null){
					if (upOrDown == DirectionType.UP)
					{
						start = this.components.indexOf(e)
						end   = this.components.length;
					}
					else if (upOrDown == DirectionType.DOWN)
					{
						start = 0;
						end   = this.components.indexOf(e);
					}
					else
					{
						start = 0;
						end   = this.components.length;
					}
				}else{
					start = 0;
					end   = this.components.length;
				}
	
				var currentComponents : Array = this.components.source;
				_curindex = 0;
				for (var i : int = start; i < end; i++)
				{
					if(currentComponents[i] != null && currentComponents[i].inView){
						this.display.setChildIndex(currentComponents[i].display,_curindex);
						_curindex++;
					}
				}
			}
			catch (error : Error)
			{
				trace(this, "depthSort", error.message);
			}
		}

		/** 清除层上的元件  */
		public override function clear() : void
		{
			super.clear();
			while (this.display.numChildren != 0)
			{
				this.display.removeChildAt(this.display.numChildren - 1);
			}
		}

		public override function dispose() : void
		{
			while (this.display.numChildren != 0)
			{
				this.display.removeChildAt(this.display.numChildren - 1);
			}
			super.dispose();
		}
	}
}