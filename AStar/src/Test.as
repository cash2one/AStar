package
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class Test extends Sprite
	{
		public function Test()
		{
			var moveReg:RegExp = new RegExp("[01]","m");
//			trace( moveReg.test('2346875632'));
			moveReg.lastIndex
			var obj:Object = moveReg.exec('200146875632');
			moveReg.test('200146875632');
			moveReg.multiline
			moveReg.global
			moveReg.ignoreCase
			moveReg.lastIndex
			trace(obj);	
//			trace(obj[0])
//			trace(obj.index)
//				trace(obj.input)
//					trace(obj.length)	
//			var boo:Boolean = checkPhone('1346875632');
//			trace(boo);
		}
		
		
		
		
		private function checkPhone(tel:String):Boolean
		{
			var moveReg:RegExp = /^(13[0-9]|15[0-9]|18[0-9]|147|145|170|171|177|176|178)\d{8}$/;
			var phoneReg:RegExp = /^([0-9]{3,4}-)?[0-9]{7,8}$/;
			return moveReg.test(tel) || phoneReg.test(tel);
		}
		
	}
}



import flash.display.Sprite;  
import flash.events.MouseEvent;  

class CustomSprite extends Sprite {  
	private var size:uint = 50;  
	private var bgColor:uint = 0x00CCFF;  
	
	public function CustomSprite() {  
		buttonMode = true;  
		addEventListener(MouseEvent.CLICK, clickHandler);  
		draw(size, size);  
	}  
	
	private function draw(w:uint, h:uint):void {  
		graphics.beginFill(bgColor);  
		graphics.drawRect(0, 0, w, h);  
		graphics.endFill();  
	}  
	
	private function clickHandler(event:MouseEvent):void {  
		var target:Sprite = Sprite(event.target);  
		//当TabChildren=false的时候，只有通过下面的语句才能触发【FocusEvent.FOCUS_IN】事件。  
		//否则不能触发。  
//		stage.focus = target;  
	}  
}  



