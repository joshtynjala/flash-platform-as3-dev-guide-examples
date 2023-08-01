package com.example.programmingas3.shared.component
{
	import flash.display.*;
	import flash.geom.*;

	public class SampleTextButton extends SimpleButton 
	{
		public var label:String;
		
		public function SampleTextButton(labelText:String = "Submit") 
		{
			label = labelText;
			
			upState = new SampleTextButtonState(label);
			hitTestState = upState;
			overState = upState;
			
			downState = new SampleTextButtonState(label);
			
			var downStateTransform:Transform = downState.transform;
			const downShadeMultiplier:Number = 0.75;
			
			downStateTransform.colorTransform = new ColorTransform(downShadeMultiplier, downShadeMultiplier, downShadeMultiplier);
			downState.transform = downStateTransform;
		}
	}
}
