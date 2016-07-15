package com.sh.game.util
{
	import com.sh.game.consts.DirectionType;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class DirectionUtil
	{
		public function DirectionUtil()
		{
		}
		
		/**
		 * 根据起始点跟目标点获取方向
		 */
		public static function getForwardByPoints(fx:Number,fy:Number,tox:Number,toy:Number):int{
			var nx:Number = tox - fx;
			var ny:Number = toy - fy;
			var todir:int = 0;
			
			var r:Number = Math.sqrt(nx * nx + ny*ny);
			var cos:Number = nx/r;
			var angle:int = int(Math.floor(Math.acos(cos) * 180/Math.PI));
			if(ny < 0){
				angle = 360 - angle;
			}
			
			if(angle > 337 || angle < 23){
				todir = DirectionType.RIGHT;
			}else  if(angle > 292){
				todir = DirectionType.RIGHT_UP;
			}else  if(angle > 247){
				todir = DirectionType.UP;
			}else  if(angle > 202){
				todir = DirectionType.LEFT_UP;
			}else  if(angle > 157){
				todir = DirectionType.LEFT;
			}else  if(angle > 112){
				todir = DirectionType.LEFT_DOWN;
			}else  if(angle > 67){
				todir = DirectionType.DOWN;
			}else {
				todir = DirectionType.RIGHT_DOWN;
			}
			return todir;
		}
		
		public static function getRotateByDir(dir:int):Number{
			var rotate:Number;
			switch(dir){
				case 0:rotate = 0;break;
				case 1:rotate = 56/180 * Math.PI;break;
				case 2:rotate = 90/180 * Math.PI;break;
				case 3:rotate = 124/180 * Math.PI;break;
				case 4:rotate = 180/180 * Math.PI;break;
				case 5:rotate = 236/180 * Math.PI;break;
				case 6:rotate = 270/180 * Math.PI;break;
				case 7:rotate = 304/180 * Math.PI;break;
			}
			return rotate;
		}
		
		public static function getRotateByDir2(dir:int):Number{
			var rotate:Number;
			switch(dir){
				case 0:rotate = 0;break;
				case 1:rotate = 56;break;
				case 2:rotate = 90;break;
				case 3:rotate = 124;break;
				case 4:rotate = 180;break;
				case 5:rotate = 236;break;
				case 6:rotate = 270;break;
				case 7:rotate = 304;break;
			}
			return rotate;
		}
		
		/**
		 * 根据起始点跟目标点获取方向
		 */
		public static function getForwardByGridXY(fx:int,fy:int,tox:int,toy:int):int{
			var todir:int = 0;
			var hor:int = tox - fx;
			var ver:int = toy - fy;
			todir = getDir(hor,ver);
			return todir;
		}
		
		/**
		 * 根据速度确定方向
		 */
		public static function getDir(hor:Number,ver:Number):int{
			var dir:int = 0;
			if(hor > 0){//右
				if(ver < 0)//上
					dir = DirectionType.RIGHT_UP;
				else if(ver > 0)
					dir = DirectionType.RIGHT_DOWN;
				else
					dir = DirectionType.RIGHT;
			}else if(hor < 0){//左
				if(ver < 0)//上
					dir = DirectionType.LEFT_UP;
				else if(ver > 0)
					dir = DirectionType.LEFT_DOWN;
				else
					dir = DirectionType.LEFT;
			}else{
				if(ver < 0)
					dir = DirectionType.UP;
				else
					dir = DirectionType.DOWN;
			}
			return dir;
		}
		
		/**
		 * 根据给出的方向获得从近到远的方向集合
		 */
		public static function getNearDirs(curDir:int):Array{
			var i:int = 0;
			var dirs:Array = DirectionType.EIGHT_DIRS;
			var result:Array = new Array();
			for(var j:int = 0;j<8;j++){
				if(dirs[j] == curDir){
					i = j;
					break;
				}
			}
			for(var k:int = 1; k <= 4; k++){
				if(dirs[i + k] != null){
					result.push(dirs[i + k]);
				}else{
					result.push(dirs[i + k - 8]);
				}
				if(k == 4){
					break;
				}
				if(dirs[i - k] != null){
					result.push(dirs[i - k]);
				}else{
					result.push(dirs[i - k + 8]);
				}
			}
			return result;
		}
		
		public static function addNode(x:int,y:int,dir:int):Point{
			var p:Point = new Point(x,y);
			switch(dir){
				case DirectionType.UP:p.y = p.y - 1;break;
				case DirectionType.RIGHT_UP:p.y = p.y - 1;p.x = p.x + 1;break;
				case DirectionType.RIGHT:p.x = p.x + 1;break;
				case DirectionType.RIGHT_DOWN:p.y = p.y + 1;p.x = p.x + 1;break;
				case DirectionType.DOWN:p.y = p.y + 1;break;
				case DirectionType.LEFT_DOWN:p.y = p.y + 1;p.x = p.x - 1;break;
				case DirectionType.LEFT:p.x = p.x - 1;break;
				case DirectionType.LEFT_UP:p.y = p.y - 1;p.x = p.x - 1;break;
			}
			return p;
		}
		
		public static function addDir(dir:int,add:int):int{
			add = add%8;
			if(add < 0){
				add = 8 + add;
			}
			var tdir:int = dir + add;
			if(tdir > 7)
				tdir = tdir - 8;
			return tdir;
		}
		
		/**
		 * 只获取垂直方向的方向
		 */
		public static function getVecDir(dir:int):int{
			switch(dir){
				case 0:
				case 1:
				case 7:
					return 0;
					break;
				case 3:
				case 4:
				case 5:
					return 4;
					break;
			}
			return -1;
		}
		
		/**
		 * 只获取水平方向的方向
		 */
		public static function getHorDir(dir:int):int{
			switch(dir){
				case 1:
				case 2:
				case 3:
					return 2;
					break;
				case 5:
				case 6:
				case 7:
					return 6;
					break;
			}
			return -1;
		}
	}
}