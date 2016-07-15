package com.rpg.framework
{
	import com.rpg.framework.utils.Timer;

	public class FpsItem extends DrawableGameComponent
	{
		private var _frames		: Number    = 0;
		private var _fps	    : int   	= 0;
		private var _timer	 	: Timer;
		private var _count		: int		= 0;
		private var _fpscount	: int		= 0;
		private var _basefps	: int		= 30

		public function FpsItem()
		{
			super();
		}
		public override function initialize():void
		{
			this._timer 				   = new Timer(1000);
			super.initialize();
		}

		public override function update(gameTime:GameTime):void
		{
			if(this._timer.heartbeat(gameTime)) 
			{
				_fps   		= _frames;
				_frames		= 0;
				if(_fps<_basefps)
					_fpscount++;
				_count++;
			}
			else
			{
				_frames++;
			}
		}
		public function lastdeal():void
		{
			if(_fpscount*3/2>_count)
			{
				this.display.stage.frameRate = _basefps;
			}
		}
	}
}