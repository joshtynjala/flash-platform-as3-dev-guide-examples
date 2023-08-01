package com.example.programmingas3.regExpExamples
{
	/**
	 * Used to define the main functionality of the WikiParser application:
	 * 
	 * - Provides a sample wiki string.
	 * - Uses regular expressions to convert a Wiki string into HTML text.
	 * 
	 */ 
	public class WikiParser {
		
		/**
		 * The string that contains the wiki text.
		 */
		public var wikiData:String; 

		/**
		 * The constructor function, which initializes the wiki text with new sample data.
		 */
		public function WikiParser() {
			wikiData = setWikiData();
		}
		
		/**
		 * Returns sample wiki data.
		 */
		private function setWikiData():String {
			var str:String = "'''Test wiki data'''\n" +
				  "\n" +
				  "This is a test. This is ''only'' a test.\n" +
				  "Basic rules:\n" +
					"* 3 single quote marks indicates '''bold'''.\n" +
					"* 2 single quote marks indicates ''italics''.\n" +
					"* An asterisk creates a bulleted list item.\n" +
					"* Use blank lines as paragraph separators.\n" +
				  "\n" +
				  "You can convert a dollar value like this: $9.95.\n" +
				  "\n" +
				  "Here's a URL to convert: http://www.adobe.com.\n" +
				  "\n" +
				  "Here's an e-mail address to convert: mailto:bob@example.com.";
				  
			return str;
		}
		
		/**
		 * Converts a wiki string to HTML text.
		 */
		public function parseWikiString (wikiString:String):String {
			var result:String = parseBold(wikiString);
			result = parseItalic(result);
			result = linesToParagraphs(result);
			result = parseBullets(result);
			return result;
		}
		
		/**
		 * Replaces a bold pattern in a wiki string with the 
		 * HTML equivalent. For example '''foo''' becomes
		 * <b>foo</b>.
		 */
		private function parseBold(input:String):String {
			var pattern:RegExp = /'''(.*?)'''/g;
			return input.replace(pattern, "<b>$1</b>");
		}
		
		/**
		 * Replaces an italic pattern in a wiki string with the 
		 * HTML equivalent. For example ''foo'' becomes
		 * <i>foo</i>.
		 */
		private function parseItalic(input:String):String {
			var pattern:RegExp = /''(.*?)''/g;
			return input.replace(pattern, "<i>$1</i>");
		}
		
		/**
		 * Replaces a bold pattern in a wiki string with the 
		 * HTML equivalent. For example the following line:
		 * * foo
		 * Becomes this:
		 * 
		 * <li>foo</li>
		 */
		private function parseBullets(input:String):String {
			var pattern:RegExp = /^\*(.*)/gm;
			return input.replace(pattern, "<li>$1</li>");
		}
		
		/**
		 * Replaces a newline in a wiki string with the 
		 * <p> HTML tag. 
		 */
		private function linesToParagraphs(input:String):String {
			
			/**
			 * Strips out empty lines, which match /^$/gm
			 */
			var pattern:RegExp = /^$/gm;
			var result:String = input.replace(pattern, "");
			
			/**
			 * Adds <p> tags around all remaining lines.
			 * However, not those that begin with an asterisk,
			 * which are considered <li> items.
			 */
			pattern = /^([^*].*)$/gm;
			return result.replace(pattern, "<p>$1</p>");
		}	  
	}
}