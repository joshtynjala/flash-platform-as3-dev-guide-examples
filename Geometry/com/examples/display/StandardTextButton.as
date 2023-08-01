package com.examples.display {
	import flash.display.*;
	import flash.geom.*;

	public class StandardTextButton extends SimpleButton {
		public var label:String;
		public function StandardTextButton(txtString:String="label") {
			label = txtString;
			upState = new StandardTextButtonState(label);
			hitTestState = upState;
			overState = upState;
			downState = new StandardTextButtonState(label);
			var downStateTransform:Transform = downState.transform;
			const downShadeMultiplier:Number = 0.75;
			downStateTransform.colorTransform = new ColorTransform(downShadeMultiplier, downShadeMultiplier, downShadeMultiplier);
			downState.transform = downStateTransform;
			
		}

	}
}

import flash.display.*;
import flash.text.*;
import flash.util.trace;

class StandardTextButtonState extends Sprite {
	public var txt:TextField;
	public function StandardTextButtonState(txtString:String) {
		txt = new TextField();
		txt.defaultTextFormat = new TextFormat("Verdana");
		txt.defaultTextFormat.size = 12;
		txt.defaultTextFormat.align = TextFormatAlign.CENTER
		txt.text = txtString;
		addChild(txt);
		txt.x += 4;
		txt.width = txt.textWidth + 12;
		txt.height = txt.textHeight + 6;
		
		graphics.beginFill(0xEEEEEE);
		graphics.lineStyle(1, 0x000000);
		graphics.drawRoundRect(0, 0, width, height, 8, 8);
	}
}
