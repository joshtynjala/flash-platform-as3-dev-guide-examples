package com.example.display {
	import flash.display.*;
	import MainTextFormat;
	import flash.text.TextFormat;
	import flash.util.trace;

	public class LabelTextField extends Sprite {
		public var mainFormat:MainTextFormat;
		public var labelField:TextField
		public var inputTextField:TextField 
		public function LabelTextField(label:String, inputText:String = "", inputHeight:Number = 20) {
			mainFormat = new MainTextFormat();
			labelField = new TextField();
			labelField.defaultTextFormat = new TextFormat("Verdana", 8, 0x000000, true);
			labelField.text = label;
			labelField.width = labelField.textWidth + 4;
			labelField.height = labelField.textHeight + 4;
	
			inputTextField = new TextField();
			inputTextField.background = true;
			inputTextField.backgroundColor = 0xFFFFFF;
			inputTextField.text = inputText;
			inputTextField.defaultTextFormat = mainFormat;
			inputTextField.border = true;
			inputTextField.type = TextFieldType.INPUT;
			inputTextField.x = 100;
			inputTextField.y = labelField.y;
			inputTextField.width = 300;
			inputTextField.height = inputHeight;
			
			addChild(labelField);
			addChild(inputTextField);
		}
	}
	
}