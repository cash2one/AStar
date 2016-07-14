/**
 * Morn UI Version 3.0 http://www.mornui.com/
 * Feedback yungvip@163.com weixin:yungzhu
 */
package morn.core.components {
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import morn.core.events.UIEvent;
	
	/**当用户输入文本时调度*/
	[Event(name="textInput",type="flash.events.TextEvent")]
	
	/**输入框*/
	public class TextInput extends Label {
		
		public function TextInput(text:String = "", skin:String = null) {
			super(text, skin);
		}
		
		override protected function initialize():void {
			super.initialize();
			mouseChildren = true;
			width = 128;
			height = 22;
			selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.autoSize = "none";
			_textField.addEventListener(Event.CHANGE, onTextFieldChange);
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextFieldTextInput);
		}
		
		private function onTextFieldTextInput(e:TextEvent):void {
			dispatchEvent(e);
		}
		
		protected function onTextFieldChange(e:Event):void {
			text = _isHtml ? _textField.htmlText : _textField.text;
			e.stopPropagation();
		}
		
		/**指示用户可以输入到控件的字符集*/
		public function get restrict():String {
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void {
			_textField.restrict = value;
		}
		
		/**是否可编辑*/
		public function get editable():Boolean {
			return _textField.type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void {
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}
		
		/**最多可包含的字符数*/
		public function get maxChars():int {
			return _textField.maxChars;
		}
		
		public function set maxChars(value:int):void {
			_textField.maxChars = value;
		}
		
		/////////////////////////////////
		public var enterEnabled         :Boolean = false;
		public var keyboardEventEnabled :Boolean = false;
		public var isShowFocusInFilter  :Boolean = false;
		//private var _focusInColor         :uint = 0x005aa8;
		private var _focusSkin:String = "png.comp.textinput_focus";
		public function set focusInSkin(value:String):void{
			_focusSkin = value;
		}
		//private var glowFilter:GlowFilter = new GlowFilter(_focusInColor);
		
		public function addFocusEvents():void
		{
			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
		}
		public function removeFocusEvents():void
		{
			this.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if(keyboardEventEnabled)
			{
				this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			}		
			if(isShowFocusInFilter)
			{
				//this.filters = [glowFilter];
//				stage.focus = _textField;
				super.skin = _focusSkin;
				var index:int = _textField.text.length;
				_textField.setSelection(index,index);
			}
		}
		
		private function onKeyFocusChange(e:FocusEvent):void
		{
		}
		
		
		private function onFocusOut(e:FocusEvent):void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			if(isShowFocusInFilter)
			{
				super.skin = _skin;
				//this.filters = null;
			}
		}
		
		private function onKeyboardDown(e:KeyboardEvent):void
		{
			//trace("onKeyboardDown", e.keyCode)
			switch (e.keyCode) 
			{
				case 13://回车
					if(enterEnabled)
					{
						this.dispatchEvent(new UIEvent(UIEvent.FOCUS_NEED_CHANGE, {nowTabIndex:this.tabIndex}));
						//e.stopImmediatePropagation();
						e.stopPropagation();
					}
					break;
				default:
			}
		}
		
		override public function set tabIndex(index:int):void{
			_textField.tabIndex = index;
		}
	}
}