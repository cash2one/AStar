package com.sh.game.map
{
	import com.core.destroy.DestroyUtil;
	import com.core.destroy.IDestroy;
	import com.sh.game.util.DirectionUtil;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	

	public class MapData implements IDestroy
	{
		private var _cellWidth:Number = 0;
		private var _cellHeight:Number = 0;
		private var _mapGridsById:Dictionary;
		
		private var url:String = "";
		private var miniMapUrl:String = "";
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public var unWalkCfg:Dictionary;
		public var safeMcCfg:Object;
		private var _coverDic:Dictionary;
		private var _safeDic:Dictionary;
		private var _digDic:Dictionary;
		private var _digArr:Array;
		public var stallageArea:Vector.<Point>;
		private var _guajiPoints:Vector.<Point>;
		
		private var _pathLayer:PathLayer;
		
		private var _depth:int = 6;
		
		public var trans:Object;
		
		public var events:Object;
		
		private var _cancross:Boolean;
		
		
		/**
		 * 地图信息
		 * @param width 地图宽度
		 * @param height 地图高度
		 * @param cellWidth 节点宽度
		 * @param cellHeight 节点高度
		 * @param unwalk 不可走数组
		 * @param cover 覆盖节点数组
		 * @param quadTreeDepth 四叉树深度
		 */
		public function MapData(width:Number,height:Number,cellWidth:int,cellHeight:int,cfgs:Object,monsterscfg:Object = null,quadTreeDepth:int = 5,cancross:int = 1)
		{
			var t:int = getTimer();
			this._width = width;
			this._height = height;
			if(cancross == 1){
				_cancross = true;
			}else
				_cancross = false;
			trans = cfgs.trans;
			var i:int = 0;
			for (var key:String in trans){
				var pos:Array = key.split("_");
				trans[key].cellX = pos[0];
				trans[key].cellY = pos[1];
				trans[key].px = int(pos[0] * cellWidth + cellWidth/2);
				trans[key].py = int(pos[1] * cellHeight + cellHeight/2);
				trans[key].id = i++;
			}
			this._safeDic = new Dictionary;
			this._coverDic = new Dictionary;
			this._digDic = new Dictionary();
			_digArr = new Array();
			unWalkCfg = new Dictionary;
			safeMcCfg = cfgs.safemc;
			var bytes:ByteArray = cfgs.normallist;
			bytes.position = 0;
			var colcount:int = Math.ceil(width/cellWidth);
			var rowcount:int = Math.ceil(height/cellHeight);
			var gridCount:int = 0;
			var nextint:Boolean = true;
			var curValue:int = 0;
			var a:int = parseInt("1000",2);
			var b:int = parseInt("0100",2);
			var c:int = parseInt("0010",2);
			var d:int = parseInt("0001",2);
			var v:int = 0;
			var id:int;
			for(i =0;i<rowcount;i++)
			{
				for(var j:int =0;j<colcount;j++)
				{
					if(nextint){//偶数
						curValue = bytes.readByte();
						if(curValue < 0)
							curValue += 256;
						nextint = false;
						v = curValue>>4;
					}else{//奇数
						v = curValue&15;
						nextint = true;
					}
					id = (j<<16) + i;
					if((v&a) > 0){
						unWalkCfg[id] = 1;
					}
					if((v&b) > 0){
						this._coverDic[id] = true;
					}
					if((v&c )> 0){
						this._safeDic[id] = true;
					}
					if((v&d) > 0){
						this._digDic[id] = true;	
						_digArr.push(id);
					}
					gridCount++;
				}
			}
			/*var input:Input = new Input(bytes);
			var unwalklen:int = input.readVarInt(false);
			var otherlen:int = input.readVarInt(false);
			var arr:Array ;
			if(unwalklen > 0){
				var unwalkBytes:ByteArray = input.readBytes(unwalklen);
				var input2:Input = new Input(unwalkBytes);
				unwalkBytes.position = 0;
				input2.setBytes(unwalkBytes);
				while(input2.bytesAvailable>0){
					var x:int = input2.readVarInt(false);
					var y:int = input2.readVarInt(false);
					var id:int = (x<<16) + y;
					unWalkCfg[id] = 0;
				}
				unwalkBytes.clear();
			}
			
			if(otherlen > 0){
				var otherBytes:ByteArray =  input.readBytes(otherlen);
				otherBytes.position = 0;
				input.setBytes(otherBytes);
				while(input.bytesAvailable>0){
					var x:int = input.readVarInt(false);
					var y:int = input.readVarInt(false);
					var type:int = input.readVarInt(false);
					var value:int = input.readVarInt(false);
					var id:int = (x<<16) + y;
					if((type & 1 )== 1 ){//a 不可走
						//if(value == 1)
							unWalkCfg[id] = 1;
					}
					if((type & 2 )== 2 ){//b 
						if(!arr){
							if(_normalList[id] == null){
								arr = new Array(5);
								_normalList[id] = arr;
							}else
								arr = _normalList[id];
						}
						arr[1] = 1;
					}
					if((type & 4  )== 4){//c
						if(!arr){
							if(_normalList[id] == null){
								arr = new Array(5);
								_normalList[id] = arr;
							}else
								arr = _normalList[id];
						}
						arr[2] = 1;
					}
					if((type & 8 )== 8 ){//d
						if(!arr){
							if(_normalList[id] == null){
								arr = new Array(5);
								_normalList[id] = arr;
							}else
								arr = _normalList[id];
						}
						arr[3] = 1;
						safeMcCfg[id] = 1;
					}
					if((type & 16 )== 16 ){//e
						if(!arr){
							if(_normalList[id] == null){
								arr = new Array(5);
								_normalList[id] = arr;
							}else
								arr = _normalList[id];
						}
						arr[4] = 1;
					}
					arr = null;
				}
				otherBytes.clear();
			}*/
			
			var temp:Point
			var m:uint;
			var n:uint;
			var parr:Array;
			var index:int,index2:int;
			if(cfgs.stallage){
				this.stallageArea = new Vector.<Point>();
				for(key in cfgs.stallage){
					parr = key.split("_");
					stallageArea.push(new Point(parr[0],parr[1]));
				}
				for(m=0;m<stallageArea.length;m++)
				{
					for(n=stallageArea.length-1;n>m;n--)
					{
						index = cfgs.stallage[stallageArea[n-1].x + "_" + stallageArea[n-1].y];
						index2 = cfgs.stallage[stallageArea[n].x + "_" + stallageArea[n].y];
						if(index>index2)
						{
							temp=stallageArea[n-1];
							stallageArea[n-1]=stallageArea[n];
							stallageArea[n]=temp;
						}
					}
				}
			}
			if(cfgs.guaji){
				this._guajiPoints = new Vector.<Point>();
				for(key in cfgs.guaji){
					parr = key.split("_");
					_guajiPoints.push(new Point(parr[0],parr[1]));
				}
				for(m=0;m<_guajiPoints.length;m++)
				{
					for(n=_guajiPoints.length-1;n>m;n--)
					{
						index= cfgs.guaji[_guajiPoints[n-1].x + "_" + _guajiPoints[n-1].y];
						 index2 = cfgs.guaji[_guajiPoints[n].x + "_" + _guajiPoints[n].y];
						if(index>index2)
						{
							temp=_guajiPoints[n-1];
							_guajiPoints[n-1]=_guajiPoints[n];
							_guajiPoints[n]=temp;
						}
					}
				}
			}
			bytes.clear();
			trace("处理地图数据:耗时"+(getTimer()-t)+"ms");
			_pathLayer = new PathLayer();
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_pathLayer.initBlocks(this.width,this.height,cellWidth,cellHeight,unWalkCfg);
		}
		
		public function get digArr():Array
		{
			return _digArr;
		}

		protected function byte2to16(b:int):int
		{
			var value:int = 0;
			var add:int = 1;
			var temp:int = (b&1);
			while(b>0){
				if(temp>0)
					value += add;
				add = add<<4;
				b = (b>>1);
				temp = (b&1);
			}
			if(temp>0)
				value += add;
			return value;
		}
		
		public function get cancross():Boolean
		{
			return _cancross;
		}

		public function getCell(id:int):Point{
			return this._pathLayer.getBlockByID(id);
		}
		/*public function get digsCfg():Dictionary
		{
			return _digsCfg;
		}*/
		
		public static function getPointID(x:int,y:int):int
		{
			return (x<<16)+y;
		}
		
		public static function getXByID(id:int):int
		{
			return id>>16;
		}
		
		public static function getYByID(id:int):int
		{
			return id&0x0000FFFF;
		}
		
		public function isDig(x:int,y:int):Boolean{
			var id:int = getPointID(x,y);
			return this._digDic[id];
//			return (_normalList[x + "_" + y] != null && "e" in _normalList[x + "_" + y]);
		}

		public function get guajiPoints():Vector.<Point>
		{
			return _guajiPoints;
		}


		public function isRight(v1:Object,v2:Object):Boolean{
			//向量v2是否在向量v1的右边
			return v1.x*v2.y-v1.y*v2.x>0;
		}
		
		public function isInStallageArea(x:int,y:int):Boolean{
			if(this.stallageArea){
				if(stallageArea.length < 3){
					return false;
				}
				return  inPolygon(stallageArea,new Point(x,y));
			}else{
				return false;
			}
			return true;
		}
		
		public function canStallage(x:int,y:int):Boolean{
			/*if(this.isSafe(x,y))
				return false;*/
			return isInStallageArea(x,y);
		}
		/*
		* 目标点是否在多边形之内(任意多边形)<br>若p点在多边形顶点或者边上，返回值不确定，需另行判断
		* @param vertexList        多边形顶点数组
		* @param p                被判断点
		* @param px                被判断点X(可选)
		* @param py                被判断点Y(可选)
		* @return                         true:点在多边形内部, false:点在多边形外部 
		*
			*/
		public static function inPolygon(vertexList:Vector.<Point>, p:Point, px:Number = NaN, py:Number = NaN):Boolean
		{
			if (vertexList == null)
				return false;
			if (!p)
			{
				if (!isNaN(px) && !isNaN(py))
					p = new Point(px, py);
				else
					return false;
			}
			if (px < 0 || py < 0)
				return false;
			var n:int = vertexList.length;
			var i:int = 0;
			var p1:Point;
			var p2:Point;
			var counter:int = 0;
			var xinters:int = 0;
			p1 = vertexList[0];
			for (i = 1; i <= n; i++)
			{
				p2 = vertexList[i % n];
				if (p.y > Math.min(p1.y, p2.y))
				{
					if (p.y <= Math.max(p1.y, p2.y))
					{
						if (p.x <= Math.max(p1.x, p2.x))
						{
							if (p1.y != p2.y)
							{
								xinters = (p.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
								if (p1.x == p2.x || p.x <= xinters)
									counter++;
							}
						}
					}
				}
				p1 = p2;
			}
			return counter % 2 != 0;
		}
		
		public function get col():int{
			return this._pathLayer.colCount;
		}
		
		public function get row():int{
			return this._pathLayer.rowCount;
		}
		
		
		
		/**
		 * 检测遮盖
		 * @param x
		 * @param y
		 * @return Boolean
		 */
		public function hitTestCover(x:int,y:int):Boolean{
			if(!_pathLayer)
				return false;
			var point:Point = this._pathLayer.getBlockCellXY(x,y);
			if(point == null)
				return false;
			var id:int = getPointID(point.x,point.y);
			return this._coverDic[id];
//			return (_normalList[id] != null && _normalList[id].b);
		}
		
		public function get height():Number
		{
			return _height;
		}

		public function get width():Number
		{
			return _width;
		}
		
		public function isSafe(x:int,y:int):Boolean{
			var id:int = getPointID(x,y);
			return this._safeDic[id];
//			return (_normalList[x + "_" + y] != null && _normalList[x + "_" + y].c);
		}

		private var csPos:Array = [[0,-2],[2,-2],[2,0],[2,2],[0,2],[-2,2],[-2,0],[-2,-2]];
		
		private var normalAttPos:Array = [[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1]];
		
		/**
		 * 是否是刺杀位
		 */
		public function isCSPos(fx:int,fy:int,tx:int,ty:int):Boolean{
			var ver:int = Math.abs(ty - fy);
			var hor:int = Math.abs(tx - fx);
			if(ver == 2 && hor == 0)
				return true;
			else if(ver == 0 && hor == 2)
				return true;
			else if(ver == 2 && hor == 2)
				return true;
			else if(ver == 2 && hor == 0)
				return true;
			return false;
		}
		
		/**
		 * 寻找最近刺杀位
		 */
		public function findCSPos(fx:int,fy:int,tx:int,ty:int):Array{
			var poss:Array = new Array();
			var closedis:int = int.MAX_VALUE;
			var closePos:Array = null;
			for each(var pos:Array in csPos){
				var cellx:int = pos[0] + tx;
				var celly:int = pos[1] + ty;
				if(this._pathLayer.canStand(new Point(cellx,celly))){
					var dis:int = Math.abs(fx - (pos[0] + tx))+Math.abs(fy - (pos[1] + ty));
					if(dis < closedis){
						closedis = dis;
						closePos = [cellx,celly];
					}
				}
			}
			return closePos;
		}
		
		
		/**
		 * 寻路
		 */
		public function findPath(fx:int,fy:int,tox:int,toy:int,standOn:Boolean,stageid:int,handler:Function,inflectPoints:Array=null):Array{
			return _pathLayer.getPath(new Point(fx,fy),new Point(tox,toy),standOn,stageid,handler,inflectPoints);
		}
		
		/**
		 * @return 0:都不同，1:都相同，2:x相同，3:y相同，4:错误
		 */
		public function checkToPoints(fx:int,fy:int,tx:int,ty:int):int{
			fx = this._pathLayer.getBlockX(fx);
			fy = this._pathLayer.getBlockY(fy);
			tx = this._pathLayer.getBlockX(tx);
			ty = this._pathLayer.getBlockY(ty);
			if(fx < 0 || fy < 0 || tx < 0 || ty < 0)
				return 4;
			if(fx == tx && fy == ty){
				return 1;
			}
			if(fx != tx && fy != ty){
				return 0;
			}
			if(fx == tx && fy != ty){
				return 2;
			}
			if(fx != tx && fy == ty){
				return 3;
			}
			return 4;
		}
		
		/**
		 * 根据方向获得两侧最近的位置
		 */
		public function getSideNodeByDir(fx:int,fy:int,tox:int,toy:int,dir:int):Point{
			var p:Point ;
			var diradd1:int = DirectionUtil.addDir(dir,2);
			var diradd2:int = DirectionUtil.addDir(dir,-2);
			var node1:Point = DirectionUtil.addNode(tox,toy,diradd1);
			var node2:Point = DirectionUtil.addNode(tox,toy,diradd2);
			var dis1:int = int.MAX_VALUE;
			var dis2:int = int.MAX_VALUE;
			if(this._pathLayer.getBlockValueByXY(node1.x,node1.y) ){
				dis1 = Math.max(Math.abs(fx - fy),Math.abs(node1.x - node1.y));
			}
			if(this._pathLayer.getBlockValueByXY(node2.x,node2.y) ){
				dis2 = Math.max(Math.abs(fx - fy),Math.abs(node2.x - node2.y));
			}
			if(dis1 < dis2){
				p = node1;
			}else if(dis1 > dis2){
				p = node2;
			}else if(dis1 != int.MAX_VALUE){
				p = node1;
			}else if(dis2 != int.MAX_VALUE){
				p = node2;
			}else{
				p = new Point(tox,toy);
			}
			
			return p;
		}
		
		/**
		 * 根据目标坐标移动几格
		 */
		public function caluOnePath(fx:int,fy:int,todir:int,step:int):Array{
			return _pathLayer.getForwardStep(fx,fy,todir,step);
		}
		
		public function canMove(p1:Point,p2:Point):Boolean{
			return this._pathLayer.canMove(p1,p2);
		}
		
		public function getBlockXY(id:String):Point{
			return this._pathLayer.getBlockXY(id);
		}
		
		public function getBlockXYInt(id:int):Point
		{
			return this._pathLayer.getBlockXYByInt(id);
		}
		
		public function getBlockCellXY(x:int,y:int):Point{
			return this._pathLayer.getBlockCellXY(x,y);
		}
		
		public function addUnwalk(x:int,y:int):void{
			this._pathLayer.addUnWalk(x,y);
		}
		
		public function removeUnwalk(x:int,y:int):void{
			this._pathLayer.removeUnWalk(x,y);
		}
		
		public function canWalk(x:int,y:int):Boolean{
			return this._pathLayer.getBlockValueByXY(x,y,this.cancross);
		}
		
		/*public function addActorToQuadTree(actor:HitDisplayObject):void{
			this._quadTree.addDisplayObject(actor);
		}
		
		public function removeActorFromQuadTree(actor:HitDisplayObject):void{
			this._quadTree.removeDisplayObjectBySelf(actor);
		}
		
		public function sortChildren(rect:Rectangle):Vector.<Object>{
			var sortArr:Vector.<Object> = this._quadTree.sortChildren(rect);
			return sortArr;
		}
		
		public function updateQuadTree(object:HitDisplayObject):void{
			this._quadTree.updateDisplay(object);
		}*/
		
		public var hitFrameDelay:int = 5;
		private var _curFrame:int = 0;
		
		/*public function hitTestAll(x:int,y:int,w:int,h:int,hitFunc:Function,unMaskFunc:Function):void{
			if(_curFrame < hitFrameDelay){
				_curFrame ++;
				return;
			}
			_curFrame = 0;
			var hits:Vector.<HitDisplayObject> = this._quadTree.checkHit(x,y,w,h);
			var unhits:Vector.<HitDisplayObject> = this._quadTree.unHitV;
			for each(var obj:HitDisplayObject in hits){
				hitFunc(obj.id);
			}
			for each(obj in unhits){
				if(obj.hited.length == 0){
					unMaskFunc(obj.id);
				}
			}
		}*/
		
		public function calculate():void{
			if(this._pathLayer){
				this._pathLayer.render();
			}
		}
		
		public function getRounds(p:Point):Array{
			var arr:Array = new Array();
			for(var key:Object in PathLayer.eigthArr){
				var po:Array = PathLayer.eigthArr[key];
				if(_pathLayer.isPassByTwoBlocks(p.x,p.y,(p.x + po[0]),(p.y + po[1]))){
					arr.push([po[0],po[1]]);
				}
			}
			return arr;
		}
		public function clear():void
		{
			if(_pathLayer)
				_pathLayer.clear();
		}
		
		public function stopFind():void{
			if(this._pathLayer)
				this._pathLayer.finding = false;
		}
		
		public function destroy():void
		{
			/*if(trans)
				DestroyUtil.destroyMap(trans);
			if(_mapGridsById)
				DestroyUtil.destroyMap(_mapGridsById);
			if(_guajiPoints)
				DestroyUtil.destroyVector(_guajiPoints);
			if(this.stallageArea)
				DestroyUtil.destroyVector(stallageArea);
			if(unWalkCfg)
				DestroyUtil.destroyMap(unWalkCfg);
			if(safeMcCfg)
			DestroyUtil.destroyMap(safeMcCfg);*/
			unWalkCfg = null;
			stallageArea = null;
			_guajiPoints = null;
			trans = null;
			safeMcCfg = null;
			this._coverDic = null;
			this._safeDic = null;
			this._digDic = null;
			_digArr = null;
			if(_pathLayer)
				_pathLayer.destroy();
			_pathLayer = null;
		}
		
	}
}