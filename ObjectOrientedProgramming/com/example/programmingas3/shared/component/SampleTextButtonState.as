package com.example.programmingas3.shared.component 
{
	import flash.display.*;
	import flash.text.*;
	import flash.util.trace;
	import flash.filters.DropShadowFilter
	
	class SampleTextButtonState extends Sprite 
	{
		public var field:TextField;
		
		public function SampleTextButtonState(txtString:String) 
		{
			field = new TextField();
			
			field.defaultTextFormat = new TextFormat("Verdana");
			field.defaultTextFormat.size = 12;
			field.defaultTextFormat.align = TextFormatAlign.CENTER
			field.text = txtString;
			addChild(field);
			
			field.x += 4;
			field.width = field.textWidth + 12;
			field.height = field.textHeight + 6;
			
			var background:Shape = new Shape;
			
			background.graphics.beginFill(0xEEEEEE);
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.drawRoundRect(0, 0, width, height, 8, 8);
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.blurX = 0;
			shadow.blurY = 0;
			shadow.distance = 2;
			background.filters = [shadow];
			
			addChildAt(background, 0);
		}
	}
}