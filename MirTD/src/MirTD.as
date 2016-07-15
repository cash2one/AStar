package
{
	import com.core.Facade;
	import com.sh.game.global.Config;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author MiaoTheWhite
	 * 创建时间：2015-7-30 下午5:25:24
	 * 
	 */
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class MirTD extends Sprite
	{
		public function MirTD()
		{
			Config.debug = false;
			if(this.stage)
				init(null);
			else
				this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private var _game:Game;
		
		private function init(e:Event):void{
			GlobalLayer.instance.init(this.stage);
			_game = new Game();
			_game.initGame(this.stage);
		}
		
	}
}