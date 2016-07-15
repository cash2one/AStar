package com.rpg.scene.actor.compnent
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import bind.RoleEmbed;
	
	public class MiningMc extends Sprite
	{
		private var _qbBg:Bitmap;
		private var _qbBlood:Bitmap;
		private var _mining:Bitmap;
		private var _end:Bitmap;
		private var _type:int = -1;
		private static const BAR_WIDTH:int = 140;
		
		public function MiningMc()
		{
			super();
			_qbBlood = new Bitmap(RoleEmbed.getBitmapdata("png.zone.miningbar"));
			_qbBg = new Bitmap(RoleEmbed.getBitmapdata("png.zone.miningBg"));
			//_end =  new Bitmap(RoleEmbed.getBitmapdata("png.zone.miningHead"));
			_mining =  new Bitmap(RoleEmbed.getBitmapdata("png.zone.mining"));
			this.addChild(_mining);
			_mining.y = -40;
			_mining.x = (_qbBg.width - _mining.width) /2;
			this.addChild(_qbBg);
			this.addChild(_qbBlood);
			_qbBlood.x = 19;
			_qbBlood.y = 5;
			/*_end.y = -7;
			_end.x = this._qbBlood.width - 15;
			this.addChild(_end);*/
			setPersent(0);
		}
		
		
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			if(_type != value)
			{
				if(_mining && _mining.parent){
					_mining.parent.removeChild(_mining);
					if(value == 0)
						_mining = new Bitmap(RoleEmbed.getBitmapdata("png.zone.mining2"));
					else
						_mining = new Bitmap(RoleEmbed.getBitmapdata("png.zone.mining"));
					this.addChild(_mining);
					_mining.x = (_qbBg.width - _mining.width) /2;
					_mining.y = -40;
				}
			}
			_type = value;
		}

		public function setPersent(value:Number):void{
			/*if(value == 1){
				this._end.visible = false;
			}else{
				this._end.visible = true;
			}*/
			this._qbBlood.width =  BAR_WIDTH * value;
			
			//_end.x = this._barWidth*value - 15;
		}
		
		public function destroy():void{
			this.removeChild(_qbBg);
			this.removeChild(_qbBlood);
			//this.removeChild(_end);
			this.removeChild(_mining);
			
			if(this.parent){
				this.parent.removeChild(this);
			}
			_qbBg = null;
			_qbBlood = null;
			//_end = null;
			_mining = null;
		}
	}
}