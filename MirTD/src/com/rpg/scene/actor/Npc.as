package com.rpg.scene.actor
{
	import com.core.utils.StringUtil;
	import com.mgame.battle.Zone;
	import com.rpg.entity.GameSprite;
	import com.rpg.enum.ActionType;
	import com.rpg.enum.Constant;
	import com.rpg.enum.ElementSkinType;
	import com.rpg.framework.system.memory.CacheManager;
	import com.rpg.scene.actor.skin.npc.NpcSkin;
	import com.sh.game.global.Config;
	import com.sh.game.util.MColor;
	
	import flash.utils.setInterval;
	
	
	
	public class Npc extends RPGAnimal
	{
		private var _model:String;
		public var func:String;							//npc功能
		protected var funcIcon:Boolean = false;//npc功能icon
		protected var funcName:String;				//npc功能名称 
		private var npcSkin:NpcSkin;
		private var cfgnpcs:Object = ConfigDictionary.data.sysnpc;
		private var cfgTaskNum:Object = ConfigDictionary.data.tasknum;
		public var taskid:int;//npc任务id
		
		public function Npc(baseObj:Object,zone:Zone,initView:Boolean = false)
		{
			super(baseObj,zone,initView);
			this._info.iconY = 132;
			_cfg = ConfigDictionary.data.npc[baseObj.npcid];
			func = _cfg.func;
			funcName = _cfg.funcname;
			if(_cfg.showicon != 0){
				this.funcIcon = true;
			}else
				this.funcIcon = false;
			this.offsetY = -10;
			if(_cfg && this._cfg.hasOwnProperty("say")){
				var word:String = _cfg.say;
				_words = String(_cfg.say).split("#");
				if(_words.length > 0){
					addHeartBeats();
				}
			}
			_model = _cfg.model;
			this._skin = this._animalSkin = this.rpgSkin = npcSkin =  new NpcSkin(this,_model);
			this.enabled = true;
			if(this.func != null && this.func != "null" && this.func != ""){//npc功能icon
				if(this.funcIcon	)
					_info.setIcon(_cfg.showicon);
				if(funcName && funcName != "")
					setOtherTxt(funcName,MColor.New7,16);
			}
		}
		
		
		private function addHeartBeats():void{
			_heartId = setInterval(heartBeats,10000);
		}
		
		private function heartBeats():void
		{
			if(this.inView){
				if(Math.random() > 0.95){
					if(this._words && this._words.length > 0){
						if(StringUtil.trim(_words[0]) == "")
							return;
						this.speak(_words[int(_words.length * Math.random())]);
					}
				}
			}
		}
		
		override public function set focus(value:Boolean):void
		{
			_focus = value;
			if(!this.isMe() && int(this._cfg.quanquan) == 0){
				if(_focus)
					this.rpgSkin.setFocus(2);
				else
					this.rpgSkin.setFocus(0);
			}
		}
		
		/*override public function get nameY():int
		{
			return 120;
		}*/
		
		protected override function createComponent() : void
		{
			this.enabled = true;
		}
		
		override public function initModels():void{
			this.npcSkin.setSkin(ElementSkinType.NPC,_model,Config.npcPath);
			//this.npcSkin.setSkin(ElementSkinType.SHADOW,_model,Config.npcPath);
			//this.npcSkin.addCommonShadow();
			if( CacheManager.instance.needShadow)
				this.npcSkin.setSkin(ElementSkinType.SHADOW,_model,null);
			else
				this.npcSkin.addCommonShadow();
			this.setAction(ActionType.STAND,-1,true);
		}
		
		
		override public function dispose():void{
			this.taskid = 0;
			_model = null;
			func = null;
			funcIcon = false;
			funcName = null;
			super.dispose();
			npcSkin = null;
			cfgnpcs = null;
		}
		override public function addRoleToView(layer:GameSprite, alphaTween:Boolean=false):void{
			super.addRoleToView(layer,alphaTween);
		}
		
	}
}