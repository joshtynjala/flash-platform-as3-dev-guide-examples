package com.example.display {
	import flash.display.TextField;
	import flash.text.TextFormat;
	import flash.display.TextFieldAutoSize;
	
	public class ChapterFourContent extends SampleComponent {
		private var txt:TextField;
		
		public function ChapterFourContent() {
		}

		protected override function init():Void {
			txt = new TextField();
			txt.defaultTextFormat = getFormat();
			txt.text = "Chapter Four Content";
			txt.x = gutter;
			txt.y = gutter;
			addChild(txt);
		}
		
		public override function draw():Void {
			super.draw();
			txt.width = getWidth() - (2 * gutter);
		}
		
		private function getFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 18;
			format.bold = true;
			return format;
		}
	}
}