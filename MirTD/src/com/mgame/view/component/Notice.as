package com.mgame.view.component
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.sh.game.util.Html;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	
	public class Notice extends Sprite
	{
		/**最大的显示数量*/		
		private var maxCount:int = 5;
		/**信息栈堆*/		
		private var msgStack:Vector.<Object> = new Vector.<Object>();
		/**当前显示数量*/		
		private var curShowCount:int = 0;
		/**当前显示label{lab:文本,index:显示的索引}*/
		private var labelDic:Dictionary = new Dictionary();
		/**延迟显示计时器*/
		private var delayTimer:int = 0;
		/**判断是否在延迟显示时间段内*/		
		private var delayShowing:Boolean = false;
		/**移动播放的速度*/		
		private var animateTime:Number = 0.5;
		/**关闭计时器*/		
		private var closeTimer:int = 0;
		
		public function Notice()
		{
			
		}
		/**
		 * 添加一个公告
		 * @param data 公告服务端来的信息
		 */		
		public function add(text:String,color:uint):void
		{
			if(color<=0){color =0xc72514}
			msgStack.push({txt:text,color:color});
			checkShow();
		}
		/**
		 * 检测显示信息
		 */		
		public function checkShow():void
		{
			//判断是否在延迟显示时间段内(延迟显示尽量的避免动画播放冲突)
			if(delayShowing)
			{
				return
			}
			//判断是否显示满了
			if(curShowCount>=maxCount)
			{
				return;
			}
			//判断是否还有信息
			if(msgStack.length<=0)
			{
				return;
			}
			//进行延迟显示倒计时
			delayShowing = true;
			delayTimer = setTimeout(doDelay,animateTime*1000);
			//数量加1
			curShowCount++;
			//启动关闭计时器
			if(closeTimer == 0)
			{
				closeTimer = setInterval(checkClose,1000);
			}
			//获取到最底下的一条
			var showMsg:Object = msgStack.shift();
			//开始显示
			doShow(showMsg);
		}
		/**
		 * 检测关闭显示设置
		 */		
		private function checkClose():void
		{
			for (var key:Object in labelDic) 
			{
				var labelMsg:Object = labelDic[key];
				var closeTime:int = int(labelMsg.closeTime)+1;
				//判断是否达到了关闭显示的时候了(根据条数不同显示的持续时间不同)
				if(closeTime>=8-maxCount)
				{
					TweenLite.to(key,0.5,{alpha:0,onComplete:doKillShow,onCompleteParams:[key]});
					continue;
				}
				labelMsg.closeTime = closeTime;
			}
		}
		/**
		 * 杀掉所有的乱七八糟的东西
		 */		
		public function doKillShow(lab:Object):void
		{
			TweenLite.killTweensOf(lab);
			this.removeChild(lab as DisplayObject);
			delete labelDic[lab];
			lab = null;
			curShowCount--;
			checkShow();
		}
		/**
		 * 延迟显示计时器
		 */		
		private function doDelay():void
		{
			delayShowing = false;
			if(delayTimer>0)
			{
				clearTimeout(delayTimer);
				delayTimer = 0;
			}
			
			checkShow();
		}
		/**
		 * 开始显示
		 */		
		private function doShow(msg:Object):void
		{
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("res.warning") as Class;
			var lab:Object = new cls();
			//lab.txt_msg.color = msg.color;
			(lab.txt_msg as TextField).textColor = msg.color;
			lab.txt_msg.text = msg.txt;
			//			var lab:Label = new Label();
			//			lab.color = msg.color;
			//			lab.text = msg.txt;
			var showX:int =  -lab.width/2;
			lab.x = showX
			this.addChild(lab as DisplayObject);
			//将前面的每个上移一位
			for(var key:Object in labelDic) 
			{
				var labelMsg:Object = labelDic[key];
				var showIndex:int = int(labelMsg.index)+1;
				TweenLite.to(key,animateTime,{y:- showIndex * 28});
				labelMsg.index = showIndex;
			}
			labelDic[lab] = {index:0,closeTime:0}
			//进行动画添加
			var timeline:TimelineLite = new TimelineLite();
			timeline.append(new TweenLite(lab,0.1,{scaleX:1.5,scaleY:1.5,x:showX*1.5,y:-20}));
			timeline.append(new TweenLite(lab,0.1,{scaleX:1,scaleY:1,y:0,x:showX}));
		}		
	}
}