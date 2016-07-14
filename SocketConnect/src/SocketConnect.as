package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class SocketConnect extends EventDispatcher
	{
		public static const ON_CONNECTION:String = "Client.连通";
		public static const ON_CONNECTION_LOST:String = "Client.断线";
		public static const ON_EXTENSION_RESPONSE:String ="Client.收到数据";
		public static const ON_ERROR:String = "Client.网络错误";
		public static const ON_ERROR_VERSION:String = "Client.版本错误";
		public static const ON_SYSTEM_BUSY:String = "Client.系统繁忙";
		public static const ON_CONNECTED:String = "Client.连接成功";
		
		private var _socket:Socket;
		
		private var _serverIp:String;
		private var _serverPort:int;
		private var _version:String = null;
		
		private var _dataReceiver:DataReceiver;
		
		private var _versionChecked:Boolean = false;
		private var firstSend:Boolean = true;
		public var isConnecting:Boolean;
		
		public function SocketConnect()
		{
			_socket = new Socket();
			
			_socket.addEventListener(Event.CONNECT, onConnectHandler);
			_socket.addEventListener(Event.CLOSE, onDisconnectHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, inReceiveDataHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			_dataReceiver = new DataReceiver(this);
		}
		
		public function get version():String
		{
			return _version;
		}
		
		public function isConnected():Boolean
		{
			return _socket.connected;
		}
		
		public function setVersion(v:String):void
		{
			_version = v;
		}
		
		public function sendMessage(cmdCode:int, data:Object):void{
			if (!isConnected()) {
				this.dispatchEvent(new Event(ON_CONNECTION_LOST));
				
				return;
			}
			
			var obj:Object = new Object();
			obj.cmd = cmdCode;
			obj.data = data;
			
			var key:int = Math.random()*10000;
			if (key%8==0) {
				key++;
			}
			
			var byte:ByteArray = new ByteArray();
			byte.writeObject(obj);
			
			byte.position=0;
			var ss:String = "";
			for(var i:int=0,len:int=byte.length;i<len;i++){
				ss += byte.readByte().toString(16).toUpperCase() + " ";
			}
			//trace("send message:");
			//trace(ss);
			//			BitUtils.shiftLeft(byte,key);
			if(this.firstSend){
				_socket.writeInt(0);
			}
			this.firstSend = false;
			_socket.writeInt(byte.length);
			_socket.writeInt(key);
			_socket.writeBytes(byte);
			
			_socket.flush();
			
//			MouseCursorManager.setBusy();
			//trace("Client sendMesage cmdCode=" + cmdCode + " param=" + data , " key=" + key);
		}
		
		
		public function disConnect():void
		{
			try {
				_socket.close();
			} catch (e:Error) {
			}
		}
		
		/**
		 * 建立连接，连接后交给connectionHandler处理
		 */
		public function connect(ip:String, port:int):void
		{
			trace("connect", ip, port);
			if (!_version) {
				throw new Error(
					"Client required a version.");
			}
			
			
			if (!isConnected()) {
				isConnecting = true;
				_socket.connect(ip,port);
			}
		}
		
		private function onConnectHandler(evt:Event):void
		{
			trace("onConnectHandler");
			isConnecting = false;
//			dispatchEvent(new Event(SocketEvent.SOCKET_CONNECT_SUCCESS));
		}
		
		/**
		 * 当socket服务器有数据到来的时候将会触发该事件处理器
		 * @param e ProgressEvent
		 */
		private function inReceiveDataHandler(evt:ProgressEvent):void {
			//trace("Client incomingDataHandler socket.bytesAvailable=" + _socket.bytesAvailable);
			_dataReceiver.receiveData(_socket);
		}
		
		internal function processPackage(obj:Object):void {
			dispatchEvent(new Event("Process",obj));
		}
		
		private function onDisconnectHandler(evt:Event):void
		{
			trace("socket服务器已断开");
			isConnecting = false;
			dispatchEvent(new Event(ON_CONNECTION_LOST));
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			isConnecting = false;
			dispatchEvent(new Event(ON_ERROR));
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			dispatchEvent(new Event(ON_ERROR));
		}
	}
}
