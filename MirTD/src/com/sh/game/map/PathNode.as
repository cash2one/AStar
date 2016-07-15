package com.sh.game.map
{
	import flash.utils.Dictionary;

	public class PathNode
	{
		public var id:String = "";
		public var neighbours:Vector.<PathNode>;
		
		
		public var x:int = 0;
		public var y:int = 0;
		
		private var _width:int;
		private var _height:int;
		
		public var locateX:int;
		public var locateY:int;
		
		public var length:Number;
		
		public function PathNode(x:int,y:int,width:int,height:int)
		{
			this.x = x;
			this.y = y;
			this._height = height;
			this._width = width;
			locateX = this._width * x
			locateY = this._height * y;
		}
		
		public function initNeighbours(nodes:Dictionary):void{
			neighbours = new Vector.<PathNode>();
			for each(var n:Array in PathLayer.eigthArr){
				var node:PathNode = nodes[n[0] + "_" + n[1]];
				this.neighbours.push(node);
			}
		}
	}
}