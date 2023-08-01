// Copyright (c) 2005 Adobe, Inc.
package 
{
	import com.example.programmingas3.shared.component.LabeledTextField;
	import com.example.programmingas3.shared.component.SampleComponent;
	import com.example.programmingas3.shared.component.SampleContainer;
	import com.example.programmingas3.shared.component.SampleLabel;
	import com.example.programmingas3.shared.component.SampleTextField;
	import com.example.programmingas3.shared.component.SampleTextInput;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.util.trace;
	import com.example.programmingas3.regexp.PatternValidator;
	import com.example.programmingas3.regexp.HtmlTagValidator;
	import com.example.programmingas3.regexp.EuroConvertor;
	
	/**
	 * Demonstrates different matching and replacement techniques using 
	 * Regular expressions. 
	 * 
	 * Creates a number of text fields and lets you validate or convert their contents.
	 */
	public class ExpressionValidator2 extends SampleContainer
	{
		/**
		 * A simple name text field.
		 */
		public var nameField:LabeledTextField;
		/**
		 * Used for validating an email format
		 */
		public var emailField:LabeledTextField;
		/**
		 * Used for validating a phone number format
		 */
		public var phoneNumberField:LabeledTextField;
		/**
		 * Used for converting a list of dollar values into euro values.
		 */
		public var donationField:LabeledTextField;
		/**
		 * Used for validating HTML tags.
		 */
		public var sourceField:LabeledTextField;
		/**
		 * Displays the formatted HTML being validated.
		 */
		public var htmlField:SampleHtmlField;
		/**
		 * The initial HTML text used to populate the sourceField.
		 */
		public var htmlFieldSrc:String = "Check <i>this</i> for HTML <b>validity</b>.";	
		/**
		 * The button that triggers the validations and conversions.
		 */	
		public var submitButton:SampleTextButton;
		
		public var nameValidator:PatternValidator;
		public var emailValidator:PatternValidator;
		public var phoneValidator:PatternValidator;
		
		public var htmlValidator:HtmlTagValidator;
		
		public var euroConvertor:EuroConvertor;
		
		public function ExpressionValidator2(w:uint = 500, h:uint = 400, thickness:Number = 0.0, pad:uint = 5) 
		{
			super(w, h, thickness, pad);
			
			// allows spaces, letters, commas, and periods only
			var validNamePattern:RegExp = /^[ a-zA-Z,.]+$/;
			nameValidator = new PatternValidator(validNamePattern);
			
			// allows for standard email address formatting, like name@domain.com
			var validEmailPattern:RegExp = /^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/;
			emailValidator = new PatternValidator(validEmailPattern);
			
			// allows formatted phone US numbers only, in the format 1(800)555-1212
			var validPhoneNumberPattern:RegExp = /^(((1-)?\d{3}-)|(\(\d{3}\)))?\d{3}-\d{4}$/;
			phoneValidator = new PatternValidator(validPhoneNumberPattern);
			
			// allows basic HTML tags; the pattern is set internally in the HtmlTagValidator() constructor
			htmlValidator = new HtmlTagValidator();
			
			// converts dollar values into euro values
			euroConvertor = new EuroConvertor();
						
			this.init();
		}
		
		public override function init():void 
		{
			this.backgroundColor = 0xDDDDEE;
			
			var instructions:SampleLabel = new SampleLabel(400, 20, getTipTextFormat());
			instructions.text = "Complete each of the following fields, and then click the Submit button.";
			addComponent(instructions);
			
			nameField = new LabeledTextField("Name:", "Bob");
			addComponent(nameField);
			
			emailField = new LabeledTextField("E-mail Address:", "bob@mail.example.com");
			addComponent(emailField);
			
			phoneNumberField = new LabeledTextField("Phone Number:", "(888)555-5271");
			addComponent(phoneNumberField);
			
			var phoneTips:SampleLabel = new SampleLabel(200, 20, getTipTextFormat());
			phoneTips.x = 120;
			// lets this label size to fit the text as needed
			phoneTips.field.autoSize = TextFieldAutoSize.LEFT;
			phoneTips.text = "Examples: 1-415-555-1212 or 415-555-1212 or (415)555-1212 or 555-1212";
			addComponent(phoneTips);
			
			donationField = new LabeledTextField("Donation Amounts:", "$955.95, $1,200, $14.22");
			addComponent(donationField);
			
			var donationTips:SampleLabel = new SampleLabel(200, 20, getTipTextFormat());
			donationTips.x = 120;
			// lets this label size to fit the text as needed
			donationTips.field.autoSize = TextFieldAutoSize.LEFT;
			donationTips.text = "Donations entered with a leading $ will be converted to Euros.";
			addComponent(donationTips);
			
			sourceField = new LabeledTextField("HTML Source:", htmlFieldSrc, 200, 60);
			sourceField.inputField.field.multiline = true;
			sourceField.inputField.field.html = false;
			addComponent(sourceField);

			var htmlTips:SampleLabel = new SampleLabel(200, 20, getTipTextFormat());
			htmlTips.x = 120;
			// lets this label size to fit the text as needed
			htmlTips.field.autoSize = TextFieldAutoSize.LEFT;
			htmlTips.text = "Enter HTML text above. The formatted version is displayed below.";
			addComponent(htmlTips);

			htmlField = new SampleHtmlField(200, 60);
			htmlField.x = 120;
			htmlField.selectable = false;
			htmlField.htmlText = htmlFieldSrc;
			addComponent(htmlField);
			
			// When the sourceField loses focus, update the htmlField
			sourceField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			// When you click outside of the sourceField, update the htmlField.
			// Don't want to do this on the change event, because when you're 
			// in the middle of typing HTML tags you would be passing invalid
			// HTML to the htmlField with each keystroke.
			this.addEventListener(MouseEvent.CLICK, onBackgroundClick);
			
			arrangeTextFields();

			submitButton = new SampleTextButton("Submit");
			submitButton.y = getChildAt(numChildren - 1).y + getChildAt(numChildren - 1).height + 10;
			submitButton.x = 120;
			addChild(submitButton);
			submitButton.addEventListener(MouseEvent.CLICK, validate);
			
			draw();
		}
		
		/**
		 * Stacks the components vertically, with a gap between them.
		 */
		private function arrangeTextFields()
		{
			var verticalGap:uint = 4;
			var displayObject:DisplayObject;
			var prevDisplayObject:DisplayObject;
						
			for (var i:uint = 1; i < this.canvas.numChildren; i++) 
			{
				displayObject = this.canvas.getChildAt(i);
				prevDisplayObject = this.canvas.getChildAt(i - 1);
				
				if ((displayObject is SampleComponent) || (displayObject is SampleTextButton)) 
				{
					displayObject.y = prevDisplayObject.y + prevDisplayObject.height + verticalGap;
					trace("new Y=" + displayObject.y);
				}
			}
		}

		/**
		 * Updates the formatted HTML display when the HTML sourceField loses focus.
		 */		
		private function onFocusOut(evt:FocusEvent):void 
		{
			htmlField.htmlText = sourceField.inputField.text;
		}
		
		/**
		 * Updates the formatted HTML display when you click outside the sourceField.
		 */			
		private function onBackgroundClick(evt:MouseEvent):void 
		{
			//trace("onClick() target=" + evt.target);
			if (! sourceField.inputField.hitTestPoint(evt.localX, evt.localY, true))
			{
				htmlField.htmlText = sourceField.inputField.text;
			}
		}
		
		private function validate(e:Event)
		{
			// performs basic pattern matching
			nameField.showWarning( !nameValidator.validate(nameField.inputField.text) );
			emailField.showWarning( !emailValidator.validate(emailField.inputField.text) );	
			phoneNumberField.showWarning( !phoneValidator.validate(phoneNumberField.inputField.text) );
			
			// checks for matching HTML tags
			sourceField.showWarning( !htmlValidator.validate(sourceField.inputField.text) );
			
			// converts dollar values to euro values
			donationField.inputField.text = euroConvertor.convert(donationField.inputField.text); 
		} 
		
		/**
		 * Defines a small text format for instruction labels.
		 */
		private function getTipTextFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 8;
			format.bold = false;
			format.color = 0x000000;
			return format;
		}
	}
}		
