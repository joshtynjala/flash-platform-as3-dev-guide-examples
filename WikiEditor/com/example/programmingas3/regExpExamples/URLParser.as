package com.example.programmingas3.regExpExamples {
	
	/**
	 * A utility class that converts URL strings, such as "http://example.com" to 
	 * HTML anchor links, such as "<a href='http://example.com'>http://example.com</a>.
	 */
	public class URLParser
	{
		/**
		 * Converts HTTP and FTP URLs to anchor links. This function assembles a 
		 * RegExp pattern out of multiple parts: protocol, urlPart, and optionalUrlPart.
		 */
		public static function urlToATag(input:String):String {
			
			/**
			 * Matches either http:// or ftp://. (?: indicates that the interior group
			 * is not a capturing group.
			 */
			var protocol:String = "((?:http|ftp)://)";
			
			/** 
			 * For the URL http://foo.example.com/foo, matches foo.example.
			 */
			var urlPart:String = "([a-z0-9_-]+\.[a-z0-9_-]+)";
			
			/**
			 * For the URL http://example.com/foo, matches example.
			 */
			var optionalUrlPart:String = "(\.[a-z0-9_-]*)";
			
			/**
			 * Assembles the pattern from its component parts.
			 */
			var urlPattern:RegExp = new RegExp (protocol + urlPart + optionalUrlPart, "ig");
			
			/**
			 * Replaces matching URL strings with a replacement string. The call to 
			 * the replace() method uses references to captured groups (such as $1) 
			 * to assemble the replacement string.
			 */
			var result:String = input.replace(urlPattern, "<a href='$1$2$3'><u>$1$2$3</u></a>");

			/** 
			 * Next, find e-mail patterns and replace them with <a> hyperlinks.
			 */
			result = emailToATag(result); 
			return result;
		}
		
		/**
		 * Replaces an e-mail pattern with a corresponding HTML anchor hyperlink.
		 * Like the urlToATag() method, this method assembles a regular expression out
		 * of constituent parts.
		 */
		public static function emailToATag(input:String):String {
			/**
			 * Isolates the mailto: part of the string.
			 */
			var protocol:String = "(mailto:)";
			
			/**
			 * Matches the name and @ symbol, such as bob.fooman@.
			 */
			var name:String = "([a-z0-9_-]+(?:\.[a-z0-9_-])*@)";
			
			/**
			 * For the e-mail pattern bob.fooman@mail.example.com, matches 
			 * mail.example. (including the trailing dot).
			 */
			var domain:String = "((?:[a-z0-9_-].)*)";
			
			/**
			 * Matches the superdomain, such as com, uk, or org., which is 2 - 4 letters.
			 */
			var superDomain:String = "([a-z]{2,4})";
			
			/**
			 * Assembles the matching regular expression out of constituent parts.
			 */
			var emailPattern:RegExp = new RegExp (protocol + name + domain + superDomain, "ig");

			/**
			 * Replaces matching e-mail strings with a replacement string. The call to 
			 * the replace() method uses references to captured groups (such as $1) 
			 * to assemble the replacement string.
			 */
			var result:String = input.replace(emailPattern, "<a href='$1$2$3$4'><u>$1$2$3$4</u></a>"); 

			return result;
		}
	}
}