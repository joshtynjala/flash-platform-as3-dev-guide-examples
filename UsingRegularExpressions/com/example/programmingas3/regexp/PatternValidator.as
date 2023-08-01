package com.example.programmingas3.regexp {

	public class PatternValidator {
		
		public var pattern:RegExp;
		
		public function PatternValidator(pat:RegExp) {
			pattern = pat;
		}
		
		public function validate(text:String):Boolean {
			return text.match(pattern);
		}
	}
}