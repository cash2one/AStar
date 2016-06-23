package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.osmf.layout.ScaleMode;

	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class AStar extends Sprite
	{
		public static var HORIZONTAL:int = 40;//横格子个数
		public static var VERTICAL:int = 30;//横格子个数
		public static var WIDTH:int = 20;
		public static var LINESTYLE:int = 1;
		public static var LINECOLOR:int = 0xffffff;
		/**
		 * 
		 * 
		 */		
		public function AStar()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var spr:Sprite = new Sprite();
			addChild(spr);
			
			spr.graphics.beginFill(LINECOLOR);
			spr.graphics.lineStyle(LINESTYLE);
			for(var i:int = 0; i <= HORIZONTAL; i++)
			{
				spr.graphics.moveTo(i*WIDTH,0);
				spr.graphics.lineTo(i*WIDTH,VERTICAL*WIDTH);
			}
			
			for(i = 0; i <= VERTICAL; i++){
				spr.graphics.moveTo(0,i*WIDTH);
				spr.graphics.lineTo(HORIZONTAL*WIDTH,i*WIDTH);
			}
			
			spr.graphics.endFill();
			
			//s
		}
		
		public function s(s:int):int{
			return s;
		}
			
		
	}
}