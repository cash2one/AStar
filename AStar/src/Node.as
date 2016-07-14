package
{
	import ascb.util.NumberFormat;

	public class Node
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean=true;//是否可穿越（通常把障碍物节点设置为false）
		public var parent:Node;
		public var costMultiplier:Number=1.0;//代价因子
		
		public function Node(x:int, y:int)
		{
			this.x=x;
			this.y=y;
		}
		
		//方便调试输出用的toString函数
		public function toString():String{  
			var fmr:NumberFormat = new NumberFormat();
			fmr.mask = "#.0";
			return "x=" + this.x.toString() + ",y=" + this.y.toString() + ",g=" + fmr.format(this.g) + ",h=" + fmr.format(this.h) + ",f=" + fmr.format(this.f);
		}
	}
}