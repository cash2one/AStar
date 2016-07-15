package com.sh.game.util
{
	import flash.geom.Point;

	
	/**
	 * 多边形、用于计算点和线段以及贴边路径 
	 * @author chzcb
	 * 
	 */
	public class Polygon
	{
		protected var _points:Array;
		
		protected var vertx:Array;
		protected var verty:Array;
		
		protected var _lines:Array;

		public function get lines():Array
		{
			return _lines;
		}

		public function set lines(value:Array):void
		{
			_lines = value;
		}

		
		protected var nvert:int;
		
		public function Polygon(points:Array)
		{
			if(points.length<3)
				throw new Error("多边形至少有3个坐标点");
			nvert = points.length;
			vertx = [];
			verty = [];
			lines = [];
			for(var i:int = 0;i<nvert;i++){
				var p:Point = points[i];
				var tp:Point;
				if(i < nvert-1){
					tp = points[i+1];
				}
				else
					tp = points[0];
				var l:Line = new Line(p.x,p.y,tp.x,tp.y);
				lines.push(l);
				if(i<nvert-1 && i>0){
					lines[i-1].next = l;
				}
				else if(i == nvert - 1)
				{
					lines[i-1].next = l;
					l.next = lines[0];
				}
				vertx.push(p.x);
				verty.push(p.y);
			}
		}
		/**
		 * 判断点point是否在多边形内部
		 */
		public function isPointInside(point:Point):Boolean
		{
			var testx:int = point.x;
			var testy:int = point.y;
			return isXyInside(testx,testy);
		}
		
		/**
		 * 判断x,y是否在多边形内部
		 */
		public function isXyInside(testx:int,testy:int):Boolean
		{
			var i:int, j:int = 0;
			var ret:Boolean = false;
			for (i = 0, j = nvert-1; i < nvert; j = i++) {
				if ( ((verty[i]>testy) != (verty[j]>testy)) &&
					(testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
					ret = !ret;
			}
			return ret;
		}
		
		/**
		 * 判断线段是否完全穿透
		 */
		public function isLineCross(line:Line):Boolean
		{
			for each(var l:Line in lines){
				if(l.isCross(line))
					return true;
			}
			return false;
		}
		
		/**
		 * 如果线段穿透，就寻找最近的贴边路径
		 */
		public function getNearSidePoints(line:Line):Array
		{
			if(isXyInside(line.x1,line.y1) || isXyInside(line.x2,line.y2))//如果有线段一头在里面
				return null;
			var arr:Array = [];
			for(var i:int = lines.length-1;i>=0;i--){
				var l:Line = lines[i];
				var inter:Point = l.getInter(line);
				if(inter && (inter.x - l.x1)*(inter.x-l.x2)<=0
					&& (inter.x - line.x1)*(inter.x-line.x2)<=0
					&& (inter.y - l.y1)*(inter.y-l.y2)<=0
					&& (inter.y - line.y1)*(inter.y-line.y2)<=0) {
					//获得线段上的交点
					arr.push(i,inter);
				}
			}
			if(arr.length == 0)
				return null;
			var near:Point = arr[1];
			var far:Point = arr[1];
			var nlen:int,flen:int;
			nlen = flen = (near.x-line.x1)*(near.x-line.x1)+(near.y-line.y1)*(near.y-line.y1);
			var len:int = arr.length;
			for(var j:int = 2;j<len;j+=2){
				var temp:Point = arr[j+1];
				var lsq:int = (temp.x-line.x1)*(temp.x-line.x1)+(temp.y-line.y1)*(temp.y-line.y1);
				if(lsq<nlen){
					near = temp;
					nlen = lsq;
				}
				else if(lsq>flen){
					far = temp;
					flen = lsq;
				}
			}
			//第一个穿透的
			var startline:Line = lines[arr[arr.indexOf(near)-1]];
			//最后一个传出
			var endline:Line = lines[arr[arr.indexOf(far)-1]];
			
			//路径一
			var path1:Array = [near.x,near.y,startline.x2,startline.y2];
			var end:Line = startline;
			while(end!=endline){
				end = end.next;
				if(end==endline)
					break;
				path1.push(end.x2,end.y2);
			}
			path1.push(far.x,far.y);
			
			var path2:Array = [endline.x2,endline.y2,far.x,far.y];
			end = endline;
			while(end!=startline){
				end = end.next;
				if(end==startline)
					break;
				path2.unshift(end.x2,end.y2);
			}
			path2.unshift(near.x,near.y);
			
			
			var size1:int = 0;
			len = path1.length;
			for(var index:int = 2;index<len;index+=2){
				size1 += Math.sqrt((path1[index]-near.x)*(path1[index]-near.x)+(path1[index+1]-near.y)*(path1[index+1]-near.y));
			}
			var size2:int = 0;
			len = path2.length;
			for(index = 2;index<len;index+=2){
				size2 += Math.sqrt((path2[index]-near.x)*(path2[index]-near.x)+(path2[index+1]-near.y)*(path2[index+1]-near.y));
			}
			if(size1<size2)
				return path1;
			else
				return path2;
		}
	}
}