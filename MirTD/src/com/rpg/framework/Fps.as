package com.rpg.framework
{
	import com.rpg.entity.ShadowSkinData;
	import com.rpg.framework.DrawableGameComponent;
	import com.rpg.framework.GameTime;
	import com.rpg.framework.system.thread.ThreadManager;
	import com.rpg.framework.utils.Timer;
	import com.sh.game.global.Config;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/** 计算刷帧频率组件 */
	public class Fps extends DrawableGameComponent
	{
		private var frames : Number     = 0;
		private var fps    :Number   	= 0;
		private var txtFps : TextField;
		private var barFps : Shape;
		private var timer  : Timer;
		private var pos    : Point      = new Point(600, 0);
		private var debug:Boolean = false;
		private var totalFps:Number = 0;
		private var totalCount:int = 0;
		
		public override function initialize():void
		{
			this.timer 				   = new Timer(1000);
			this.display.mouseEnabled  = false;
			this.display.mouseChildren = false;
			debug = Config.debug;
			if(debug){
				barFps   = new Shape();
				barFps.x = pos.x;
				barFps.y = pos.y;
				barFps.graphics.beginFill(0xff0000, 0.5);
				barFps.graphics.lineStyle();
				barFps.graphics.drawRect(0, 0, 1, 18);
				barFps.graphics.endFill();
				this.display.addChild(barFps);
				
				txtFps 		  = new TextField();
				txtFps.x 	  = pos.x;
				txtFps.y      = pos.y;
				txtFps.width  = 300;
				txtFps.height = 20;
				txtFps.alpha  = 1;
				txtFps.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF);
				//txtFps.filters 			 = FontExtension.stroke(0x000000);
				this.display.addChild(txtFps);
			}
			
			super.initialize();
		}
		
		public override function update(gameTime:GameTime):void
		{
			if(this.timer.heartbeat(gameTime)) 
			{
				fps   		= frames;
				frames		= 0;
				if(totalCount < 30 * 60){
					totalCount++;
					this.totalFps += fps;
					//ThreadManager.instance.fps = this.totalFps/totalCount;//设置平均帧率
					//trace("平均帧率：" + this.totalFps/totalCount);
					if(this.totalFps/totalCount < 10){//卡了
						ShadowSkinData.frameMax = 0;
					}else if(this.totalFps/totalCount < 30){
						ShadowSkinData.frameMax = 1;
					}else{
						ShadowSkinData.frameMax = 2;
					}
				}
				if(debug)
					txtFps.text = "FPS：" + fps + " EMS：" + System.totalMemory + "b(" + calculateMemory(System.totalMemory) + ")";
			}
			else
			{
				frames++;
			}
			if(debug)
				barFps.scaleX = gameTime.elapsedGameTime;
		}
		
		private function calculateMemory(memory:uint) : String
		{
			var result:String;
			if (memory < 1024)
			{
				result = String(memory) + "b";
			}
			else if (memory < 10240)
			{
				result = Number(memory / 1024).toFixed(2) + "kb";
			}
			else if (memory < 102400)
			{
				result = Number(memory / 1024).toFixed(1) + "kb";
			}
			else if (memory < 1048576)
			{
				result = Math.round(memory / 1024) + "kb";
			}
			else if (memory < 10485760)
			{
				result = Number(memory / 1048576).toFixed(2) + "mb";
			}
			else if (memory < 104857600)
			{
				result = Number(memory / 1048576).toFixed(1) + "mb";
			}
			else
			{
				result = Math.round(memory / 1048576) + "mb";
			}
			return result;
		}
	}
}