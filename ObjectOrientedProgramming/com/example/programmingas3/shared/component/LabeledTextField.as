// ActionScript file
package com.example.programmingas3.shared.component
{
	import flash.display.*;
	import flash.text.TextFormat;
	import flash.util.trace;
	import com.example.programmingas3.shared.component.SampleContainer
	import flash.events.FocusEvent;
	
	public class LabeledTextField extends SampleContainer  
	{
		public var labelField:SampleLabel;
		public var inputField:SampleTextInput; 
		public var warningField:SampleLabel;
		
		public function LabeledTextField(label:String, 
										 inputText:String = "", 
										 inputWidth:uint = 200, 
										 inputHeight:uint = 20, 
										 stackVertically:Boolean = false) 
		{
			labelField = new SampleLabel(120, inputHeight, getLabelFormat());
			labelField.text = label;
	
			inputField = new SampleTextInput(inputWidth, inputHeight, getInputFormat());
			inputField.text = inputText;
			
			// traps and forwards focus events
			inputField.addEventListener(FocusEvent.FOCUS_IN, onFocusEvent);
			inputField.addEventListener(FocusEvent.FOCUS_OUT, onFocusEvent);		

			warningField = new SampleLabel(120, 20, getWarningFormat());
			warningField.text = "< Invalid entry";
			warningField.visible = false;
			warningField.y = 0;
			
			if (stackVertically)
			{
				inputField.x = 0;
				inputField.y = labelField.h;
				warningField.x = labelField.w;
			}
			else
			{
				inputField.x = labelField.w;
				inputField.y = 0;
				warningField.x = inputField.x + inputField.w;			
			}
			
			addComponent(labelField);
			addComponent(inputField);
			addComponent(warningField);
		}
			
		public function showWarning(showOrHide:Boolean = true)
		{
			this.warningField.visible = showOrHide;
		}
		
		public override function draw():void
		{
			labelField.draw();
			inputField.draw();
			if (warningField.visible)
			{
				warningField.draw();
			}
		}
		private function getLabelFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = true;
			format.align = "right";
			return format;
		}
		
		private function getInputFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = false;
			return format;
		}
		
		private function getWarningFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = false;
			format.color = 0xFF0000;
			return format;
		}
		
		private function onFocusEvent(evt:FocusEvent):void 
		{
			this.dispatchEvent(evt);
		}
	}
}