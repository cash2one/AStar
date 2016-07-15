package com.sh.game.util
{
	import flash.geom.Point;

	/**
	 * 线段，用于计算线段是否相交，并且获得相交点
	 * @author chzcb
	 */
	public class Line
	{
		protected var _x1:Number;

		public function get x1():Number
		{
			return _x1;
		}

		public function set x1(value:Number):void
		{
			_x1 = value;
		}

		protected var _x2:Number;

		public function get x2():Number
		{
			return _x2;
		}

		public function set x2(value:Number):void
		{
			_x2 = value;
		}

		protected var _y1:Number;

		public function get y1():Number
		{
			return _y1;
		}

		public function set y1(value:Number):void
		{
			_y1 = value;
		}

		protected var _y2:Number;

		public function get y2():Number
		{
			return _y2;
		}

		public function set y2(value:Number):void
		{
			_y2 = value;
		}
		
		protected var isP:Boolean = false;
		
		public function Line(x1:Number,y1:Number,x2:Number,y2:Number)
		{
			this._x1 = x1;
			this._y1 = y1;
			this._x2 = x2;
			this._y2 = y2;
			isP = (Math.abs(this.y2-this.y1) + Math.abs(this.x2-this.x1) == 0);
		}
		
		protected var _next:Line;

		public function get next():Line
		{
			return _next;
		}

		public function set next(value:Line):void
		{
			_next = value;
		}

		
		/**
		 * 判断是否和line相交
		 */
		public function isCross(line:Line):Boolean
		{
			var inter:Point = getInter(line);
			if(inter == null)
				return false;
			if((inter.x - this.x1)*(inter.x-this.x2)<=0
				&& (inter.x - line.x1)*(inter.x-line.x2)<=0
				&& (inter.y - this.y1)*(inter.y-this.y2)<=0
				&& (inter.y - line.y1)*(inter.y-line.y2)<=0) {
				return true;
			}
			else
				return false;
		}
		
		/**
		 * 架设线段变成直线后，计算所得的相交点，不一定在线段上
		 */
		public function getInter(line:Line):Point
		{
			var inter:Point;
			if(Math.abs(this.y2-this.y1)+Math.abs(this.x2 - this.x1)
				+ Math.abs(line.y2 - line.y1) + Math.abs(line.x2 - line.x1) == 0){
				return null;
			}
			if(line.isP || this.isP)
				return null;
			if((this.y2-this.y1)*(line.x1 - line.x2) - (this.x2-this.x1) * (line.y1 - line.y2) == 0){
				return null;
			}
			
			inter = new Point;
			
			inter.x = ((this.x2-this.x1)*(line.x1-line.x2)*(line.y1-this.y1) - 
				line.x1*(this.x2-this.x1)*(line.y1-line.y2)+this.x1*(this.y2-this.y1)*(line.x1-line.x2))/
				((this.y2-this.y1)*(line.x1-line.x2)-(this.x2-this.x1)*(line.y1-line.y2));
			
			inter.y = ((this.y2-this.y1)*(line.y1-line.y2)*(line.x1-this.x1)-
				line.y1*(this.y2-this.y1)*(line.x1-line.x2)+this.y1*(this.x2-this.x1)*(line.y1-line.y2))/
				((this.x2-this.x1)*(line.y1-line.y2) - (this.y2-this.y1)*(line.x1 - line.x2));
			
			return inter;
		}
		
		public function toString():String
		{
			return "Line("+x1+","+y1+","+x2+","+y2+")";
		}
		
	}
}