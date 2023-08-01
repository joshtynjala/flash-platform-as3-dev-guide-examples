package com.example.programmingas3.shared.component
{
	import com.example.display.SampleTextField;
	import flash.text.TextFormat;
	import flash.display.TextFieldType;

	/**
	 * An editable text field component with a bacground and border.
	 */	
	public class SampleTextInput extends SampleTextField 
	{
		public function SampleTextInput(w:uint, h:uint, textFormat:TextFormat = null) 
		{
			// creates a selectable field
			super(w, h, textFormat, true);
			
			this.field.type = flash.display.TextFieldType.INPUT;
			
			this.init();
		}
		
		public override function init():void 
		{
			super.init();
			
			this.draw();
		}
	}
}