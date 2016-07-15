/**
 * 设计思想
 * 1、在转场时， 场景对象不在接受任何添加子元件的操作。
 */
package com.rpg.scene
{
	import com.core.destroy.DestroyUtil;
	import com.rpg.entity.Animal;
	import com.rpg.entity.ElementBase;
	import com.rpg.entity.GameSprite;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.IUpdateable;
	import com.rpg.framework.utils.Timer;
	import com.rpg.scene.actor.Effect;
	import com.rpg.scene.actor.RPGAnimal;
	import com.rpg.scene.control.DisposeManager;
	import com.rpg.scene.map2.MapTiles;
	import com.sh.game.global.Config;
	import com.sh.game.map.MapData;
	import com.sh.game.util.Logger;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	
	/** 游戏场景实体类 */
	public class SceneBase extends GameSprite
	{

		public function get frontMcLayer():SceneLayer
		{
			return _frontMcLayer;
		}

		public function get dataList():Dictionary
		{
			return _dataList;
		}

		public function get elements():Dictionary
		{
			return _elements;
		}

		/** 游戏场景加载完成事件  */
		public var gameSceneLoadComplete : Function;
		/** 游戏场景加载数据进度事件  */
		public var gameSceneDataProgress : Function;
		
		/**
		 * 地图背景
		 */
		protected var _bgLayer:SceneLayer;
		/**
		 * 景物、掉落动画
		 */
		protected var _mcLayer:SceneLayer;
		protected var _roleLayer:RoleSceneLayer;
		protected var _shadowLayer:SceneLayer;
		protected var _screenRect:Rectangle = new Rectangle();
		/**
		 * 技能特效层
		 */
		public var _skillLayer:SceneLayer;
		public var _skillLayer2:SceneLayer;
		protected var _nameLayer:SceneLayer;
		
		protected var _frontMcLayer:SceneLayer;
		
		
		public var configXml    : XML;						// 场景配制文件数据
		public var sceneUrl     : String;					// 场景资源路径
		public var instanceid    : int;						// 副本编号
		public var mapId        : int;						// 地图编号
		public var mapName      : String;					// 地图名
		public var description  : String;					// 地图说明
		public var scale	    : Number;					// 大小地图比例
		public var mapWidth     : int;						// 地图宽
		public var mapHeight    : int;						// 地图高
		public var offsetX	    : int;						// 地图偏移 X
		public var offsetY	    : int;						// 地图偏移 Y
		public var smallMap	    : Bitmap;					// 小地图
		
		protected var _elements : Dictionary;				// 游戏场景元件数据集合
		protected var _dataList : Dictionary;				// 游戏场景数据集合
		public var _effects:Dictionary;					// 游戏特效
		
		private var _mouseTargetName : String;
		
		protected var _mapData:MapData;
		protected var _zone:Object;
		protected var _mininame:String;
		public static var mapdatas:Dictionary = new Dictionary();
		protected var _mapTiles:MapTiles;
		public var screenX:int;
		public var screenY:int;
		protected var _scale:Number = 1;
		protected var skipframe:int = 0;
		protected var _roleSort:Array;
		protected var _tempChoose:int = 0;
		public var _stageEffectsDic:Dictionary;
		public var _stageEffects:Dictionary;
		protected var _posChanged:Boolean = false;
		
		public var updatePlus:Vector.<IUpdateable> = new Vector.<IUpdateable>();
		
		public function SceneBase()
		{
			_elements   = new Dictionary();
			_dataList   = new Dictionary();
			_effects = new Dictionary();
			_stageEffects = new Dictionary();
			_stageEffectsDic = new Dictionary();
		}
		
		public function get mapData():MapData
		{
			return _mapData;
		}
		
		public function stop():void{
			
		}
		
		/** 场景中鼠标按下事件 **/
		protected function onMouseDown(e : MouseEvent) : void
		{
			_mouseTargetName = e.target.name;
		}

		private function onMouseUp(e : MouseEvent) : void
		{
			_mouseTargetName = null;
		}
		
		public override function update(gameTime : GameTime) : void
		{
			/*if(skipframe < 1){
				skipframe ++;
			}else{
				skipframe = 0;
				if(this._mapTiles)
					_mapTiles.update(-this.width * 0.5/_scale +this.screenX /_scale,-this.height* 0.5/_scale +this.screenY/_scale);
			}*/
			super.update(gameTime);
			if(updatePlus)
			for each (var iupdater:IUpdateable in this.updatePlus) 
			{
				iupdater.update(gameTime);
			}
			
		}
		
		public function updateElementCount():void{
			if(_roleLayer)
				_roleLayer.updateElementCount();
		}
		
		public override function initialize() : void
		{
			//super.initialize();
		}
		
		public function initZone():void{
			if(this.display.stage){
				this._screenRect.width = this.display.stage.stageWidth;
				this._screenRect.height = this.display.stage.stageHeight;
			}
		}
		
		
		protected override function loadContent() : void
		{
			this.analyseData();
			this._bgLayer =  new SceneLayer(false);
			this._roleLayer = new RoleSceneLayer();
			//this._shadowLayer = new SceneLayer();
			this._nameLayer = new SceneLayer(false);
			this._skillLayer = new SceneLayer(false);
			this._skillLayer2 = new SceneLayer(false);
			this._mcLayer = new SceneLayer(false);
			this._frontMcLayer = new SceneLayer(false);
			
			super.addChild(this._bgLayer);
			super.addChild(this._mcLayer);
			//super.addChild(this._shadowLayer);
			super.addChild(this._skillLayer2);
			super.addChild(this._roleLayer);
			super.addChild(this._skillLayer);
			super.addChild(this._frontMcLayer);
			super.addChild(this._nameLayer);
			super.loadContent();
			
			// 地图加载完成事件
			if (gameSceneLoadComplete != null) gameSceneLoadComplete();
		}
		
		/**
		 * 更新当前地图显示与地图块的加载
		 */
		public function renderMap(useTween:Boolean = true,moveFrame:Number = 1):void{
			if(screenX > 0){
				screenX = 0;
			}
			if(screenX <  this.width - this._zone.width  * _scale){
				screenX = this.width - this._zone.width * _scale;
			}
			if(screenY <  this.height - this._zone.height * _scale ){
				screenY = this.height - this._zone.height * _scale;
			}
			if(screenY > 0){
				screenY = 0;
			}
			_posChanged = false;
			if(_screenRect.x != -screenX){
				_screenRect.x = -screenX;
				_posChanged = true;
			}
			if(_screenRect.y != -screenY){
				_screenRect.y = -screenY;
				_posChanged = true;
			}
			if(_posChanged)
				this.display.scrollRect = _screenRect;
		}
		
		public function get width():Number{
			return 0;
		}
		
		public function get height():Number{
			return 0;
		}
		
		public function addUpdater(updater:IUpdateable):void{
			this.updatePlus.push(updater);
		}
		
		public function removeUpdater(updater:IUpdateable):void{
			var index:int = this.updatePlus.indexOf(updater);
			if(index > -1){
				this.updatePlus.splice(index,1);
			}
		}
		
		public override function dispose() : void
		{
			
			this.configXml			   = null;
			this.smallMap			   = null;
			this.gameSceneLoadComplete = null;
			this.gameSceneDataProgress = null;
			_mininame = null;
			for each(var role:Animal in this._elements){
				if(role.parent)
					role.parent.removeChild(role);
				role.dispose();
			}
			/*if(_bgImg){
				if(	_bgImg.parent)
					_bgImg.parent.removeChild(_bgImg);
				_bgImg.destory();
			}
			_bgImg = null;*/
			
			//_mapData.destroy();
			for each(var eff:Effect in this._effects){
				if(eff.parent && eff.parent is SceneLayer)
					eff.parent.removeChild(eff);
				else{
					/*if(Config.debug){
						NbLog.getInstance().checkError(new Error(),ErrorType.RenderType,"残留特效：" + eff.eid + "  ");
						throw new Error("报错了，快截图~~特效id:" + eff.eid  + "\n");
					}else
						NbLog.getInstance().checkError(new Error(),ErrorType.RenderType,"残留特效：" + eff.eid + "  ");*/
				}
				//eff.dispose();
				if(!eff.reseted)
					DisposeManager.instance.disposeEffectLater(eff);
					//ObjectPoolManager.getInstance().returnItem(Constant.EffectClass,eff);
			}
			for each(eff in this._stageEffects){
				if(eff!= null){
					if(eff.parent)
						eff.parent.removeChild(eff);
					//eff.dispose();
					if(!eff.reseted)
						DisposeManager.instance.disposeEffectLater(eff);
						//ObjectPoolManager.getInstance().returnItem(Constant.EffectClass,eff);
				}
			}
			if(this._mapTiles)
				this._mapTiles.destroy();
			_mapData = null;
			_mapTiles = null;
			
			DestroyUtil.destroyMap(_dataList);
			DestroyUtil.destroyMap(_stageEffectsDic);
			DestroyUtil.destroyMap(_stageEffects);
			_elements = null;
			_bgLayer.dispose();
			//_shadowLayer.dispose();
			_roleLayer.dispose();
			_skillLayer.dispose();
			_skillLayer2.dispose();
			_nameLayer.dispose();
			_mcLayer.dispose();
			_effects = null;
			if(updatePlus)
				updatePlus.length = 0;
			updatePlus = null;
			screenX = 0;
			screenY = 0;
			_zone = null;
			_mininame = null;
			this.mapId = 0;
			super.dispose();
		}
		
		/**
		 * 获取场景上一个元件
		 * @param type	元件类型
		 * @param id	元件编号
		 * @return 元件
		 * 
		 */	
		public function getElement(id : Number) :Object
		{
				return _elements[id];
		}
		
		
		/**
		 * 获取场景上一个数据
		 * @param type	数据类型
		 * @param id	数据编号
		 * @return 数据
		 * 
		 */	
		public function getData(id : Number) : *
		{
			return _dataList[id];
		}
		public function addElement(type:int,data:Object,isme:Boolean = false):RPGAnimal{
			return null;
		}
		public function removeElement(id:Number):void{
			
		}
		
		public function addEffect(model:String):void{
			
		}
		
		/**
		 * 添加游戏元件 （必须设置游戏元件的ElementBase.layer属性才会正常添加显示）
		 * @param item 游戏元件
		 * 
		 */		
		public override function addChild(item : GameSprite) : void
		{
			if (this.enabled)
			{
				var element : ElementBase = item as ElementBase;
				_elements[element.id] = element;
				
				switch (element.layer)
				{
					case ElementBase.LAYER_MAPBG:
						throw Error("图层错误");
						break;
					case ElementBase.LAYER_ROLE:
						this._roleLayer.addChild(item);
						break;
					case ElementBase.LAYER_SHADOW:
						this._shadowLayer.addChild(item);
						break;
					case ElementBase.LAYER_NAME:
						this._nameLayer.addChild(item);
						break;
					case ElementBase.LAYER_SKILL:
						this._skillLayer.addChild(item);
						break;
					case ElementBase.LAYER_SKILL2:
						this._skillLayer2.addChild(item);
						break;
					case ElementBase.LAYER_EFFECT:
						this._mcLayer.addChild(item);
						break;
					case ElementBase.LAYER_EFFECT2:
						this._frontMcLayer.addChild(item);
						break;
					default:
						break;
				}
			}
		}

		/**
		 * 删除指定游戏元件 
		 * @param item 游戏元件
		 * 
		 */		
		public override function removeChild(item : GameSprite) : void
		{
			if (this.enabled)
			{
				var element : ElementBase = item as ElementBase;
				if (_elements)
				{
					delete _elements[element.id];
					if(this._dataList[element.id]){
						this._dataList[element.id] = null;
						delete this._dataList[element.id];
					}
				}
				switch (element.layer)
				{
					case ElementBase.LAYER_MAPBG:
						throw Error("图层错误");
						break;
					case ElementBase.LAYER_ROLE:
						this._roleLayer.removeChild(item);
						break;
					case ElementBase.LAYER_SHADOW:
						this._shadowLayer.removeChild(item);
						break;
					case ElementBase.LAYER_NAME:
						this._nameLayer.removeChild(item);
						break;
					case ElementBase.LAYER_SKILL:
						this._skillLayer.removeChild(item);
						break;
					case ElementBase.LAYER_SKILL2:
						this._skillLayer2.removeChild(item);
						break;
					case ElementBase.LAYER_EFFECT:
						this._mcLayer.removeChild(item);
						break;
					case ElementBase.LAYER_EFFECT2:
						this._frontMcLayer.removeChild(item);
						break;
					default:
						break;
				}
			}
		}
		
		public function getLayer(type:int):SceneLayer{
			switch (type)
			{
				case ElementBase.LAYER_MAPBG:
					return _bgLayer;
					break;
				case ElementBase.LAYER_ROLE:
					return _roleLayer;
					break;
				case ElementBase.LAYER_SHADOW:
					return _shadowLayer;
					break;
				case ElementBase.LAYER_NAME:
					return _nameLayer;
					break;
				case ElementBase.LAYER_SKILL:
					return _skillLayer;
					break;
				case ElementBase.LAYER_SKILL2:
					return _skillLayer2;
					break;
				case ElementBase.LAYER_EFFECT:
					return _mcLayer;
					break;
				case ElementBase.LAYER_EFFECT2:
					return _frontMcLayer;
					break;
				default:
					break;
			}
			return null;
		}

		/** 加载地图背景  */
		public function loadBackground() : void
		{
		}
		


		protected function analyseData() : void
		{

		}
		
		public function resize():void
		{
			
		}
		
		public function command(cmd:String,arg:Object):void
		{
			
		}
	}
}