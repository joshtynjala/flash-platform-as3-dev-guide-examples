package com.example.display {
	import com.example.display.SampleFoundation;
	import com.example.display.SampleComponent;
	import flash.display.TextField;
	import flash.text.TextFormat;

	public class SampleHeader extends SampleComponent {
		private const TITLE_HEIGHT:Number = 30;
		private const DESCRIPTION_HEIGHT:Number = 50;
		private var title:TextField;
		private var description:TextField;

		public function SampleHeader() {
		}
		
		protected override function init():void {
			title = new TextField();
			title.defaultTextFormat = getTitleFormat();
			title.selectable = false;
			title.height = TITLE_HEIGHT;
			addChild(title);


			description = new TextField();
			description.defaultTextFormat = getDescriptionFormat();
			description.wordWrap = true;
			description.height = DESCRIPTION_HEIGHT;
			description.selectable = false;
			addChild(description);
		}
		
		private function getDescriptionFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 11;
			return format;
		}
		
		private function getTitleFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 18;
			format.bold = true;
			return format;
		}
		
		public override function draw():void {
			super.draw();
			var w:Number = getWidth();
			var h:Number = getHeight();

			title.x = gutter;
			title.y = gutter;

			description.x = gutter;
			description.y = title.y + title.height;
		}
		
		public override function setWidth(width:Number):void {
			super.setWidth(width);
			var availableWidth:Number = getWidth() - (gutter * 2);
			title.width = availableWidth;
			description.width = availableWidth;
		}
		
		public override function getHeight():Number {
			return TITLE_HEIGHT + DESCRIPTION_HEIGHT + (gutter * 2);
		}
		
		public function setTitle(str:String):void {
			title.text = str;
		}
		
		public function getTitle():String {
			return title.text;
		}
		
		public function setDescription(str:String):void {
			description.text = str;
		}
		
		public function getDescription():String {
			return description.text;
		}
	}
}
