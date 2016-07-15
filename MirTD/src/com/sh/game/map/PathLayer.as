package com.sh.game.map
{
	
	import com.core.destroy.DestroyUtil;
	import com.core.destroy.IDestroy;
	import com.core.utils.goem.Vector2D;
	import com.sh.game.util.DirectionUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class PathLayer implements IDestroy
	{
		public function PathLayer()
		{
			eightMap[1]=new Dictionary;
			eightMap[0]=new Dictionary;
			eightMap[-1]=new Dictionary;
			eightMap[-1][-1] = 0x00000001;
			eightMap[0][-1] = 0x10000000;
			eightMap[1][-1] = 0x01000000;
			eightMap[1][0] = 0x00100000;
			eightMap[1][1] = 0x00010000;
			eightMap[0][1] = 0x00001000;
			eightMap[-1][1] = 0x00000100;
			eightMap[-1][0] = 0x00000010;
			
//			eightMap['-1-1'] = 0x00000001;
//			eightMap['0-1'] = 0x10000000;
//			eightMap['1-1'] = 0x01000000;
//			eightMap['10'] = 0x00100000;
//			eightMap['11'] = 0x00010000;
//			eightMap['01'] = 0x00001000;
//			eightMap['-11'] = 0x00000100;
//			eightMap['-10'] = 0x00000010;
			
			eightPoints = [new Point(0,0),
				new Point(this.blockSize.width/2,0),
				new Point(this.blockSize.width,0),
				new Point(this.blockSize.width,this.blockSize.height/2),
				new Point(this.blockSize.width,this.blockSize.height),
				new Point(this.blockSize.width/2,this.blockSize.height),
				new Point(0,this.blockSize.height),
				new Point(0,this.blockSize.height/2)];
		}
		
		private var bmd:BitmapData;
		//步长
		private var step:int = 5;
		
		private var eightMap:Dictionary = new Dictionary();
		
		private var mapSize:Rectangle = new Rectangle; 
		
		private var blockSize:Rectangle = new Rectangle;
		
		private var blocks:Dictionary = new Dictionary();
		
		private var eightPoints:Array;
		private var eightValues:Array = [0x10000000,0x01000000,0x00100000,0x00010000,0x00001000,0x00000100,0x00000010,0x00000001];
		
		private var _pathNodes:Dictionary = new Dictionary();
		
		//----------------
		// 临时的运算变量
		//----------------
		private var barr:Array;
		private var toarr:Array;
		
		private var openlist:Vector.<Array> = new Vector.<Array>;
		private var closelist:Vector.<Array> = new Vector.<Array>;
//		private var openmap:Dictionary = new Dictionary();
//		private var closemap:Dictionary = new Dictionary();
		
		private var curblockobj:Array;
		private var tempF:int = 0;
		
		private var _costFrame:int = 0;
		
		public var unwalkPlus:Dictionary = new Dictionary();
		
		
		public function get rowCount():int
		{
			return _rowCount;
		}

		public function get colCount():int
		{
			return _colCount;
		}

		public function setSize(width:int,height:int,cellwidth:int,cellheight:int):void
		{
			mapSize.width = width;
			mapSize.height = height;
			blockSize.width = cellwidth;
			blockSize.height = cellheight;
		}
		
		public function addUnWalk(x:int,y:int):void{
			var id:int = ( x<<16)+y;
			if(unwalkPlus[id]){
				return;
			}
			unwalkPlus[id] = 1;
		}
		
		public function removeUnWalk(x:int,y:int):void{
			var id:int = ( x<<16)+y;
			if(unwalkPlus[id]){
				unwalkPlus[id] = null;
				delete unwalkPlus[id];
			}
		}
		
		public function setBlockData(bytes:ByteArray):void
		{
			bytes.position = 0;
			while(bytes.bytesAvailable>0){
				var x:int = bytes.readShort();
				var y:int = bytes.readShort();
				var value:uint = bytes.readUnsignedInt();
				this.blocks[x+"_"+y] = value;
			}
		}
		
		
		public function setTestBmd(bitmapdata:BitmapData):void{
			this.bmd = bitmapdata;
		}
		
		/**
		 * 初始化八方向连通参数
		 */
		public function initBlocks(width:int,height:int,cellwidth:int,cellheight:int,walkCfg:Dictionary):void{
			mapSize.width = width;
			mapSize.height = height;
			blockSize.width = cellwidth;
			blockSize.height = cellheight;
			blocks = walkCfg;
			_colCount = width/cellwidth;
			_rowCount = height/cellheight;
			var col:int = 0;
			var row:int = 0;
			var value:uint = 0;
		}
		
		
		private var _colCount:int = 0;
		private var _rowCount:int = 0;
		private var _curCol:int = 0;
		private var _curRow:int = 0;
		
		
		/**
		 * 获得当前坐标所在格子点 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function getBlockId(x:Number,y:Number):String
		{
			if(x>this.mapSize.width){
				return null;
			}
			if(y>this.mapSize.height)
				return null;
			return Math.floor(x/this.blockSize.width)+"_"+Math.floor(y/this.blockSize.height);
		}
		
		public function getBlockX(x:Number):int{
			if(x>this.mapSize.width){
				return -1;
			}
			return Math.floor(x/this.blockSize.width);
		}
		
		public function getBlockY(y:Number):int{
			if(y>this.mapSize.height){
				return -1;
			}
			return Math.floor(y/this.blockSize.height);
		}
		
		public function checkBlock(x:int,y:int):Boolean{
			if(x>this._colCount || y>this._rowCount || x < 0 || y < 0){
				return false;
			}else{
				return true;
			}
		}
		
		public function getBlockCellXY(x:Number,y:Number):Point
		{
			if(x>this.mapSize.width){
				return null;
			}
			if(y>this.mapSize.height)
				return null;
			return new Point(Math.floor(x/this.blockSize.width),Math.floor(y/this.blockSize.height));
		}
		
		/**
		 * 获得当前格子的左上角点坐标 
		 * @param blockid
		 * @return 
		 * 
		 */
		public function getBlockXY(blockid:String):Point
		{
			this.barr = blockid.split("_");
			return new Point(this.blockSize.width*int(this.barr[0]),this.blockSize.height*int(barr[1]));
		}
		
		public function getBlockXY2(x:int,y:int):Point
		{
			return new Point(this.blockSize.width*x,this.blockSize.height*y);
		}
		
		public function getBlockXYByInt(block:int):Point
		{
			var x:int = block>>16;
			var y:int = block&0x0000FFFF;
			return new Point(this.blockSize.width*x,this.blockSize.height*y);
		}
		
		public function getBlockByID(block:int):Point
		{
			var x:int = block>>16;
			var y:int = block&0x0000FFFF;
			return new Point(x,y);
		}
		
		public function getBlockWalkAble(fx:int,fy:int):Boolean{
			var from:int = (fx<<16)+fy;
			var value1:int;
			if(this.blocks[from] != null)
				value1 = this.blocks[from];
			else
				value1 = 0;
			return value1 == 0;
		}
		
		private var newid:int;
		private var value:*;
		/**
		 * 获得当前点是否可走 
		 * @param x
		 * @param y
		 * @param cross
		 * @return 
		 * 
		 */
		public function getBlockValueByXY(x:int,y:int,cross:Boolean = false):Boolean
		{
			newid =( x<<16)+y;
			if(unwalkPlus[newid] == 1 && !cross){
				return false;
			}
			value = this.blocks[newid];
			if(x>this._colCount || y>this._rowCount){
				return false;
			}
			if(value == null){
				return true;
			}
			return value == 0;
		}
		
		/**
		 * 判断当前点是否可走 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function isWalkabled(x:Number,y:Number):Boolean
		{
			/*if(this.isBmd()){
				var color:uint = this.bmd.getPixel(x,y);
				if(color < 32)
					return false;
				return true;
			}
			else*/
				return false;
		}
		
		private var endNears:Dictionary;
		
		
		private function startSearch():Array{
			if(this._fromx == this._tox && this._fromy == this._toy)
				return [[_tox,_toy]];
			var endX:int = 0;
			var endY:int = 0;
			endNears = new Dictionary();
			var fromblock:int = (_fromx<<16)+_fromy;
			var toblock:int = (_tox<<16)+_toy;
			if(_standon){
				if(!checkBlock(px,py) || !getBlockValueByXY(_tox,_toy)){
					return [];
				}
			}else{
				if(_standon == false || !getBlockValueByXY(_tox,_toy) ){//终点不可走，看周围可不可走
					var canWalk:Boolean = false;
					for each(var p:Array in eigthArr){
						var px:int = p[0]+_tox;
						var py:int = p[1]+_toy;
						var id:int = (px<<16)+py;
						if(checkBlock(px,py) && this.getBlockValueByXY(px,py)){
							canWalk = true;
							endNears[id] = true;
						}
					}
					if(!canWalk)
						return [];
				}
			}
			destroyMap(cacheObjects);
			openlist.splice(0,openlist.length);
			closelist.splice(0,closelist.length);
			//			DestroyUtil.breakMap(closemap);
			//			DestroyUtil.breakMap(openmap);
			var obj:Object = getObject(toblock);
			obj[1] = obj[2] = obj[3] = 0;
			obj[4] = null;
			obj[6] = 0;
			obj = getObject(fromblock);
			obj[1] = obj[2] = obj[3] = 0;
			obj[4] = null;
			obj[6] = 1;//1 open
			openlist.push(obj);
			return null;
		}
		
		/**
		 * 获得两个格子之间的格子路径 
		 * @param fromblock
		 * @param toblock
		 * @return 
		 * 
		 */
		public function getBlocks(fx:int,fy:int,tx:int,ty:int,standOn:Boolean = true,time:int=0):Array
		{
			if(fx == tx && fy  == ty)
				return [[tx,ty]];
			var endX:int = 0;
			var endY:int = 0;
			endNears = new Dictionary();
			var fromblock:int = (fx<<16)+fy;
			var toblock:int = (tx<<16)+ty;
			if(standOn){
				if(!getBlockValueByXY(tx,ty)){
					return [];
				}
			}else{
				if(!getBlockValueByXY(tx,ty) ){//终点不可走，看周围可不可走
					var canWalk:Boolean = false;
					for each(var p:Array in eigthArr){
						var px:int = p[0]+tx;
						var py:int = p[1]+ty;
						var id:int = (px<<16)+py;
						if(this.isPassByTwoBlocksByPos(px,py,tx,ty)){
							canWalk = true;
							endNears[id] = true;
						}
					}
					if(!canWalk)
						return [];
				}
			}
			destroyMap(cacheObjects);
			openlist.splice(0,openlist.length);
			closelist.splice(0,closelist.length);
//			DestroyUtil.breakMap(closemap);
//			DestroyUtil.breakMap(openmap);
			var obj:Object = getObject(toblock);
			obj[1] = obj[2] = obj[3] = 0;
			obj[4] = null;
			obj[6] = 0;
			obj = getObject(fromblock);
			obj[1] = obj[2] = obj[3] = 0;
			obj[4] = null;
			obj[6] = 1;//1 open
			openlist.push(obj);
//			openmap[fromblock] = obj;
			var func:Function = addEightBlocks;
			while(openlist.length>0){
				curblockobj = openlist.shift();
				var curblockobjid:int = curblockobj[0];
				if(curblockobj[1]>200){
					/*var ret:Array = [];
					while(curblockobj && curblockobjid != fromblock){
						curblockobjid = curblockobj[0];
						var xx:int = curblockobjid>>16;
						var yy:int = curblockobjid&0x0000FFFF;
						ret.push([xx,yy]);
						curblockobj = curblockobj[4];
					}
					if(time<4){
						var start:Array = ret.shift();
						var ret2:Array = getBlocks(start[0],start[1],tx,ty,standOn,++time);
						return ret2.concat(ret);
					}
					else*/
						return [];
				}
				curblockobj[6] = 2;//close
				closelist.push(curblockobj);
//				openmap[curblockobjid] = null;
//				delete openmap[curblockobjid];
//				closemap[curblockobjid] = curblockobj;
				func(curblockobj,tx,ty);
				if(curblockobjid == toblock)
					break;
				if(!standOn){
					if(curblockobjid in endNears){
						var endp:Array = getObject(toblock);
						endp[0] = toblock;
						endp[1] = endp[2] = endp[3] = 0;
						endp[4] = curblockobj;
						curblockobj = endp;
						curblockobjid = curblockobj[0];
						break;
					}
				}
			}
			if(curblockobjid == toblock){//如果找到了，就返回路径
				var ret:Array = [];
				while(curblockobj && curblockobjid != fromblock){
					//ret.push(curblockobj.id);
//					if(closemap[curblockobjid] == null)
//						break;
//					closemap[curblockobjid] = null;
//					delete closemap[curblockobjid];
					var xx:int = curblockobjid>>16;
					var yy:int = curblockobjid&0x0000FFFF;
					ret.push([xx,yy]);
					curblockobj = curblockobj[4];
					curblockobjid = curblockobj[0];
				}
				return ret;
			}
			else
				return [];
		}
		private var arr:Array;
		private var targetarr:Array;
		private var tempp:Point = new Point;
		private var tempid:int;
		private var tempobj:Object;
		public static var eigthArr:Array = [[0,-1,1],[1,-1,1.4],[1,0,1],[1,1,1.4],[0,1,1],[-1,1,1.4],[-1,0,1],[-1,-1,1.4]];
		
		
		
		private var fx:int;
		private var fy:int;
		private var px:int = 0;
		private var py:int = 0;
		private var id:int;
		private var tempnears:Array;
		private var nears:Array;
		/**
		 * 获得八方向的格子 
		 * @param blockobj
		 * @param target
		 * @param fromp
		 * 
		 */
		protected function addEightBlocks(blockobj:Array,tx:int,ty:int,fromp:Point=null):void{
			//arr = blockobj.id.split("_");
			id = blockobj[0];
			fx = id>>16;
			fy = id&0x0000FFFF;
//			var tx:int = target>>16;
//			var ty:int = target&0x0000FFFF;
			nears = blockobj[5];
			if(nears == null)
				tempnears = [];
			for(var i:int=0;i<8;i++){
				var p:Array = eigthArr[i];
				if(nears == null){
					px = p[0]+fx;
					py = p[1]+fy;
					if(!getBlockValueByXY(px,py)){
						continue;
					}
					tempid = (px<<16)+py;
					tempobj = getObject(tempid);
					tempnears[i] = tempobj;
				}
				else
				{
					tempobj = nears[i];
					if(tempobj == null)
						continue;
					tempid = tempobj[0];
					px = tempid>>16;
					py = tempid&0x0000FFFF;
				}
				if(tempobj && tempobj[6]<2){
					if(isPassByTwoBlocksByPos(px,py,fx,fy)){
						//							if(tempid in openmap){//在开启列表中了，就使用G更小的
						if(tempobj[6] == 1){
							if(blockobj[1] + p[2]<tempobj[1]){//如果当前点的G值更小，就选用
								tempobj[1] = blockobj[1] + p[2];
								tempobj[2] = Math.abs(tx-px)+Math.abs(ty-py);
								tempobj[3] = tempobj[1] + tempobj[2];
								tempobj[4] = blockobj;
							}
						}
						else
						{
							tempobj[1] = blockobj[1] + p[2];
							tempobj[2] = Math.abs(tx-px)+Math.abs(ty-py);
							tempobj[3] = tempobj[1] + tempobj[2];
							tempobj[4] = blockobj;
							//								openmap[tempid] = tempobj;
							tempobj[6] = 1;//open 
							addToOpenlist(openlist,tempobj);
						}
					}
					/*else
					{
						//							closemap[tempid] = tempobj;
						if(tempobj[6] == 0){
							tempobj[1] = 999;
							tempobj[3] = 1000;
							tempobj[4] = blockobj;
							tempobj[6] = 1;//open 
							addToOpenlist(openlist,tempobj);
						}
						else
						{
							tempobj[6] = 2;
							closelist.push(tempobj);
						}
					}*/
				}
			}
			if(nears == null){
				blockobj[5] = tempnears;
			}
//			openlist.sortOn("F",Array.NUMERIC);
		}
		
		protected var cacheObjects:Dictionary = new Dictionary;
		
		public function getObject(id:int):Array
		{
			if(cacheObjects[id] == null)
			{
				var arr:Array = new Array(7);
				arr[0] = id;
				arr[6] = 0;
				cacheObjects[id] = arr;
			}
			return cacheObjects[id];
		}
		
		private var i:int;
		private var temp:Object;
		public function addToOpenlist(openlist:Vector.<Array>,object:Object):void
		{
			for(i=openlist.length-1;i>=0;i--){
				temp = openlist[i];
				if(temp[3]<=object[3]){
					if(i == openlist.length-1){
						openlist.push(object);
					}
					else
						openlist.splice(i+1,0,object);
					return;
				}
			}
			openlist.unshift(object);
		}
		
		public function caluDistance(x1:int,y1:int,x2:int,y2:int):int {
			return Math.max(Math.abs(x1 - x2), Math.abs(y1 - y2));
		}
		private var value1:uint;
		private var value2:uint;
		private var from:int;
		private var to:int;
		private var key1:int;
		private var key2:int;
		private var mask1:uint;
		private var mask2:uint;
		public function isPassByTwoBlocksByPos(fx:int,fy:int,tx:int,ty:int):Boolean{
			if(fx == tx && fy == ty)
			{
				return false;
			}
			
			from = (fx<<16)+fy;
			to = (tx<<16)+ty;
			
			if(this.blocks[from] != null)
				value1 = this.blocks[from];
			else
				value1 = 0;
			if(this.blocks[to] != null)
				value2 = this.blocks[to];
			else
				value2 = 0;
			return value1 == 0 && value2 ==0;
	/*		
//			var key1:String = String(tx-fx)+String(ty-fy);
//			var key2:String = String(fx-tx)+String(fy-ty);
//			if(!eightMap.hasOwnProperty(key1)){
//				return false;
//			}
//			if(!eightMap.hasOwnProperty(key2)){
//				return false;
//			}
			key1 = tx-fx;
			key2 = ty-fy;
			if(key1<-1 || key1>1)
				return false;
			else if(key1 == 0 && key2 == 0)
				return false;
			else if(key2<-1 || key2 > 1)
				return false;
			mask1 = eightMap[key1][key2];
			mask2 = eightMap[-key1][-key2];
			
			if((mask1&value1) == mask1 && (mask2&value2)==mask2)
				return true;
			else
				return false;*/
		}
		
		/**
		 *  
		 * @param block
		 * @param toblock
		 * @return 
		 * 
		 */
		public function isPassByTwoBlocks(blockx:int,blocky:int,toblockx:int,toblocky:int):Boolean
		{
			if(blockx == toblockx && blocky == toblocky)
			{
				return false;
			}
			return isPassByTwoBlocksByPos(blockx,blocky,toblockx,toblocky);
		}
		
		public function isSegmentWalkabled(p1:Point,p2:Point):Boolean
		{
			/*var v:Vector2D = new Vector2D(p2.x-p1.x,p2.y-p1.y);
			var l:Number = v.length;
			v.normalize();
			var color:uint = 0;
			for(var i:int = 0;i<l;i+=step){
				color = bmd.getPixel(p1.x+v.x*i,p1.y+v.y*i);
				if(color < 32){*/
					return false;
				/*}
				else
				{
					bmd.setPixel(p1.x+v.x*i,p1.y+v.y*i,0xFF0000);
				}
			}
			return true;*/
		}
		
		public function isBmd():Boolean
		{
			return bmd != null;
		}
		
		public function getPointsPath(fromp:Point,top:Point,blocklist:Array):Array
		{
			if(blocklist.length == 0)
				return [];
			var centerlist:Array = [];
			var p:Point;
			var lastp:Point = fromp;
			while(blocklist.length>1){
				p = getBlockXY(blocklist.pop());
				p.x += this.blockSize.width/2;
				p.y += this.blockSize.height/2;
				centerlist.push(new Point(lastp.x+(p.x-lastp.x)/2,lastp.y+(p.y-lastp.y)/2));//中点
				centerlist.push(p);
				lastp = p;
			}
			centerlist.push(new Point(lastp.x+(top.x-lastp.x)/2,lastp.y+(top.y-lastp.y)/2));//中点
			centerlist.push(top);
			return centerlist;
		}
		
		public function canMove(p:Point,p2:Point):Boolean{
			if(p2.x >= 0 && p2.x < this._colCount && p2.y >=0 && p2.y < this._rowCount && getBlockValueByXY(p2.x,p2.y) && isPassByTwoBlocks(p.x,p.y,p2.x,p2.y)){
				return true;
			}
			return false;
		}
		
		public function canStand(p2:Point):Boolean{
			if(p2.x >= 0 && p2.x < this._colCount && p2.y >=0 && p2.y < this._rowCount && getBlockValueByXY(p2.x,p2.y) ){
				return true;
			}
			return false;
		}
		
		/**
		 * 移动一步
		 */
		public function getForwardStep(fx:int,fy:int,todir:int,step:int):Array{
			var path:Array = new Array();
			var used:int = 0;
			while(used < step){
				var offsetX:int = 0;
				var offsetY:int = 0;
				var tp:Point;
				var fromX:int = this.getBlockX(fx);
				var fromY:int = this.getBlockY(fy);
				
				var p:Point = DirectionUtil.addNode(fromX,fromY,todir);
				//var nodeid:String = p.x + "_" + p.y;
				if(p.x >= 0 && p.x < this._colCount && p.y >=0 && p.y < this._rowCount && getBlockValueByXY(p.x,p.y) && isPassByTwoBlocks(fromX,fromY,p.x,p.y)){
					tp = getBlockXY2(p.x,p.y);
					tp.x += this.blockSize.width/2;
					tp.y += this.blockSize.height/2;
					path.push(tp);
				}else{
					if(step > 1 && used > 0){
						break;
					}
					var nears:Array = DirectionUtil.getNearDirs(todir);
					var count:int = 0;
					for each(var dir:int in nears){
						if(count >= 4)
							break;
						count ++;
						p = DirectionUtil.addNode(fromX,fromY,dir);
						if(p.x >= 0 && p.x < this._colCount && p.y >=0 && p.y < this._rowCount && getBlockValueByXY(p.x,p.y) && isPassByTwoBlocks(fromX,fromY,p.x,p.y)){
							tp = getBlockXY2(p.x,p.y);
							tp.x += this.blockSize.width/2;
							tp.y += this.blockSize.height/2;
							path.push(tp);
							break;
						}
					}
					used = step;
				}
				if(!tp)
					return null;
				else
				{
					fx = tp.x;
					fy = tp.y;
				}
				used++;
			}
			
			return path;
		}
		
		
		
		private var _handler:Function;
		
		/**
		 * 获得路径 
		 * @param fromp
		 * @param to
		 * @return 
		 * 
		 */
		public function getPath(fromp:Point,to:Point,standOn:Boolean,stageid:int,handler:Function,inflectPoints:Array=null):Array
		{
//			if(!this.isWalkabled(to.x,to.y)){//目标点不可走
//				return [];
//			}
//			if(!this.isWalkabled(fromp.x,fromp.y)){//直接走出不可走点
//				return [to];
//			}
			var starttime:int = getTimer();
			/*var fromid:String = fromp.x+"_"+fromp.y;
			var toid:String = to.x+"_"+to.y;*/
			finding = true;
			_costFrame = 0;
			this._fromx = fromp.x;
			this._fromy = fromp.y;
			if(inflectPoints == null || inflectPoints.length == 0)
			{
				this._tox = to.x;
				this._toy = to.y;
				_standon = _endstandon = standOn;
				this.inflectPoints = null;
				this.retPath = null;
			}
			else
			{
				var p:Point = inflectPoints.shift();
				this._tox = p.x;
				this._toy = p.y;
				_endstandon = standOn;
				_standon = false;
				inflectPoints.push(to);
				this.inflectPoints = inflectPoints;
				this.retPath = [];
			}
			_handler = handler;
			this._findStageid = stageid;
			var arr:Array = this.startSearch();
			if(arr != null){
				handler(arr,_findStageid);
				trace("寻路消耗帧" + _costFrame);
				finding = false;
				_costFrame = 0;
				destroyMap(cacheObjects);
			}
			//var blocklist:Array = getBlocks(fromp.x,fromp.y,to.x,to.y,standOn);
			//var ret:Array = getPointsPath(fromp,to,blocklist);
			//trace('getpath use:',getTimer()-starttime,'ms');
			/*if(isBmd()){
				drawPath(ret,0xff0000ff);
			}*/
			return null;
		}
		
		
		/**
		 * 清理dictionary
		 * @param param1
		 * @return 
		 */
		public static function destroyMap(param1:Object) : Object
		{
			var _loc_2:Object = null;
			if (param1 != null)
			{
				for (_loc_2 in param1)
				{
					
					delete param1[_loc_2];
				}
			}
			return param1;
		}
		
		private var _findStageid:int = 0;
		private var _tox:int = 0;
		private var _toy:int = 0;
		private var _fromx:int = 0;
		private var _fromy:int = 0;
		private var _standon:Boolean = false;
		private var _endstandon:Boolean = false;
		public var finding:Boolean = false;
		
		/**
		 * 中转点
		 */
		protected var inflectPoints:Array = [];
		/**
		 * 多段路径临时合并的
		 */
		protected var retPath:Array;
		
		/**
		 * 帧事件
		 */
		public function render():void{
			if(finding){
				var result:Array = calu();
				if(result != null && _handler && this.finding){
					if(inflectPoints == null || inflectPoints.length == 0){
						if(retPath != null){
							result = result.concat(retPath);
						}
						this._handler(result,_findStageid);
						destroyMap(cacheObjects);
						finding = false;
						_costFrame = 0;
					}
					else
					{
						retPath = result.concat(retPath);
						var nextp:Point = inflectPoints.shift();
						if(inflectPoints.length == 0)
							this._standon = this._endstandon;
						else
							this._standon = false;
						this._fromx = this._tox;
						this._fromy = this._toy;
						this._tox = nextp.x;
						this._toy = nextp.y;
						if(inflectPoints.length == 0){
							var ret:Array = startSearch();
							if(arr != null){
								if(_handler != null)
									_handler(ret,_findStageid);
								destroyMap(cacheObjects);
								finding = false;
								_costFrame = 0;
							}
						}else
							startSearch();
					}
				}else if(_costFrame > 30){
					if(_handler != null)
						_handler(null,_findStageid);
					destroyMap(cacheObjects);
					finding = false;
				}
			}
		}
		
		private function calu():Array{
			_costFrame++;
			var fx:int = this._fromx;
			var fy:int = this._fromy;
			var fromblock:int = (fx<<16)+fy;
			var toblock:int = (_tox<<16)+_toy;
			var func:Function = addEightBlocks;
			var count:int = 0;
			while(openlist.length>0){
				count++;
				if(count > 3000){
					return null;
				}
				curblockobj = openlist.shift();
				var curblockobjid:int = curblockobj[0];
				/*if(curblockobj[1]>200){
				return ;
				}*/
				curblockobj[6] = 2;//close
				closelist.push(curblockobj);
				func(curblockobj,this._tox,this._toy);
				if(curblockobjid == toblock)
					break;
				if(!this._standon){
					if(curblockobjid in endNears){
						var endp:Array = getObject(toblock);
						endp[0] = toblock;
						endp[1] = endp[2] = endp[3] = 0;
						endp[4] = curblockobj;
						curblockobj = endp;
						curblockobjid = curblockobj[0];
						break;
					}
				}
			}
			if(curblockobjid == toblock){//如果找到了，就返回路径
				var ret:Array = [];
				while(curblockobj && curblockobjid != fromblock){
					var xx:int = curblockobjid>>16;
					var yy:int = curblockobjid&0x0000FFFF;
					ret.push([xx,yy]);
					curblockobj = curblockobj[4];
					curblockobjid = curblockobj[0];
				}
				return ret;
			}
			else
				return [];
		}
		
		private function drawPath(arr:Array,color:int):void
		{
			var lastp:Point = arr[0];
			var nextp:Point = arr[1];
			var index:int = 0;
			bmd.fillRect(new Rectangle(0,0,bmd.width,bmd.height),0x00000000);
			bmd.lock();
			while(lastp!=null && nextp != null){
				var v:Vector2D = new Vector2D(lastp.x-nextp.x,lastp.y-nextp.y);
				var l:Number = v.length;
				v.normalize();
				for(var i:int = 0;i<l;i+=step){
					bmd.setPixel32(nextp.x+v.x*i - 1,nextp.y+v.y*i,color);
					bmd.setPixel32(nextp.x+v.x*i,nextp.y+v.y*i,color);
					bmd.setPixel32(nextp.x+v.x*i + 1,nextp.y+v.y*i,color);
					bmd.setPixel32(nextp.x+v.x*i,nextp.y+v.y*i + 1,color);
					bmd.setPixel32(nextp.x+v.x*i,nextp.y+v.y*i - 1,color);
				}
				index++;
				lastp = arr[index];
				nextp = arr[index+1];
			}
			bmd.unlock();
		}
		
		public function destroy():void{
			if(bmd){
				bmd.dispose();
				bmd = null;
			}
			eightMap = null;
			mapSize = null;
			blockSize = null;
			blocks = null;
			eightPoints = null;
			eightValues = null;
			if(barr)
				DestroyUtil.destroyArray(barr);
			barr = null;
			if(toarr)
				DestroyUtil.destroyArray(toarr);
			toarr = null;
			DestroyUtil.destroyVector(openlist);
			DestroyUtil.destroyVector(closelist);
			destroyMap(cacheObjects);
//			for(var key:* in closemap){
//				closemap[key] = null;
//				delete closemap[key];
//			}
//			for(var key:* in openmap){
//				openmap[key] = null;
//				delete openmap[key];
//			}
			DestroyUtil.destroyArray(curblockobj);
			destroyMap(unwalkPlus);
			curblockobj = null;
			unwalkPlus = null;
		}
		
		public function clear():void
		{
			if(unwalkPlus)
				DestroyUtil.destroyMap(unwalkPlus);
			_costFrame = 0;
			this.finding = false;
		}
	}
}