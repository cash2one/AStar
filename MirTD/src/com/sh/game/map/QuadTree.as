package com.sh.game.map
{
	
	import com.core.destroy.DestroyUtil;
	import com.core.destroy.IDestroy;
	import com.sh.game.util.BitmapDataHitTestUtil;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	

	public class QuadTree implements IDestroy
	{
		private var _mainNode:TreeNode = null;
		
		private var _treeDepth:uint = 0;
		
		private var _tempDisplayObjects:Vector.<HitDisplayObject> = null;
		
		private var _tempRect:Rectangle = null;
		
		private var _tempNodes:Vector.<TreeNode> = null;
		
		private var _displayObjects:Vector.<HitDisplayObject> = null;
		
		private var _displaySorts:Vector.<Object> = null;
		
		public var hitV:Vector.<HitDisplayObject>;
		public var unHitV:Vector.<HitDisplayObject>;
		
		public function QuadTree(viewRect:Rectangle, treeDepth:uint = 6)
		{
			_mainNode = new TreeNode(viewRect);
			_treeDepth = treeDepth;
			_tempDisplayObjects = new Vector.<HitDisplayObject>();
			_tempNodes = new Vector.<TreeNode>();
			_tempRect = new Rectangle();
			_displayObjects = new Vector.<HitDisplayObject>();
			_displaySorts = new Vector.<Object>();
			createTree(_mainNode, 0);
		}
		
		public function addDisplayObject(object:HitDisplayObject):HitDisplayObject
		{
			return addRemoveExecute(object, true);
		}
		
		
		public function removeDisplayObjectBySelf(object:HitDisplayObject):void
		{
			if(object.node){
				object.node.removeDisplayObject(object);
				object.node = null;
			}
		}
		
		public function removeDisplayObject(object:HitDisplayObject):HitDisplayObject
		{
			return addRemoveExecute(object, false);
		}
		
		public function getDisplayObjects(x:Number, y:Number, width:Number, height:Number):Vector.<HitDisplayObject>
		{
			_tempRect.x= x;
			_tempRect.y = y;
			_tempRect.width = width;
			_tempRect.height = height;
			
			_tempNodes.length = 0;
			_tempNodes.push(_mainNode);
			var tempNodesLength:uint = 1;
			var object:HitDisplayObject;
			_displayObjects.length = 0;
			var objects:Dictionary;
			objects = _mainNode.getDisplayObjects();
			for each(object in objects)
			{
				_displayObjects.push(object);
			}
			while(true)
			{
				var node:TreeNode = _tempNodes.pop();
				tempNodesLength--;
				
				if(node.getViewRect().intersects(_tempRect))
				{
					var childrenNodes:Vector.<TreeNode> = node.getChildrenNodes();
					for each(node in childrenNodes)
					{
						objects = node.getDisplayObjects();
						for each(object in objects)
						{
							_displayObjects.push(object);
						}
						if(!node.isLeafNode()){
							_tempNodes.push(node);
							tempNodesLength++;
						}
					}
				}
				
				if(tempNodesLength == 0)
				{
					break;
				}
			}
			
			return _displayObjects;
		}
		
		private function checkDisplayObjectUpdate(object:HitDisplayObject):Boolean{
			var node:TreeNode = object.node;
			if(node){
				return true;
			}else{
				return true;
			}
		}
		
		private function addObject(node:TreeNode,object:HitDisplayObject):HitDisplayObject{
			node.addDisplayObject(object);
			object.node = node;
			return object;
		}
		
		private function removeObjcet(node:TreeNode,object:HitDisplayObject):HitDisplayObject{
			if(node.containsDisplayObject(object))
			{
				node.removeDisplayObject(object);
				object.node = null;
				return object;
			}
			else
			{
				return null;
			}
		}
		
		private function addRemoveExecute(object:HitDisplayObject, isAdd:Boolean):HitDisplayObject
		{
			if(!_mainNode.getViewRect().intersects(object.viewRect))
			{
				return null;
			}
			
			var currNode:TreeNode = _mainNode;
			var parentNode:TreeNode = currNode;
			while(true)
			{
				for(var i:uint = 0;i < TreeNode.NUM_CHILDREN_NODES; i++)
				{
					var childNode:TreeNode = currNode.getChildNode(i);
					if(childNode.getViewRect().containsRect(object.viewRect))
					{
						parentNode = childNode;
						currNode = childNode;
						if(childNode.isLeafNode()){
							if(isAdd)
							{
								return addObject(childNode,object);
							}
								// isRemove
							else
							{
								return removeObjcet(childNode,object);
							}
						}
						break;
					}else if(childNode.getViewRect().intersects(object.viewRect)){
						if(isAdd)
						{
							return addObject(parentNode,object);
						}
							// isRemove
						else
						{
							return removeObjcet(parentNode,object);
						}
					}
				}
			}
			
			trace("Illegal run to this step");
			return null;
		}
		
		public function updateDisplay(object:HitDisplayObject):void{
			if(!_mainNode.getViewRect().intersects(object.viewRect))
			{
				return;
			}
			if(checkDisplayObjectUpdate(object)){
				this.removeDisplayObjectBySelf(object);
				this.addDisplayObject(object);
			}
		}
		
		public function sortChildren(rect:Rectangle):Vector.<Object>{
			_tempRect = rect;
			_tempNodes.length = 0;
			_tempNodes.push(_mainNode);
			var tempNodesLength:uint = 1;
			
			_displaySorts.length = 0;
			
			while(true)
			{
				var node:TreeNode = _tempNodes.shift();
				tempNodesLength--;
				
				if(node.getViewRect().intersects(_tempRect))
				{
					if(node.isLeafNode())
					{
						var objects:Array = node.sortDisplayObjects();
						for each(var object:HitDisplayObject in objects)
						{
							_displaySorts.push(object);
						}
					}
					else
					{
						var childrenNodes:Vector.<TreeNode> = node.getChildrenNodes();
						for each(node in childrenNodes)
						{
							_tempNodes.push(node);
							tempNodesLength++;
						}
					}
				}
				
				if(tempNodesLength == 0)
				{
					break;
				}
			}
			return _displaySorts;
		}
		
		private function createTree(parentNode:TreeNode, depthCount:uint):void
		{
			if(depthCount++ >= _treeDepth)
			{
				return;
			}
			else
			{
				for(var i:uint = 0; i < TreeNode.NUM_CHILDREN_NODES; i++)
				{
					var parentViewRect:Rectangle = parentNode.getViewRect();
					var cellWidth:Number = parentViewRect.width * .5;
					var cellHeight:Number = parentViewRect.height * .5;
					var viewRect:Rectangle = new Rectangle(
						parentViewRect.x + (i == 0 || i == 2 ? 0 : 1) * cellWidth, 
						parentViewRect.y + (i == 0 || i == 1 ? 0 : 1) * cellHeight, 
						cellWidth, cellHeight
					);
					
					var node:TreeNode = new TreeNode(viewRect);
					node.id = depthCount +":" + i;
					parentNode.setChildNode(i, node);
					node.setParentNode(parentNode);
					createTree(node, depthCount);
				}
			}
		}
		
		
		public function checkHit(x:int,y:int,w:int,h:int):Vector.<HitDisplayObject>{
			if(null == hitV){
				hitV = new Vector.<HitDisplayObject>();
			}else{
				hitV.splice(0,hitV.length);
			}
			if(null == unHitV){
				unHitV = new Vector.<HitDisplayObject>();
			}else{
				unHitV.splice(0,unHitV.length);
			}
			var objs:Vector.<HitDisplayObject> = this.getDisplayObjects(x,y,w,h);
			var closed:Dictionary = new Dictionary();
			var objects:Dictionary;
			var object:HitDisplayObject;
			var _tempNodes:Vector.<TreeNode> = new Vector.<TreeNode>();
			while(objs.length > 0){
				var obj:HitDisplayObject = objs.shift();
				var curNode:TreeNode = obj.node;
				var hited:Boolean = false;
				for each(object in obj.hited){
					if(!BitmapDataHitTestUtil.hitTest(obj,object,20,41)){
						obj.removeHited(object);
						object.removeHited(obj);
						unHitV.push(obj);
						unHitV.push(object);
					}
				}
				//if(obj.updated){
					while(curNode){
						objects = curNode.getDisplayObjects();
						for each(object in objects)
						{
							if(closed[object]){
								continue;
							}
							if(object.bitmapData == null || obj.bitmapData == null)
								continue;
							if(object == obj){
								continue;
							}
							if(obj.call || object.call){
								if(!obj.call && (obj.roleY < object.roleY  || (obj.roleY == object.roleY && obj.roleX <  object.roleX))){
									continue;
								}
								if(!object.call && (object.roleY < obj.roleY || (object.roleY == obj.roleY && object.roleX <  obj.roleX))){
									continue;
								}
								if(BitmapDataHitTestUtil.hitTest(obj,object,20,41)){
									if(obj.addHited(object)){
										hitV.push(obj);
									}
									if(	object.addHited(obj)){
										hitV.push(object);
									}
									hited = true;
								}
							}
						}
						if(!curNode.isLeafNode()){
							var childrenNodes:Vector.<TreeNode> = curNode.getChildrenNodes();
							for each(var node:TreeNode in childrenNodes)
							{
								_tempNodes.push(node);
							}
						}
						if(_tempNodes.length == 0)
							break;
						curNode = _tempNodes.shift();
					}
					//obj.updated = false;
					closed[obj] = true;
				//}
			}
			return hitV;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyObject(_mainNode);
			_mainNode = null;
			
			DestroyUtil.breakVector(_tempDisplayObjects);
			_tempDisplayObjects = null;
			
			DestroyUtil.breakVector(_tempNodes);
			_tempNodes = null;
			
			_tempRect = null;
			
			DestroyUtil.breakVector(_displaySorts);
			_displaySorts = null;
			
			DestroyUtil.breakVector(_displayObjects);
			_displayObjects = null;
		}
	}
}