package com.rpg.scene.actor
{
	import com.mgame.battle.Zone;
	import com.mgame.model.ConfigData;
	import com.rpg.entity.Body;
	import com.rpg.enum.Constant;
	import com.rpg.enum.EffectType;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.transfer.ITweenAble;
	import com.rpg.framework.system.transfer.Tween;
	import com.rpg.framework.utils.TimeOutManager;
	import com.rpg.framework.utils.Vector2Extension;
	import com.rpg.pool.IPoolItem;
	import com.rpg.pool.ObjectPoolManager;
	import com.rpg.scene.SceneBase;
	import com.rpg.scene.actor.skin.effect.EffectSkin;
	import com.rpg.scene.control.DisposeManager;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	
	public class Effect extends Body implements ITweenAble, IPoolItem
	{
		protected var _model:String;
		private var _eid:int;
		private var _effectType:int;
		protected var _scene:Zone;
		public var targetPoint:RPGAnimal;
		private var _tween:Tween;
		protected var _loop:Boolean = false;
		protected var _effectSkin:EffectSkin;
		public var pos:int;
		private var _dir:int = -1;
		private var _liveTime:int;
		public var reseted:Boolean = false;
		public var skillCfg:Object;
		public var hited:Object;
		//private var _aoldlist:Array = new Array();
		//public var liveid:int = 0;
		//public static var tliveid:int = 0;
		public function get eid():int
		{
			return _eid;
		}

		private var destoryFunc:Function;
		public var endFunc:Function;
		public static var __autoid:int = 0;
		private var _lastupdate:int = 0;
		
		private var _delayShowUint:uint;
		
		private var _readyToEnd:Boolean = false;
		/**
		 * 加载中的时候是否在加载完成后显示
		 * 1,下载完后显示
		 * 0，下载后不显示
		 */
		public var loadshow:int = 0;
		/**
		 * 
		 * @param eid 配置表eid
		 * @param scene 场景
		 * @param typeExt 特效类型
		 * @param loop 循环播放，非循环的播放完自动清理
		 * @param destoryFunc 移动特效，移动完之后执行的
		 * @param rotation  旋转角度
		 * @param scaleX     
		 * @param scaleY
		 * @param randomFrame 随机起始帧
		 * @param prority   优先级，暂时没用- -
		 * 
		 */
		public function Effect()
		{
			super();
			//liveid = tliveid++;
			/*this._eid = eid;
			_effectType = typeExt;
			_scene = scene;
			_dir = dir;
			_skin = this._bodySkin = this._effectSkin = new EffectSkin(this,randomFrame);
			this._loop = loop;
			if(loop){
				_skin.playMaxCount  = -1;
			}else{
				_skin.playMaxCount  = 1;
			}
			this.display.scaleX = scaleX;
			this.display.scaleY = scaleY;
			if(typeExt == EffectType.MOVE){
				_tween = ObjectPoolManager.getInstance().borrowItem(Constant.TweenClass) as Tween;
				_tween.moveComplete = onMoveComplete;
				_tween.display = this;
				this.components.add(_tween);
				this.destoryFunc = destoryFunc;
			}
			if(delay > 0)
			{
				this.visible = false;
				_delayShowUint  = TimeOutManager.getInstance().setTimer(showEff,delay);
			}*/
		}
		
		public function init(eid:int, scene:Zone,typeExt:int=0, loop:Boolean=true,dir:int = -1, destoryFunc:Function=null, rotation:int=0, scaleX:Number=1,scaleY:Number = 1, randomFrame:Boolean=false,   prority:int=1,delay:int = 0,skill:Object = null):void{
			this._eid = eid;
			//_aoldlist.push(eid);
			this.skillCfg = skill;
			reseted = false;
			_effectType = typeExt;
			_scene = scene;
			_dir = dir;
			if(this._skin == null){
				_skin = this._bodySkin = this._effectSkin = new EffectSkin(this,randomFrame);
			}else{
				_effectSkin.relive();
			}
			_effectSkin.randomFrame = randomFrame;
			this._loop = loop;
			if(loop){
				_skin.playMaxCount  = -1;
			}else{
				_skin.playMaxCount  = 1;
			}
			this.display.scaleX = scaleX;
			this.display.scaleY = scaleY;
			if(typeExt == EffectType.MOVE){
				if(_tween == null){
					_tween = ObjectPoolManager.getInstance().borrowItem(Constant.TweenClass) as Tween;
				}
				hited = new Object();
				_tween.moveComplete = onMoveComplete;
				_tween.moveStep = onMoveStep;
				_tween.display = this;
				this.components.add(_tween);
				this.destoryFunc = destoryFunc;
			}
			if(delay > 0)
			{
				this.visible = false;
				if(_delayShowUint > 0){
					TimeOutManager.getInstance().clearTimer(_delayShowUint);
					_delayShowUint = 0;
				}
				_delayShowUint  = TimeOutManager.getInstance().setTimer(showEff,delay);
			}
		}
		
		private function showEff():void
		{
			this.visible = true;
			_delayShowUint = 0;
		}
		
		public function setAutoid():int{
			this.id = ++__autoid;
			return id;
		}
		
		private function onMoveStep():void{
			if(this.skillCfg && this._scene){
				this._scene.hitTestMonsters(this.x,this.y,this.skillCfg,this);
			}
		}
		
		private function onMoveComplete(time:int):void
		{
			if(this.destoryFunc != null)
				destoryFunc(this.x,this.y);
			if(this._effectType == EffectType.MOVE){
				
				if(this.parent)
					this.parent.removeChild(this);
				if(this._scene){
					_scene.removeEff(this);
				}else{
					//this.dispose();
					if(!this.reseted)
						DisposeManager.instance.disposeEffectLater(this);
				}
			}
		}
		
		
		override public function update(gameTime:GameTime):void{
			if(this.targetPoint){
				if(this._effectType == EffectType.MOVE){
					_lastupdate += gameTime.elapsedGameTime;
					if(_lastupdate > 100){
						var hitpoint:Point = targetPoint.hitPoint;
						if(targetPoint.display){
							var tx:int = targetPoint.x ;
							var ty:int = targetPoint.y;
							if(hitpoint){
								ty = ty+hitpoint.y;
							}
							if(targetPoint && (_tween.end.x != tx || _tween.end.y != ty)){
								moveTo(tx,ty);
							}
						}else{
							targetPoint = null;
						}
						_lastupdate = 0;
					}
					
				}else{
					if(targetPoint.display){
						this.x = targetPoint.x;
						this.y = targetPoint.y;
					}else{
						targetPoint = null;
					}
				}
			}
			super.update(gameTime);
			if(_readyToEnd)
			{
				if(_liveTime < gameTime.totalGameTime){
					this.endMovie();
					_readyToEnd = false;
				}
			}
		}
		
		public override function initialize():void{
			if(!_initialized){
				this.loadContent();
				this._initialized = true;
				if(_eid > 0){
					var effects:Object = ConfigData.allCfgs[ConfigData.EFFECT];
					if(effects[_eid] && effects[_eid].model){
						var eff:Object = effects[_eid];
						loadshow = eff.loadshow;
						this._model = effects[_eid].model;
						this._effectSkin.setSkin(ElementSkinType.SKILL,_model,"");
						//this._bodySkin.getDataSets(ElementSkinType.SKILL).model = _model;
						this._effectSkin.setIntval(effects[_eid].intval);
						this.display.blendMode = effects[_eid].blendmode=="auto"?"normal":effects[_eid].blendmode;
						_skin.inView = true;
						if(components.length == 0)
							this.components.add(_skin);
						if(_dir == -1)
							_dir = eff.dir;
						this.setAction(eff.action,_dir,true);
					}else
						this._model = "";
				}else
					this._model = "";
			}else{
				this._initialized = true;
			}
		}
		
		
		public function moveTo(x:int,y:int):void{
			_tween.move([new Point(x,y)]);
			_tween.setSpeed(8);
			var dir:Number = Vector2Extension.orientation(new Point(this.x,this.y),new Point(x,y));
			this.display.rotation = dir + 90;
		}
		
		public function reset():void{
			if(!_isDisposed && !reseted){
				reseted = true;
				targetPoint = null;
				this.visible = true;
				_liveTime = 0;
				if(_delayShowUint > 0){
					TimeOutManager.getInstance().clearTimer(_delayShowUint);
					_delayShowUint = 0;
				}
				this.x = 0;
				this.y = 0;
				this.rotate = 0;
				if(_tween){
					components.remove(_tween);
					ObjectPoolManager.getInstance().returnItem(Constant.TweenClass,this._tween);
				}
				_effectSkin.reset();
				
				_tween = null;
				this._scene = null;
				this._effectType = 0;
				this._eid = 0;
				_readyToEnd = false;
				this._model = null;
				this.destoryFunc = null;
				this._initialized = false;
				this.enabled = false;
				endFunc = null;
			}
		}
		
		override public function dispose():void{
			if(!_isDisposed){
				super.dispose();
				_liveTime = 0;
				if(_delayShowUint > 0){
					//clearTimeout(_delayShowUint);
					TimeOutManager.getInstance().clearTimer(_delayShowUint);
					_delayShowUint = 0;
				}
				if(_tween)
					ObjectPoolManager.getInstance().returnItem(Constant.TweenClass,this._tween);
				_tween = null;
				this._scene = null;
				targetPoint = null;
				this._effectType = 0;
				this._eid = 0;
				_readyToEnd = false;
				this._model = null;
				endFunc = null;
				hited = null;
			}
		}
		
		public function set rotate(value:Number):void{
			this.display.rotation = value ;
		}
		
		public function playComplete():void
		{
			if(endFunc != null)
				endFunc(this.id);
			if(!_loop){
				if(this.parent){
					this.parent.removeChild(this);
				}
				if(this._scene){
					_scene.removeEff(this);
					_scene = null;
				}else{
					//this.dispose();
					if(!this.reseted)
						DisposeManager.instance.disposeEffectLater(this);
				}
			}
		}
		
		public function get moveNext():Boolean
		{
			return false;
		}
		public function get uniform():Boolean
		{
			return false;
		}
		
		public function endLater():void{
			this._liveTime = getTimer() + Constant.EFFECT_LOAD_WAIT;//一秒钟没下载好，就放弃
			_readyToEnd = true;
		}
		
		public function stopEnd():void{
			if(_readyToEnd){
				_liveTime = 0;
				_readyToEnd = false;
			}
		}
		
		public function endMovie():void
		{
			if(_effectType == EffectType.MOVE){
				onMoveComplete(0);
			}else{
				if(this.parent){
					this.parent.removeChild(this);
				}
				if(this._scene){
					_scene.removeEff(this);
					_scene = null;
				}else{
					//this.dispose();
					if(!this.reseted)
						DisposeManager.instance.disposeEffectLater(this);
				}
			}
		}
		
		public function get endNow():Boolean{
			return false;
		}
		
		public function pause(value:Boolean):void
		{
			if(this._bodySkin){
				this._bodySkin.pause = value;
			}
		}
		
		public function replay():void
		{
			if(this._bodySkin){
				this._bodySkin.replay();
			}
		}
	}
}