package com.rpg.scene.model
{
	import com.rpg.enum.Constant;

	public class GameObject
	{
		public var baseObj:Object;
		public function GameObject(base:Object)
		{
			this.baseObj = base;
			this.x = base.x * Constant.CELL_WIDTH + Constant.CELL_WIDTH * 0.5;
			this.y = base.y * Constant.CELL_HEIGHT + Constant.CELL_HEIGHT * 0.5;
			realHp = this.baseObj.ability.hp;
		}
		
		public function get ability():Object{
			if(!this.baseObj.abilityBuf){
				return this.baseObj.ability;
			}else{
				var obj:Object = new Object();
				for (var key:String in this.baseObj.ability){
					obj[key] = int(this.baseObj.ability[key]) + int(this.baseObj.abilityBuf[key]);
				}
				return obj;
			}
		}
		
		public function get attackSpeed():int{
			if(this.baseObj.abilityBuf)
				return  int(this.baseObj.ability.attackSpeed) + int(this.baseObj.abilityBuf.attackSpeed);
			else
				return  int(this.baseObj.ability.attackSpeed);
		}
		
		public function get maxHp():int{
			if(this.baseObj.abilityBuf)
				return  int(this.baseObj.ability.maxHp) + int(this.baseObj.abilityBuf.maxHp);
			else
				return  int(this.baseObj.ability.maxHp);
		}
		
		public function get maxMp():int{
			return  int(this.baseObj.ability.maxMp) + int(this.baseObj.abilityBuf.maxMp);
		}
		
		public function get hp():int{
			return this.baseObj.ability.hp;
		}
		
		public function get mp():int{
			return this.baseObj.ability.mp;
		}
		
		public var moved:Boolean = false;
		public var moving:Boolean = false;
		
		public var realHp:int = 0;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var slowDown:int = 0;
		public var buffers:Array = new Array();
		
	}
}