package com.example.content {
	import flash.display.TextField;
	import com.example.display.SampleComponent;
	import flash.text.TextFormat;
	import flash.display.TextFieldAutoSize;
	
	public class SampleLabel extends SampleComponent {
		private var txt:TextField;
		
		public function SampleLabel() {
		}
		
		protected override function init():Void {
			txt = new TextField();
			txt.defaultTextFormat = getFormat();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = gutter;
			txt.y = gutter;
			addChild(txt);
		}
		
		public function setLabel(label:String):Void {
			txt.text = label;
		}
		
		private function getFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 11;
			return format;
		}
	}
}