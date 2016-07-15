package com.rpg.scene.actor
{

	import com.core.destroy.DestroyUtil;
	import com.greensock.TweenLite;
	import com.rpg.enum.Constant;
	import com.rpg.framework.IUpdateable;
	import com.rpg.framework.collections.DictionaryCollection;
	import com.rpg.scene.actor.Npc;
	import com.rpg.scene.actor.RPGAnimal;
	import com.rpg.scene.actor.compnent.Eclipse;
	import com.rpg.scene.actor.compnent.HeadIcon;
	import com.rpg.scene.actor.compnent.IconMovie;
	import com.rpg.scene.actor.compnent.MoveTips;
	import com.rpg.scene.actor.compnent.Nonsense;
	import com.sh.game.global.Config;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	import util.FilterSet;
	

	/**
	 * 人物提示信息（玩家名、称号、图标等）-自动管理添加删除提示信息
	 */
	public class RPGAnimalInfos
	{
	
		public static const BLACK_FILTER:GlowFilter = new GlowFilter(0X000000,1,2,2);

		/** 和人物头顶之间的行间距 */
		public static const ROW_SPACE_ANIMAL_FOOT : int = 0; // 35
		/** 和人物上坐骑头顶之间的行间距 */
		public static const ROW_SPACE_ANIMAL_RIDE : int = 30; // 55
		/** 和人物跳跃头顶之间的行间距 */
		public static const ROW_SPACE_ANIMAL_JUMP : int = 75; // 90
		
		private static const WIDTH_OFFSET : int         = 3; // 文本宽偏移
		private static const ROW_SPACE_TEXT : int       = 15; // 文本行距
		
		private var _animal : RPGAnimal;
		private var _texts : DictionaryCollection;
		private var _icons:Array = new Array();
		private var _bloodBackground : Bitmap; // 血条背景
		private var _bloodRed : Bitmap; // 血条红
		//private var _nonsense:Nonsense;
		private var _rowSpaceAnimal : int               = 0; // 当前行间距
		private var _featIconOffsetY : int;
		private var _iconVip : Bitmap;
		private var _words:Array;
		public var mbloadY:int = 100;//血条高度
		private var _nameY:int = 135;
		private var _vipX:int = 34;
		//private var 
		
		/**
		 * icon的位置
		 */
		public var iconY:int = 140;
		
		public static const BloodTxt:String = "blood";
		public static const NameTxt:String = "nametxt";
		public static const UnionTxt:String = "union";
		public static const OtherTxt:String = "other";
		public static const GridTxt:String = "grid";
		public static const BookTxt:String = "booktxt";

		public static const BookIcon:String = "242302102";
		public static const COLLECTIONICON:String = "166";
		public static const RedBlood:String = "png.bloodred";
		public static const GreenBlood:String = "png.bloodgreen";
		public static const BlueBlood:String = "png.bloodblue";
		public static const EmptyBlood:String = "png.bloodempty";
		
		public static const BloodBar:String = "bloodBar";
		public static const NonsenseType:String = "nonsense";
		public static const Icons:String = "icons";
		
		private var titles:Array = new Array();
		
		private var _posArr:Array = new Array();
		private var _sortNext:Boolean = false;
		
		private var _bloodTween:TweenLite;
		private var _neiGongTween:TweenLite;
		public static const TxtSort:Array = [NameTxt,UnionTxt,OtherTxt,BookTxt];
		
		private var _eclipse:Eclipse;
		
		private var _infoContainer:Sprite;
		
		public function RPGAnimalInfos(animal : RPGAnimal)
		{
			_animal = animal;
			_texts = new DictionaryCollection();
			_rowSpaceAnimal = ROW_SPACE_ANIMAL_FOOT;
			_infoContainer = new Sprite();
			_animal._nameLayer.display.addChild(_infoContainer);
			_infoContainer.mouseChildren = false;
			_infoContainer.mouseEnabled = false;
		}
		
		public function set nameY(value:int):void
		{
			_nameY = value;
		}

		public function removeTitle(param0:int):void{
			var index:int = titles.indexOf(param0);
			if(index >= 0)
				titles.splice(index,1);
			this.removeIcon( param0 + "");
		}
		
		public function hideAll():void{
			if(_infoContainer)
				this._infoContainer.visible = false;
		}
		
		/**
		 * 设置称号
		 * @param param0 称号id
		 */
		public function setTitle(param0:int):void
		{
			if(titles.indexOf(param0) >= 0)
				return;
			titles.push(param0);
			if(param0 == 0)
				return;
			setIcon(param0,null,1);
		}
		
		/**
		 * 显示隐藏血条 
		 * @param showOrHide
		 */
		public function showBlood(showOrHide : Boolean):void{
			if(_bloodRed){
				if (showOrHide)
				{
					_infoContainer.addChildAt(_bloodRed, 0);
					_infoContainer.addChild(_bloodBackground);
					this.showText(BloodTxt);
				}
				else
				{
					if (_infoContainer.contains(_bloodBackground))
					{
						_infoContainer.removeChild(_bloodBackground);
					}
					if (_infoContainer.contains(_bloodRed))
					{
						_infoContainer.removeChild(_bloodRed);
					}
					this.hideText(BloodTxt);
				}
			}
		}
		
		/**
		 * 设置血条
		 *
		 */
		public function setBlood(hp:int,maxHp:int,show:Boolean = false) : void
		{
			if (_bloodRed == null)
			{
				_bloodBackground = new Bitmap(Resource.getRes(EmptyBlood));
				if(_animal.mine)
					_bloodRed = new Bitmap(Resource.getRes(GreenBlood));
				else
					_bloodRed = new Bitmap(Resource.getRes(RedBlood));
				if (_bloodRed)
				{
					_bloodBackground.x = -_bloodBackground.width >> 1;
					_bloodRed.x = -_bloodRed.width >> 1;
					_bloodRed.y = _bloodBackground.y= -mbloadY;
				}
				this.addText(BloodTxt,0xffffff);
				setPosition(BloodBar);
				setPosition(BloodTxt);
			}
			if(_bloodTween)
				_bloodTween.kill();
			_bloodTween = TweenLite.to(_bloodRed,0.6,{scaleX:Math.min(hp / maxHp, 1)});
			//_bloodRed.scaleX = ;
			this.setTexts(BloodTxt,hp + "/" + maxHp);
			if (show)
			{
				_infoContainer.addChildAt(_bloodRed, 0);
				_infoContainer.addChild(_bloodBackground);
				this.showText(BloodTxt);
			}
		}
		
		/**
		 * 设置 VIP 图标
		 */
		public function setVIPIcon(icon : BitmapData = null, offsetY : int = 0) : void
		{
			_featIconOffsetY = offsetY;
			if(_texts && _texts[NameTxt]){
				if (icon == null && _iconVip && _infoContainer.contains(_iconVip))
				{
					_infoContainer.removeChild(_iconVip);
					_iconVip = null;
				}
				else if (icon && _iconVip == null)
				{
					_iconVip = new Bitmap(icon);
					_infoContainer.addChild(_iconVip);
					_iconVip.y = (_texts[NameTxt]).y;
					_iconVip.x = (_texts[NameTxt]).x - _vipX;
				}
				else if (icon)
				{
					_iconVip.bitmapData = icon;
				}
			}
		}
		
		public function setTexts(key:*,value:String,show:Boolean = false):void
		{
			var t : TextField = getText(key);
			if(t == null){
				t = addText(key);
			}
			setText(key,value,t);
			if(show){
				this.showText(key);
				this.setPosition(key);
			}
		}
		
		public function setTxtColor(key:*,color:uint):void{
			var t : TextField = getText(key);
			if(t == null)
				return;
			t.textColor = color;
		}
		
		
		/**
		 * 所有文本和图标高度
		 * @param key 不重载当前关键字的文本组件位置
		 */
		public function setPosition(key:String = "all") : void
		{
			this.locateX(key);
			this.locateY(key);
		}
		
		public function locateX(key:String = "all"):void{
			var _icon:Object;
			var t:TextField;
			if(key == "all"){
				for (key in _texts)
				{
					t = _texts[key];
					switch(key)
					{
						case NameTxt:
						{
							t.x =  Math.round(-t.width * 0.5) ;
							if(_iconVip)
								_iconVip.x = t.x - _vipX;
							break;
						}
						case UnionTxt:
							t.x = Math.round(-t.width * 0.5) ;
							break;
						case OtherTxt:
							t.x = Math.round(-t.width * 0.5 );
							break;
						case BloodTxt:
							t.x = Math.round(-t.width * 0.5) ;
							break;
						case GridTxt:
							t.x = Math.round(-t.width * 0.5) ;
							t.text = int(this._animal.x / Constant.CELL_WIDTH) + "_" +  int(this._animal.y / Constant.CELL_HEIGHT);
							break;
						case BookTxt:
							t.x =  Math.round(-t.width * 0.5) ;
							break;
						default:
						{
							break;
						}
					}
				}
				if(_bloodBackground){
					_bloodBackground.x = -Math.round(_bloodBackground.width >> 1) ;
					_bloodRed.x = _bloodBackground.x;
				}
				if(_icons.length > 0){
					for each(_icon in _icons){
						if(_icon is Bitmap)
							_icon.x = Math.round(-_icon.width * 0.5)  ;
						else
							_icon.x = Math.round(-_icon.width * 0.5) ;
					}
				}
				/*if(_nonsense)
				{
					_nonsense.x = Math.round(-_nonsense.width/2);
				}*/
			}else{
				t = _texts[key];
				if(t)
					switch(key)
					{
						case NameTxt:
						{
							t.x =  Math.round(-t.width * 0.5) ;
							if(_iconVip)
								_iconVip.x = t.x - _vipX;
							break;
						}
						case UnionTxt:
							t.x = Math.round(-t.width * 0.5) ;
							break;
						case OtherTxt:
							t.x = Math.round(-t.width * 0.5) ;
							break;
						case BloodTxt:
							t.x = Math.round(-t.width * 0.5) ;
							break;
						case GridTxt:
							t.x = Math.round(-t.width * 0.5) ;
							t.text = int(this._animal.x / Constant.CELL_WIDTH) + "_" +  int(this._animal.y / Constant.CELL_HEIGHT);
							break;
						case BookTxt:
							t.x =  Math.round(-t.width * 0.5) ;
							break;
						case BloodBar:
							if(_bloodBackground){
								_bloodBackground.x = -Math.round(_bloodBackground.width >> 1) ;
								_bloodRed.x = _bloodBackground.x;
							}
							break;
						case NonsenseType:
							/*if(_nonsense)
							{
								_nonsense.x = Math.round(-_nonsense.width/2);
							}*/
							break;
						case Icons:
							if(_icons.length > 0){
								for each(_icon in _icons){
									if(_icon is Bitmap)
										_icon.x = Math.round(-_icon.width * 0.5)  ;
									else
										_icon.x = Math.round(-_icon.width * 0.5) ;
								}
							}
							break;
						default:
						{
							break;
						}
					}
			}
			
		}
		
		public function locateY(key:String = "all"):void{
			var t:TextField;
			var offsetY:int = -_animal.offsetY;
			if(key == "all")
			{
				for (key  in _texts)
				{
					t = _texts[key];
					switch(key)
					{
						case NameTxt:
						{
							t.y = offsetY - _posArr[0];
							if(_iconVip)
								_iconVip.y = t.y;
							break;
						}
						case UnionTxt:
							t.y = offsetY  - this._posArr[1];
							break;
						case OtherTxt:
							t.y = offsetY  - _posArr[2];
							break;
						case BloodTxt:
							t.y = offsetY  -this.mbloadY  - 20;
							break;
						case GridTxt:
							t.y =  - 20;
							t.text = int(this._animal.x / Constant.CELL_WIDTH) + "_" +  int(this._animal.y / Constant.CELL_HEIGHT);
							break;
						case BookTxt:
							t.y = offsetY  - _posArr[3];
							break;
						default:
						{
							break;
						}
					}
				}
				if(_bloodBackground)
					_bloodRed.y = _bloodBackground.y = offsetY - mbloadY ;
				/*if(_nonsense)
				{
					_nonsense.y =  Math.round(- offsetY  - 150);
				}*/
				
				if(_texts[BookTxt]){
					for each(var iconImg:Object in this._icons){
						if(iconImg.name == BookIcon){
							t.y =  iconImg.y - 20;
							break;	
						}
					}
				}
				locationIcon();
			}else{
				t = _texts[key];
				if(t)
					switch(key)
					{
						case NameTxt:
						{
							t.y = offsetY -  _posArr[0];
							if(_iconVip)
								_iconVip.y = t.y;
							break;
						}
						case UnionTxt:
							t.y = offsetY   -  _posArr[1];
							break;
						case OtherTxt:
							t.y = offsetY  -  _posArr[2];
							break;
						case BloodTxt:
							t.y = offsetY  -this.mbloadY  - 20;
							break;
						case GridTxt:
							t.y =  - 20;
							t.text = int(this._animal.x / Constant.CELL_WIDTH) + "_" +  int(this._animal.y / Constant.CELL_HEIGHT);
							break;
						case BookTxt:
							t.y = offsetY  - _posArr[3];
							break;
						case BloodBar:
							if(_bloodBackground)
								_bloodRed.y = _bloodBackground.y = offsetY - mbloadY ;
							break;
						case NonsenseType:
							/*if(_nonsense)
							{
								_nonsense.y =  Math.round(- offsetY  - 150);
							}*/
							break;
						default:
						{
							break;
						}
					}
			}
		}
		
		public function setPositionX(value:int):void
		{
			this._infoContainer.x = value;
			if(_eclipse){
				_eclipse.x = value;
			}
		}
		
		public function setPositionY(value:int):void{
			this._infoContainer.y = value;
			if(_eclipse){
				_eclipse.y = value;
			}
		}
		
		
		
		/** 获取一个文本提示项 */
		public function getText(key : *) : TextField
		{
			return _texts[key];
		}
		
		/** 添加一个文本提示项 */
		public function addText(key : *,color:uint = 0xFFFFFF) : TextField
		{
			var t : TextField = new TextField();
			t.cacheAsBitmap = true;
			t.mouseEnabled = false;
			t.mouseWheelEnabled = false;
			t.selectable = false;
			t.type = TextFieldType.DYNAMIC;
			t.height = 18;
			t.width = 120;
			t.textColor = color;
			t.filters = [FilterSet.miaobian];
			var tf : TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 12;
			tf.font = "宋体";//Config.deviceFonts;
			t.defaultTextFormat = tf;
			_texts.add(key, t);
			return t;
		}
		
		/** 设置文本宽 */
		private function setText(key : *, text : String,tf:TextField = null) : void
		{
			if(tf == null)
			{
				tf =  this.getText(key);
			}
			tf.text = text == null ? "" : text;
			if(key == NameTxt || key == UnionTxt || key == OtherTxt){
				tf.width = tf.getLineMetrics(0).width + WIDTH_OFFSET;
				tf.x = -tf.width >> 1;
			}
		}
		
		/** 显示一个文本提示项 */
		public function showText(key : *) : void
		{
			if (_texts[key] && _infoContainer.contains(_texts[key]) == false)
			{
				_infoContainer.addChild(_texts[key]);
				_sortNext = true;
			}
		}
		
		/** 隐藏一个文本提示项 */
		public function hideText(key : *) : void
		{
			if (_texts[key] && _infoContainer.contains(_texts[key]))
			{
				_infoContainer.removeChild(_texts[key]);
				_sortNext = true;
			}
		}
		
		/**
		 * 移除一个文本 
		 * @param key
		 */
		public function removeText(key:*):void{
			if(_texts[key]){
				var t:TextField = _texts[key];
				if(t.parent)
					t.parent.removeChild(t);
				_texts.remove(key);
				_sortNext = true;
			}
		}
		
		/** 所有文本总高度 */
		private function getTextTotalHeight(index : int) : int
		{
			return ROW_SPACE_TEXT * index + _rowSpaceAnimal;
		}
		
		public function dispose() : void
		{
			if(_eclipse){
				if(_eclipse.parent)
					_eclipse.parent.removeChild(_eclipse);
				_eclipse.dispose();
				_eclipse = null;
			}
			if (_texts)
			{
				for each (var t:TextField in _texts) 
				{
					if(t.parent)
						t.parent.removeChild(t);
					t = null;
				}
				_texts.dispose();
				_texts = null;
			}
			if(_bloodTween){
				_bloodTween.kill();
				_bloodTween = null;
			}
			if(_neiGongTween){
				this._neiGongTween.kill();
				this._neiGongTween = null;
			}
			if(_icons && _icons.length > 0){
				for each(var iconImg:Object in this._icons){
					//this._icons.splice(_icons.indexOf(iconImg),1);
					if(iconImg.parent)
						iconImg.parent.removeChild(iconImg);
					if(iconImg is IconMovie){
						this._animal.zone.removeUpdater(iconImg as IUpdateable);
						iconImg.dispose();
					}
				}
			}
			if(_infoContainer){
				DestroyUtil.removeChildren(_infoContainer);
				if(_infoContainer.parent)
					_infoContainer.parent.removeChild(_infoContainer);
				_infoContainer = null;
			}
			_icons = null;
			if (_iconVip)
			{
				_iconVip = null;
			}
			
			if (_bloodBackground)
			{
				_bloodBackground = null;
			}
			
			if (_bloodRed)
			{
				_bloodRed = null;
			}
			/*if(_nonsense)
			{
				_nonsense.clear();
				_nonsense = null;
			}*/
			_animal = null;
		}
		
		public function noCare():void
		{
			this.showBlood(false);
			for (var key : * in _texts)
			{
				this.hideText(key);
			}
		}
		
		public function payAttention():void{
			for (var key : * in _texts)
			{
				if(key == BloodTxt && this._animal.dead){
					continue;
				}
				if(key == NameTxt && this._animal.zone ){
					continue;
				}
				this.showText(key);
			}
		}
		
		/**
		 * 头上冒血 
		 * @param hp
		 * @param type
		 * @param dir
		 * @param hit
		 * 
		 */
		public function hurtTips(hp:int,type:int,dir:int = 0,hit:int= 1):void{
			var mt:MoveTips = new MoveTips(hp,type,hit);
			if(this._animal._nameLayer){
				this._animal._nameLayer.display.addChild(mt);
				mt.x = int(this._animal.x);
				mt.y = int(this._animal.y -this.mbloadY - 20);
				mt.startMove(dir);
			}
		}
		
		/**
		 * 增加icon 
		 * @param icon
		 * @param texture
		 * @param type
		 * 
		 */
		public function setIcon(icon:*,texture:* = null,type:int = 0):void{
		/*	if(icon == "task_accept" || icon == "task_canaccept" || icon == "task_succeed" ||icon =="task_cantaccept"){
				var _icon:IconMovie = new IconMovie(RoleEmbed.getTask(icon),0,0,1000/6);
				_infoContainer.addChild(_icon);
				_icon.x = -int(_icon.width / 2) ;
				_icon.y = int(-iconY  ) - _icon.height - 5 ;//+ this._offsetY;
				_icon.name = icon;
				_icon.data = 1;
				_icons.push(_icon);
				this._animal.zone.addUpdater(_icon);
				sortIcon();
				locationIcon();
				return;
			}*/
			if(texture){
				var _icon2:HeadIcon = new HeadIcon(texture as BitmapData);
				_infoContainer.addChild(_icon2);
				_icon2.x = -int(_icon2.width / 2) ;
				_icon2.y = int(-iconY )  - _icon2.height - 5 ;//+ this._offsetY;
				_icons.push(_icon2);
				_icon2.name = icon;
				if(type == 2)
					_icon2.data = 1;
				else
					_icon2.data = 0;
				sortIcon();
				locationIcon();
			}else{
				var dic:String = "assets/images/icon/func/";
				if(type == 1)
					dic = "assets/images/icon/title/";
				else if(type == 2)
					dic = "assets/images/icon/tools/";
				for(var i:int =0;i<_icons.length;i++)
				{
					var temp:HeadIcon = _icons[i];
					if(type == 2&&temp.data == 1&&temp.name == icon)
					{
						return;
					}
					else if(type!=2&&temp.data == 0&&temp.name == icon)
						return;
				}
				/*App.maploader.loadBMD(Config.getUrl( dic+ icon +".png"),1,new Handler(function(content:*):void{
					if(_animal){
						if(content){
							if(type != 1 || icon == _animal.cuttitle)
							{
								var _icon:HeadIcon = new HeadIcon(content as BitmapData);
								_infoContainer.addChild(_icon);
								_icon.x = -int(_icon.width / 2) ;
								_icon.y = int(-iconY  )  - _icon.height - 5;// + _offsetY;
								_icons.push(_icon);
								_icon.name = icon;
								if(type == 2)
									_icon.data = 1;
								else
									_icon.data = 0;
								sortIcon();
								locationIcon();
							}
						}
					}
				}));*/
			}
		}
		
		private function sortIcon():void
		{
			_icons.sortOn("data", Array.NUMERIC);
		}
		
		private function locationIcon():void{
			if(this._icons.length > 0){
				var h:int = 0;
				for each(var _icon:Object in _icons){
					var hei:int;
					if(_icon is Bitmap)
						hei = _icon.height ;
					else
						hei = _icon.height ;
					_icon.y = int(-iconY - this._animal.offsetY ) - hei - 5 - h ;//+ this._offsetY;
					h += hei + 10;
				}
			}
		}
		
		/**
		 * 移除icon 
		 * @param icon
		 */
		public function removeIcon(icon:String):void{
			for each(var iconImg:Object in this._icons){
				if(iconImg.name == icon){
					this._icons.splice(_icons.indexOf(iconImg),1);
					if(iconImg.parent)
						iconImg.parent.removeChild(iconImg);
					if(iconImg is IconMovie){
						iconImg.dispose();
						this._animal.zone.removeUpdater(iconImg as IUpdateable);
					}
				}
			}
		}
		
		/**
		 * 说话 
		 * @param word
		 */
		/*public function speak(word:String):void
		{
			if(_nonsense==null){
				_nonsense = new Nonsense(this._infoContainer);
			}
			if(word == ""){
				if(_words && _words.length > 0){
					if(StringUtil.trim(_words[0]) == "")
						return;
					_nonsense.talkNonsense(_words[int(_words.length * Math.random())]);
					_nonsense.x = int( -_nonsense.width/2);
					_nonsense.y = int(- this._animal.offsetY  - 150);
				}
			}else{
				_nonsense.talkNonsense(word);
				_nonsense.x = int( -_nonsense.width/2);
				_nonsense.y = int( - this._animal.offsetY  - 150);
			}
		}*/
		
		public function setWords(arr:Array):void{
			this._words = arr;
		}
		
		/**
		 *花圆 
		 * @param gird 格子数
		 * @param color 颜色
		 * 
		 */		
		public function addEclipse(gird:int = 17,color:uint = 0x00ff00):void{
			_eclipse = new Eclipse();
			_eclipse.draw(Constant.CELL_WIDTH * gird, Constant.CELL_HEIGHT * gird,color);
			this._animal._mcLayer.display.addChild(_eclipse);
			_eclipse.x = this._animal.x;
			_eclipse.y = this._animal.y;
		}
		public function removeEclipse():void
		{
			if(_eclipse)
			{
				if(_eclipse.parent)
					_eclipse.parent.removeChild(_eclipse);
				_eclipse.dispose();
				_eclipse = null;
			}
		}
		
		
		public function sortTxt():void{
			if(_sortNext){
				var index:int = 0;
				for  (var i:Object in TxtSort) 
				{
					var o:Object = TxtSort[i];
					var txt:TextField = this.getText(o);
					_posArr[i] = index * 15 + this._nameY;
					if(txt){
						index ++;
					}
				}
				if(!(this._animal is Npc))
					this.iconY = _posArr[TxtSort.length - 1];
				this.locateY();
				_sortNext = false;
			}
		}
	}
}
