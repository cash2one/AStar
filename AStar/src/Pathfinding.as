package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor=0xffffff,width=360,height=240)]
	public class Pathfinding extends Sprite
	{
		private var _grid:Grid;
		private var _gridView:GridView;
		
		public function Pathfinding()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			_grid=new Grid(8, 5);
			_grid.setStartNode(1, 1);
			_grid.setEndNode(6, 3);
			
			//设置障碍物
			_grid.getNode(4,0).walkable = false;
			_grid.getNode(4,1).walkable = false;
			_grid.getNode(4,2).walkable = false;
			_grid.getNode(4,3).walkable = false;
			
			_gridView=new GridView(_grid);
			_gridView.x=20;
			_gridView.y=20;
			addChild(_gridView);
		}
	}
}