package com.rpg.entity
{
	import com.rpg.enum.ActionType;
	
	import flash.utils.Dictionary;
	
	
	/** 
	 * 人物抽象元件（ 和服务器通讯坐标点为人物脚下的坐标点－源坐标减人物偏移值）
	 * 功能：
	 * 1、人物皮肤加载
	 * 2、人物动画
	 * 3、人物名称
	 */
	public class Animal extends ElementBase
	{
		/** 战斗结束时候，验证战斗结束时血条隐藏的时间 */
		public var fightOverTime : int;
		/** 是否显示血条 */
		//public var showBlood : Boolean = false;
		/** 人物当前动做状态 */
		public var action     : int = ActionType.STAND;
		/** 玩家当前行为状态 */
		public var activity   : int    = ActionType.STAND;
		
		protected var _animalSkin      : AnimalSkin; 		// 人物皮肤组件
		protected var _elements		   : Dictionary; 		// 子元件（一般用于动物自身的技能特效）
		protected var _buffs		   : Dictionary;		// 玩家自身的BUFF集合
		protected var _target 		   : ElementBase;
		

		/** 目标对象 */
		public function get target() : ElementBase
		{
			if (_isDisposed == false)
			{
				return _target;
			}
			return null;
		}
		public function set target(value : ElementBase) : void
		{
			_target = value;
		}

		/** 皮肤是否已可见 */	
		public function get skinVisible() : Boolean
		{
			return _skin.skinVisible;
		}

		/** 人物自身 BUFF 集合 */	
		public function get buffs() : Dictionary
		{
			return _buffs;
		}

		/** 是否已死亡（true为死亡，false为没死亡) */
		public function get dead() : Boolean
		{
			return false;
		}

		public function Animal()
		{
			
			this.display.mouseChildren = true;
			this.layer 				   = LAYER_ROLE;
			
			_buffs 	  = new Dictionary();
			_elements = new Dictionary();
			
			// 创建动物提示对象
		/*	_prompt = new AnimalPrompt(this);
			_prompt.addText(ElementValueType.NAME);
			this.createPromptText();*/
			
			_animalSkin = _skin as AnimalSkin;
		}
		
		/** 创建动物提示对象 */		
		protected function createPromptText() : void {}
		
		public function showTextColor() : void
		{
			
		}
		
		public override function initialize() : void
		{
			this.showTextColor();
			
			// 动物创建时就死亡（用于控制行）
			if (_initialized == false)
			{
				// 设置提示文字显示
				
			}
			
			//super.initialize();
		}


		/**
		 * 获取动物身上一个子元件（一般用于动物自身的技能特效）
		 * @param id	元件编号
		 * @return 元件
		 * 
		 */	
		public function getElement(id : int) : ElementBase
		{
			if (_elements && _elements[id])
			{
				return _elements[id];
			}
			return null;
		}
		
		/*public override function addChild(item : GameSprite) : void
		{
			if (item is ElementBase)
			{
				var element : ElementBase = item as ElementBase;
				_elements[element.id] = item;
			}
			super.addChild(item);
		}
		
		public override function removeChild(item : GameSprite) : void
		{
			if (item is ElementBase)
			{
				var element : ElementBase = item as ElementBase;
				delete _elements[element.id];
			}
			super.removeChild(item);
		}*/
		
		/**
		 * 修改人物外貌行为
		 * @param action 动作类型
		 * @param force  是否强制转换动做
		 *
		 */
		public function setAction(action :int, dir:int = -1,compulsory : Boolean = false) : void
		{
			this.action = action;
			if(dir != -1)
				this.direction = dir;
			if (_animalSkin)
			{
				_animalSkin.setAction(compulsory);
			}
		}

		public function set dir(value:int):void{
			if(this.direction != value){
				this.direction = value;
				this.setAction(action,direction,false);
			}
		}
		
		/**
		 * 设置连续动做 
		 * @param actions 动做对列
		 * 
		 */		
		public function setContinuousAction(actionQueue : Array) : void
		{
			_animalSkin.setContinuousAction(actionQueue);
		}

		
		public override function dispose():void	
		{
			_values			 = null;
			_animalSkin      = null;	// 跟随 _components.dispose()
			_target			 = null;
			if(_elements){
				for each (var e:ElementBase in _elements) 
				{
					e.dispose();
				}
				_elements = null;
			}
			if(this._animalSkin)
				this._animalSkin = null;
			super.dispose();
		}
		
	}
}