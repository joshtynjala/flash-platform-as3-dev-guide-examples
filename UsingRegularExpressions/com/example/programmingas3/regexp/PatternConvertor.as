package com.example.programmingas3.regexp {

	public class PatternConvertor {
		
		public var pattern:RegExp;
		
		public function PatternConvertor(pat:RegExp) {
			pattern = pat;
		}
		
		public function convert(text:String):String {
			return text.replace(pattern, convertFunction);
		}
		
		/**
		 * Just echoes the original text. This method is meant to be overridden
		 * in a subclass.
		 */
		protected function convertFunction(...args):String 
		{
			var text:String = args[1];
			return text;
		}
	}
}