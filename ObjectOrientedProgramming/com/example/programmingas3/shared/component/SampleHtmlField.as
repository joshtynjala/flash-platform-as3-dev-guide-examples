package com.example.programmingas3.shared.component
{
	import com.example.display.SampleTextField;
	import flash.text.TextFormat;
	import flash.display.TextFieldType;

	/**
	 * An editable text field component with a bacground and border.
	 */	
	public class SampleHtmlField extends SampleTextField 
	{
		public function SampleHtmlField(w:uint, h:uint, textFormat:TextFormat = null) 
		{
			// creates a selectable field by default
			super(w, h, textFormat, true);
			
			this.field.type = flash.display.TextFieldType.INPUT;
			this.field.html = true;
			this.field.multiline = true;
			
			this.init();
		}
		
		public override function init():void 
		{
			super.init();
			
			this.draw();
		}
		
		/**
		 * The contents of the htmlText property of the text field. 
		 * Sets it to a blank string if the value comes in as null or undefined.
		 */
		public function get htmlText():String
		{
			return field.htmlText;
		}
		public function set htmlText(str:String):void 
		{
			if (str == null || str == undefined)
			{
				str = "";
			}
			field.htmlText = str;
		}
	}
}