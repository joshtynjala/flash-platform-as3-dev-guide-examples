// Copyright (c) 2005 Adobe, Inc.
package {
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEventType;
	import flash.text.TextFormat;
	import flash.events.*;
	import com.example.display.StandardTextButton;
	import flash.util.trace;
	
	public class RegExpExample extends Sprite {
		public var nameField:LabelTextField;
		public var emailField:LabelTextField;
		public var phoneNumberField:LabelTextField;
		public var donationField:LabelTextField;
		public var commentsField:LabelTextField;
		
		public var commentsFieldSrc:String = "Check <i>this</i> for HTML <b>validity</b>.";		
		public var controlButton:StandardTextButton;	
		
		public var mainFormat:TextFormat;
		public function RegExpExample() {
			init();
		}
		private function init():void {
			mainFormat = new MainFormat();
			
			var instructions:TextField = new TextField();
			instructions.text = "Complete each of the following fields, and then click the Submit button.";
			instructions.wordWrap = true;
			instructions.width = 400;
			instructions.height = instructions.textHeight + 15;
			addChild(instructions);
		
			nameField = new LabelTextField("Name:", "Bob");
			addChild(nameField);
			
			emailField = new LabelTextField("E-mail Address:", "bob@mail.example.com");
			addChild(emailField);
			
			phoneNumberField = new LabelTextField("Phone Number:", "(888)555-5271");
			addChild(phoneNumberField);
			
			var phoneTips:TipTextField;
			var tipText:String = "Examples: 1-415-555-1212 or 415-555-1212 or (415)555-1212 or 555-1212";
			phoneTips = new TipTextField(phoneNumberField, tipText);
			phoneTips.height = phoneTips.textHeight + 5;
			addChild(phoneTips);
			
			donationField = new LabelTextField("Donation Amounts:", "$955.95, $1,200, $14.22");
			addChild(donationField);
			
			commentsField = new LabelTextField("Comments:", commentsFieldSrc, 100);
			phoneTips.height = phoneTips.textHeight + 5;
			addChild(commentsField);
			
			
			var commentsTips:TipTextField;
			var tipText:String = "Enter HTML formatted comments.";
			commentsTips = new TipTextField(commentsField, tipText);
			commentsTips.height = commentsTips.textHeight + 5;
			addChild(commentsTips);
			
			arrangeTextFields();

			controlButton = new StandardTextButton("Submit");
			controlButton.y = getChildAt(numChildren - 1).y 
								+ getChildAt(numChildren - 1).height + 10;
			controlButton.x = 100;
			addChild(controlButton);
			controlButton.addEventListener(MouseEvent.CLICK, validate);
			
			commentsField.addEventListener(FocusEvent.FOCUS_IN, commentsFocused);
				// flash.events.FocusEvent.FOCUS_IN doesn't work.
			//commentsField.addEventListener("click", commentsFocused);
		}
		private function arrangeTextFields() {
			for (var i:uint = 1; i < numChildren; i++) {
				var displayObject:DisplayObject = getChildAt(i);
				var prevDisplayObject:DisplayObject = getChildAt(i - 1);
				if ((displayObject is LabelTextField) || (displayObject is TipTextField)) {
					displayObject.y = prevDisplayObject.y + prevDisplayObject.height + 10;
				} else {
					y = getChildAt(numChildren - 1).y ;
					x = getChildAt(numChildren - 1).x + getChildAt(numChildren - 1).width + 4;
				}
			}
		}
		private function commentsFocused(e:Event):void {
			commentsField.inputTextField.text = commentsFieldSrc;
			commentsField.inputTextField.setTextFormat(mainFormat);
			commentsField.inputTextField.html = false;
			commentsField.inputTextField.wordWrap = true;
		}
		private function validate(e:Event) {
			var validNamePattern:RegExp = /^[ a-zA-Z,.]+$/;
			var validEmailPattern:RegExp = /^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/;
			var validPhoneNumberPattern:RegExp = /^(((1-)?\d{3}-)|(\(\d{3}\)))?\d{3}-\d{4}$/;

			simpleRegExpTest(nameField, validNamePattern);
			simpleRegExpTest(emailField, validEmailPattern);
			simpleRegExpTest(phoneNumberField, validPhoneNumberPattern);
			
			commentsFieldSrc = commentsField.inputTextField.text;
			if (validCommentsHTML(commentsField.inputTextField.text)) {
				commentsField.inputTextField.html = true;
				commentsField.inputTextField.htmlText = commentsField.inputTextField.text;
				commentsField.invalidFlag.visible = false;
			} else {
				trace ("Invalid comments.");
				commentsField.invalidFlag.visible = true;
			}
			
			var usdPrice:RegExp = /\$([\d,]+.\d+)+/i;
			donationField.inputTextField.text = donationField.inputTextField.text.replace(usdPrice, usdToEuro); 
		} 
		private function simpleRegExpTest(field:LabelTextField, regExp:RegExp) {
			if (!field.inputTextField.text.match(regExp)) {
				field.invalidFlag.visible = true
			} else {
				field.invalidFlag.visible = false
			}
			
		}
		private function validCommentsHTML(str:String):Boolean {
			var validHtmlTagPattern:RegExp = /^([^<]*)<(\w+)(\W.*)*>(.*?)<\/(\2)>(.*)/;
			if (str == null) {
				return true  // Empty strings are valid HTML
			} else if ((!str.match(/<\w+.*>/)) && (!str.match(/<\w+.*>/))) {
					return true; // Strings with no tags are valid HTML.
			} else {
				var execArray:Array = validHtmlTagPattern.exec(str);
				if (execArray == null) {
					return false
				} else if (execArray[2] != execArray[5]) {
					return false
				} else if ( validTag(execArray[2])
					 && validTag(execArray[5])) {
						return validCommentsHTML(execArray[1])
							&& validCommentsHTML(execArray[4])
							&& validCommentsHTML(execArray[6]);
				} else {
					return false
				}
			}
		} 
		private function validTag(tag:String):Boolean {
			var validTags:Array = ["a", "b", "br", "font", "img", "i", "li", "p", "textformat", "u"];
			var matching:Boolean = false;
			for (var i:uint = 0; i < validTags.length; i++) {
				if (tag == validTags[i]) {
					matching = true;
				}
			}
			return matching;
		}
		private function usdToEuro(...args):String {
			var usd:String = args[1];
			usd = usd.replace(",", "");
			var exchangeRate:Number = 0.853690;
			var euro:Number = usd * exchangeRate;
			const euroSymbol:String = String.fromCharCode(8364);
			return euro.toFixed(2) + euroSymbol;
		}
	}
}

