package  com.mgame.view.popup
{
	import com.sh.game.util.BitmapScale9Drawer;
	import com.sh.game.util.BitmapScale9Grid;
	import com.sh.game.util.MColor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class Alert extends Sprite
	{
		public function Alert()
		{
			super();
		}
		
		private var normalBtn1:SimpleButton;
		private var normalBtn2:SimpleButton;
		private var _btnLabel1:TextField;
		private var _btnLabel2:TextField;
		private var bg:BitmapScale9Drawer;
		private var closeBtn:SimpleButton;
		private var callBack:Function;
		private var args:Object;
		private var _text:TextField;
		private var _text2:TextField;
		private var _model:Boolean = false;
		private var _autoclose:int = 0;
		private var _intvalid:uint = 0;
		private var _btns:Array;
		
		private var showselect:Boolean = false;
		public static var NEVER:int = 0;
		public static var CLOSE:int = 99;
		
		private var _offY:int = 0;
		private var bp:Shape;
		private static var mWidth:int = 300;
		
		private static var _parent:Stage;
		private static var _alert_bg:Class,_normalBtn:Class,_closeBtn:Class;
		
		
		public static function init(alert_bg:Class,normalBtn:Class,closeBtn:Class,parent:Stage):void{
			_alert_bg = alert_bg;
			_normalBtn = normalBtn;
			_closeBtn = closeBtn;
			_parent = parent;
		}
		
		public static function show(text:String,text2:String,buttons:Array = null,callback:Function=null,args:Object = null,showClose:Boolean = false,model:Boolean = true,leading:int = 5,showselect:Boolean = false,autoclose:int = 0):Alert{
			var alert:Alert = new Alert();
			alert.args = args;
			alert.showselect =showselect;
			alert.initView(text,text2,buttons,callback,showClose,model,leading,autoclose);
			_parent.addChild(alert);
			alert.x = _parent.stageWidth / 2 -alert.width/2 ;
			alert.y = _parent.stageHeight / 2 -alert.height/2 ;
			alert.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			alert.addEventListener(MouseEvent.MOUSE_UP,mouseDown);
			if(model)
				alert.drawModel();
			return alert;
		}
		
		protected static function mouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		
		
		private function initView(text:String,text2:String,buttons:Array,callback:Function,showClose:Boolean,model:Boolean,leading:int = 5,autoclose:int = 0):void{
			this._model = model;
			this._btns = buttons;
			this._autoclose = autoclose;
			bg = new BitmapScale9Drawer(new _alert_bg() as BitmapData,new Rectangle(20,60,20,21));
			var hei:int = 0;
			bp = new Shape();
			/*if(_parent.stage.stageWidth %2 == 0)
			bg.width = 301;
			else
			bg.width = 300;*/
			this.addChild(bp);
			var ly:int = 54;
			//bp.width = 300;
			//this.bg.draw(bp.graphics);
			if(showClose){
				closeBtn = new _closeBtn() as SimpleButton;
				closeBtn.x = 276;
				closeBtn.y = -2;
				closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
				this.addChild(closeBtn);
			}
			_text = new TextField();
			_text.multiline = false;
			_text.defaultTextFormat = new TextFormat("宋体",12,0xffd700,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,leading);
			_text.htmlText = text;
			_text.width = 150;
			_text.height = 30;
			_text.x = (mWidth - _text.width) / 2;
			_text.y = 5;
			_text.selectable = false;
			_text.mouseEnabled = false;
			_text.cacheAsBitmap = true;
			this.addChild(_text);
			
			
			if(text2 != "" && text2 != null){
				_text2 = new TextField();
				_text2.multiline = true;
				_text2.autoSize = TextFieldAutoSize.LEFT;
				_text2.defaultTextFormat = new TextFormat("宋体",12,0xffffff,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,leading);
				_text2.htmlText = text2;
				if(_text2.width >240){
					_text2.wordWrap = true;
					_text2.width = 240;
				}
				_text2.x = (mWidth - _text2.width) / 2;
				_text2.y = ly;
				_text2.selectable = false;
				_text2.mouseEnabled = false;
				_text2.cacheAsBitmap = true;
				this.addChild(_text2);
				ly += _text2.height;
			}
			
			ly += 68;
			
			hei = int((ly )/2 ) *2;
			if(_parent.stage.stageHeight %2 != 0)
				hei = hei + 1;
			bg.setSize(mWidth,hei);
			bg.draw(bp.graphics);
			
			bp.height = hei;
			if(buttons == null){
				buttons = ["确定"];
			}
			if(buttons.length >= 1){
				normalBtn1 = new _normalBtn() as SimpleButton;
				normalBtn1.x = 100;
				normalBtn1.y = bp.height - 49;
				this.addChild(normalBtn1);
				normalBtn1.addEventListener(MouseEvent.CLICK,clickHandler);
				_btnLabel1 = new TextField();
				_btnLabel1.defaultTextFormat = new TextFormat("宋体",12,MColor.New16,null,null,null,null,null,TextFormatAlign.CENTER);
				_btnLabel1.text = buttons[0];
				_btnLabel1.width = normalBtn1.width;
				_btnLabel1.x = normalBtn1.x;
				_btnLabel1.y = normalBtn1.y+ 3;
				_btnLabel1.cacheAsBitmap = true;
				this.addChild(_btnLabel1);
				_btnLabel1.mouseEnabled = false;
				if(_autoclose > 0){
					_intvalid = setInterval(autoCounter,1000);
					if(_btns && _btns.length > 0){
						this._btnLabel1.text = this._btns[0] + "("+ _autoclose +"秒)"
					}
				}
			}
			if(buttons.length == 2){
				normalBtn2 = new _normalBtn() as SimpleButton;
				this.addChild(normalBtn2);
				normalBtn1.x = 20;
				normalBtn1.y = bp.height - 49;
				_btnLabel1.width = normalBtn1.width;
				_btnLabel1.x = normalBtn1.x;
				_btnLabel1.y = normalBtn1.y+ 3 ;
				_btnLabel1.cacheAsBitmap = true;
				normalBtn2.x = 180;
				normalBtn2.y = bp.height - 49;
				normalBtn2.addEventListener(MouseEvent.CLICK,clickHandler2);
				_btnLabel2 = new TextField();
				_btnLabel2.text = buttons[1];
				_btnLabel2.setTextFormat(new TextFormat("宋体",12,MColor.New16,null,null,null,null,null,TextFormatAlign.CENTER));
				_btnLabel2.width = normalBtn2.width;
				_btnLabel2.x = normalBtn2.x;
				_btnLabel2.y = normalBtn2.y + 3;
				this.addChild(_btnLabel2);
				_btnLabel2.cacheAsBitmap = true;
				_btnLabel2.mouseEnabled = false;
			}
			callBack = callback;
			_parent.stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		private function autoCounter():void
		{
			_autoclose--;
			if(_autoclose<=0){
				if(_intvalid > 0)
					clearInterval(_intvalid);
				_intvalid = 0;
				clickHandler(null);
			}else{
				if(_btns && _btns.length > 0){
					this._btnLabel1.text = this._btns[0] + "("+ _autoclose +"秒)"
				}
			}
		}
		
		protected function closeHandler(event:MouseEvent):void
		{
			if(callBack != null){
				callBack(CLOSE,args);
			}
			if(_parent.contains(this))
				_parent.removeChild(this);
			this.destroy();
		}
		
		public function drawModel():void{
			if(this._model){
				this.graphics.clear();
				this.graphics.beginFill(0x000000,0.3);
				this.graphics.drawRect(-this.x,-this.y,_parent.stage.stageWidth,_parent.stage.stageHeight);
				this.graphics.endFill();
			}
		}
		
		protected function resizeHandler(event:Event):void
		{
			if(this._model){
				drawModel();
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if(callBack != null){
				if(showselect){
					callBack(0+NEVER,args);
				}else{
					callBack(0,args);
				}
			}
			if(_parent.contains(this))
				_parent.removeChild(this);
			this.destroy();
		}
		protected function clickHandler2(event:MouseEvent):void
		{
			if(callBack != null){
				if(showselect){
					callBack(1+NEVER,args);
				}else{
					callBack(1,args);
				}
			}
			if(_parent.contains(this))
				_parent.removeChild(this);
			this.destroy();
		}
		
		protected function destroy():void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseDown);
			if(normalBtn1)
				normalBtn1.removeEventListener(MouseEvent.CLICK,clickHandler);
			normalBtn1 = null;
			if(normalBtn2)
				normalBtn2.removeEventListener(MouseEvent.CLICK,clickHandler2);
			_parent.stage.removeEventListener(Event.RESIZE,resizeHandler);
			if(this.closeBtn)
				closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
			normalBtn2 = null;
			_btnLabel1 = null;
			_btnLabel2 = null;
			bg = null;
			closeBtn = null;
			callBack = null;
			args = null;
			_text = null;
			if(_intvalid > 0){
				clearInterval(_intvalid);
				_intvalid = 0;
			}
			this._autoclose = 0;
			this._btns = null;
		}
	}
}