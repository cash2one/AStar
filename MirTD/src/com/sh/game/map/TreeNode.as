package com.sh.game.map
{
	
	import com.core.destroy.DestroyUtil;
	import com.core.destroy.IDestroy;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	internal class TreeNode implements IDestroy
	{
		public static const NUM_CHILDREN_NODES:uint = 4;
		
		private var _parentNode:TreeNode = null;
		
		private var _viewRect:Rectangle = null;
		
		private var _childrenNodes:Vector.<TreeNode> = null;
		
		private var _displayObjectSort:Array = null;
		
		private var _displayObjects:Dictionary/*key DiaplayObject, value DisplayObject*/ = null;
		
		public var id:String = "0";
		
		public function TreeNode(viewRect:Rectangle)
		{
			_viewRect = viewRect;
			_childrenNodes = new Vector.<TreeNode>(NUM_CHILDREN_NODES);
			_displayObjects = new Dictionary();
			_displayObjectSort = new Array();
		}
		
		public function isLeafNode():Boolean
		{
			return _childrenNodes == null || 
				(_childrenNodes[0] == null && _childrenNodes[1] == null && _childrenNodes[2] == null && _childrenNodes[3] == null);
		}
		
		public function setParentNode(node:TreeNode):void
		{
			_parentNode = node;
		}
		
		public function getParentNode():TreeNode
		{
			return _parentNode;
		}
		
		public function getViewRect():Rectangle
		{
			return _viewRect;
		}
		
		public function getChildNode(index:uint):TreeNode
		{
			return _childrenNodes[index];
		}
		
		public function setChildNode(index:uint, node:TreeNode):void
		{
			_childrenNodes[index] = node;
		}
		
		public function getChildrenNodes():Vector.<TreeNode>
		{
			return _childrenNodes;
		}
		
		public function addDisplayObject(obj:HitDisplayObject):void
		{
			_displayObjects[obj] = obj;
			_displayObjectSort.push(obj);
		}
		
		public function removeDisplayObject(obj:HitDisplayObject):void
		{
			delete _displayObjects[obj];
			_displayObjectSort.splice(_displayObjectSort.indexOf(obj),1);
		}
		
		public function containsDisplayObject(obj:HitDisplayObject):Boolean
		{
			return _displayObjects[obj] != null;
		}
		
		public function getDisplayObjects():Dictionary
		{
			return _displayObjects;
		}
		
		public function destroy():void
		{
			_parentNode = null;
			_viewRect = null;
			
			DestroyUtil.breakArray(_displayObjectSort);
			_displayObjectSort = null;
			
			DestroyUtil.breakMap(_displayObjects);
			_displayObjects = null;
			
			DestroyUtil.destroyVector(_childrenNodes);
			_childrenNodes = null;
		}
		
		public function sortDisplayObjects():Array{
			_displayObjectSort.sortOn(["y","x","id"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
			return _displayObjectSort;
		}
	}
}