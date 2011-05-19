package  
{
	import adobe.utils.XMLUI;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Thomas King
	 */
	public class EntityManager extends World 
	{
		private var socket:Socket;
		private var players:Vector.<Player> = new Vector.<Player>();
		
		private var entryField:TextField;
		private var output:TextField;
		private var focus:Boolean;
		
		public function EntityManager(name:String) 
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, connect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, start);
			socket.addEventListener(Event.CLOSE, onClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			//socket.connect("68.233.241.196", 4568);
			socket.connect("99.3.105.209", 4568);
			socket.writeUTF(name);
			socket.flush();
			
			entryField = new TextField;
			entryField.x = 10;
			entryField.y = FP.height - 30;
			entryField.height = 18;
			entryField.width = 300;
			entryField.background = true;
			entryField.multiline = false;
			entryField.type = TextFieldType.INPUT;
			FP.stage.addChild(entryField);
			entryField.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			entryField.addEventListener(FocusEvent.FOCUS_IN, fIn);
			entryField.addEventListener(FocusEvent.FOCUS_OUT, fOut);
			
			output = new TextField;
			output.x = 10;
			output.y = FP.height - 230;
			output.height = 200;
			output.width = 300;
			output.background = true;
			output.backgroundColor = 0x88AAAAAA;
			output.multiline = true;
			output.wordWrap = true;
			output.type = TextFieldType.DYNAMIC;
			output.appendText("Connecting");
			FP.stage.addChild(output);
		}
		
		public function fIn(e:FocusEvent):void
		{
			focus = true;
		}
		
		public function fOut(e:FocusEvent):void
		{
			focus = false;
		}
		
		public function keyPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13 && entryField.text.length > 0) {
				socket.writeUTF("chat," + entryField.text);
				socket.flush();
				entryField.text = "";
			}
		}
		
		public function ioError(e:IOErrorEvent):void
		{
			trace("Error!");
			output.appendText("Error" + e.toString() + "\n");
		}
		
		public function connect(e:Event):void
		{
			trace("Error!");
			output.appendText("Connected" + e.toString() + "\n");
		}
		
		public function start(e:ProgressEvent):void 
		{
			if (socket.bytesAvailable <= 0) return;
			
			if (!socket.readBoolean()) {
				FP.world = new MenuWorld("Name taken");
				socket.close();
				return;
			}
			trace("new listener");
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, start);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, listener);
		}
		
		public function listener(e:ProgressEvent):void 
		{
			if (socket.bytesAvailable <= 0) return;
			
			var str:String = socket.readUTF();
			if (str.indexOf("play") == 0) {
				player(str);
			}
			if (str.indexOf("chat") == 0) {
				output.appendText(str.substr(5) + "\n");
				output.scrollV = output.maxScrollV;
			}
			if (str.indexOf("move") == 0) {
				
			}
		}
		
		public function onClose(e:Event):void 
		{
			socket.writeUTF("close");
			socket.flush();
			socket.close();
		}
		
		private var ONE_OVER_ROOT2:Number = 0.707106;
		private var lastX:Number = 0;
		private var lastY:Number = 0;
		override public function update():void 
		{
			super.update();
			var x:Number = 0;
			var y:Number = 0;
			if (!focus) {
				if (Input.check(Key.A)) {
					x -= 50;
				}
				else if (Input.check(Key.D)) {
					x += 50;
				}
				if (Input.check(Key.S)) {
					y += 50;
				}
				if (Input.check(Key.W)) {
					y -= 50;
				}
				if (y != 0 && x != 0) {
					y = ONE_OVER_ROOT2 * y;
					x = ONE_OVER_ROOT2 * x;
				}
				if (y != lastY || x != lastX) {
					socket.writeUTF("move," + x + "," + y);
					socket.flush();
					lastX = x;
					lastY = y;
				}
			}
		}
		
		private function player(str:String):void
		{
			var arr:Array = str.split(",");
			for each (var p:Player in players) {
				if (p.id == parseInt(arr[1])) {
					p.x = parseFloat(arr[2]);
					p.y = parseFloat(arr[3]);
					p.health = parseFloat(arr[4]);
					return;
				}
			}
			p = new Player(arr[5], parseFloat(arr[2]), parseFloat(arr[3]), parseFloat(arr[1]));
			p.health = parseFloat(arr[4]);
			players.push(p);
			add(p);
		}
		
		override public function end():void 
		{
			super.end();
			socket.close();
		}
	}
}