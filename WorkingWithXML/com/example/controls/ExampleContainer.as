package com.example.controls {
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.display.TextField;
	import flash.util.trace;
	import flash.display.DisplayObject;

	public class ExampleContainer extends Sprite {
		
		public var title:TextField;
		public var contents:Sprite;
		private var txtFormat:TextFormat;
		private const contentMatteColor:uint = 0xDDDDDD;
		
		public function ExampleContainer() {
			title = new TextField();
			addChild(title);
			txtFormat = new TextFormat("Verdana", 12);	
			txtFormat.leftMargin = 4;	
			formatTitle();
			contents = new Sprite();
			drawContentsRect();
			//addChild(contents);
		}
		
		private function formatTitle():void {
			title.border = false;
			title.x = 5;
			title.y = 5;
			title.width = stage.stageWidth - 10 ;
			title.height = 30 ;
			var titleFormat:TextFormat = new TextFormat("Verdana", 14);
			titleFormat.leftMargin = 4;	
			titleFormat.bold = true;
			titleFormat.italic = true;
			title.defaultTextFormat = titleFormat;
		}		
		private function drawContentsRect() {
			var rectWidth:Number = stage.stageWidth - 10 ;
			var rectHeight:Number = stage.stageHeight - 40 ;
			contents.graphics.beginFill(contentMatteColor);
			contents.graphics.lineStyle(1, 0x000000);
			contents.x = 5;
			contents.y = 30;
			contents.graphics.drawRect(0, 0, rectWidth, rectHeight);
		}					
		public function arrangeTextFields() {
			for (var i:uint = 1; i < numChildren; i++) {
				var displayObject:DisplayObject = getChildAt(i);
				var prevDisplayObject:DisplayObject = getChildAt(i - 1);
				if ((displayObject is Object)) { // change to Component later, when implimented
					displayObject.y = prevDisplayObject.y + prevDisplayObject.height + 10;
				} else {
					y = getChildAt(numChildren - 1).y ;
					x = getChildAt(numChildren - 1).x + getChildAt(numChildren - 1).width + 4;
				}
			}
		}
	}
}