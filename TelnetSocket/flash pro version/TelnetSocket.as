package 
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	import com.example.programmingas3.socket.Telnet;
	
	public class TelnetSocket extends Sprite 
	{
        private var telnetClient:Telnet;

		public function TelnetSocket() {
			setupUI();
		}
		private function connect(e:MouseEvent):void {
			telnetClient = new Telnet(serverName.text, int(portNumber.text), output);
		}
		private function sendCommand(e:MouseEvent):void {
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(command.text + "\n", "UTF-8");
			telnetClient.writeBytesToSocket(ba);
			command.text = "";
		}
		private function setupUI():void {
			loginBtn.addEventListener(MouseEvent.CLICK,connect)	
			sendBtn.addEventListener(MouseEvent.CLICK,sendCommand);
		}		
	}
}