import flash.display.*;
import flash.text.TextFormat;
import flash.util.trace;

class LabelTextField extends Sprite {
	public var mainFormat:MainFormat;
	public var labelField:TextField
	public var inputTextField:TextField 
	public var invalidFlag:InvalidFlag;
	public function LabelTextField(label:String, inputText:String = "", inputHeight:Number = 20) {
		mainFormat = new MainFormat();
		labelField = new TextField();
		labelField.defaultTextFormat = new TextFormat("Verdana", 8, 0x000000, true);
		labelField.text = label;
		labelField.width = labelField.textWidth + 4;
		labelField.height = labelField.textHeight + 4;

		inputTextField = new TextField();
		inputTextField.text = inputText;
		inputTextField.defaultTextFormat = mainFormat;
		inputTextField.border = true;
		inputTextField.type = TextFieldType.INPUT;
		inputTextField.x = 100;
		inputTextField.y = labelField.y;
		inputTextField.width = 200;
		inputTextField.height = inputHeight;
		
		invalidFlag = new InvalidFlag();
		invalidFlag.x = inputTextField.x + inputTextField.width;
		invalidFlag.y = inputTextField.y;
		
		addChild(labelField);
		addChild(inputTextField);
		addChild(invalidFlag);
	}
}

class TipTextField extends TextField {
	public function TipTextField(describedField:LabelTextField, label:String, height:Number = 20) {
		defaultTextFormat = new TextFormat("Times", 8);
		text = label;
		y = describedField.y + describedField.height;
		x = describedField.inputTextField.x;
		width = describedField.inputTextField.width;
		height = textHeight + 5;
	}
			
}

class InvalidFlag extends TextField {
	public function InvalidFlag() {
		defaultTextFormat = new TextFormat("Verdana", 8, 0xCC2222, true);
		text = "< Invalid entry";
		height = 20;
		visible = false;
	}
}		

class MainFormat extends TextFormat {
	public function MainFormat() {
		bold = false;
		size = 10;
		italic = false;
	}
}		
