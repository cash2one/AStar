package com.rpg.framework.collections
{
	import com.rpg.entity.GameSprite;
	import com.rpg.entity.animation.AnimationPlayer;
	import com.rpg.framework.DrawableGameComponent;
	import com.rpg.framework.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	//import oops.framework.DrawableGameComponent;

	public class ArrayCollection extends Proxy implements IDisposable
	{
		private var items     : Array;
		private var allowSame : Boolean;

		/** 添加组件完成事件 */
		public var added   : Function;
		/** 删除组件完成事件 */
		public var removed : Function;

		public function ArrayCollection(allowSame : Boolean = true)
		{
			this.allowSame = allowSame;
			this.items = [];
		}

		public function get source():Array{
			return this.items;
		}
		
		public function add(item : *) : void
		{
			if (this.allowSame == false)
			{
				var index : int = this.items.indexOf(item);
				if (index != -1)
				{
					return;
				}
			}

			this.push(item);

			if (added != null)
			{
				added(item);
			}
		}
		
		public function get length():int{
			return this.items.length;
		}
		
		private function push(item:*):void
		{
			this.items.push(item);
		}
		
		public function remove(item : *) : Boolean
		{
			var index : int = this.items.indexOf(item);
			return this.removeAt(index);
		}

		public function removeAt(index : int) : Boolean
		{
			if (index > -1)
			{
				if (removed != null)
				{
					removed(this.items[index]);
				}

				if (this.items[index] is AnimationPlayer)
				{
					if(this.items[index].display && this.items[index].display.parent)
						this.items[index].display.parent.removeChild(this.items[index].display);
					//this.items[index].dispose();
				}else
				if (this.items[index] is DrawableGameComponent)
				{
					if(this.items[index].display && this.items[index].display.parent)
						this.items[index].display.parent.removeChild(this.items[index].display);
					//this.items[index].dispose();
				}
				else if (this.items[index] is IDisposable)
				{
					this.items[index].dispose();
				}
				else if (this.items[index] is DisplayObject)
				{
					if (this.items[index].parent != null)
					{
						this.items[index].parent.removeChild(this.items[index]);
					}
				}
				this.items[index] = null;
				this.items.splice(index, 1);
				return true;
			}
			return false;
		}

		public function clear() : void
		{
			while (this.items.length > 0)
			{
				this.removeAt(this.items.length - 1);
			}
		}

		public function dispose() : void
		{
			this.clear();
			this.items   = null;
			this.added   = null;
			this.removed = null;
		}

		//--------------------------------------------------//

		/*override flash_proxy function callProperty(methodName : *, ... args) : *
		{
			var res : *;
			res = items[methodName].apply(items, args);
			return res;
		}*/

		override flash_proxy function getProperty(name : *) : *
		{
			return items[name];
		}

		override flash_proxy function setProperty(name : *, value : *) : void
		{
			items[name] = value;
		}

		override flash_proxy function deleteProperty(name : *) : Boolean
		{
			return delete items[name];
		}

		override flash_proxy function hasProperty(name : *) : Boolean
		{
			return name in items;
		}

		override flash_proxy function nextNameIndex(index : int) : int
		{
			if (items != null && index < items.length)
			{
				return index + 1;
			}
			return 0;
		}

		override flash_proxy function nextName(index : int) : String
		{
			return String(index - 1);
		}

		override flash_proxy function nextValue(index : int) : *
		{
			return items[index - 1];
		}
		
		public function indexOf(e:GameSprite):int
		{
			return items.indexOf(e);
		}
		
		public function sortOn(param0:String, type:uint):void
		{
			this.items.sortOn(param0,type);
		}
		
		public function concat():Array
		{
			return this.items.concat();
		}
	}
}
