package com.example.programmingas3.regexp {

	public class HtmlTagValidator extends PatternValidator {
		
		public function HtmlTagValidator() {
			var validHtmlTagPattern:RegExp = /^([^<]*)<(\w+)(\W.*)*>(.*?)<\/(\2)>(.*)/;
			super(validHtmlTagPattern);
		}
		
		public override function validate(text:String):Boolean {
			
			if (text == null) {
				return true;  // Empty strings are valid HTML
			} 
			else if ((!text.match(/<\w+.*>/)) && (!text.match(/<\w+.*>/))) {
				return true; // Strings with no tags are valid HTML.
			} 
			else {
				var execArray:Array = pattern.exec(text);
				if (execArray == null) 
				{
					return false;
				} 
				else if (execArray[2] != execArray[5]) 
				{
					return false;
				} 
				else if ( validTag(execArray[2]) && validTag(execArray[5])) 
				{
					return validate(execArray[1])
						&& validate(execArray[4])
						&& validate(execArray[6]);
				} 
				else 
				{
					return false;
				}
			}
		} 
		
		private function validTag(tag:String):Boolean 
		{
			var validTags:Array = ["a", "b", "br", "font", "img", "i", "li", "p", "textformat", "u"];
			var matching:Boolean = false;
			
			for (var i:uint = 0; i < validTags.length; i++) 
			{
				if (tag == validTags[i]) 
				{
					matching = true;
				}
			}
			return matching;
		}

	}
}