package com.example.programmingas3.regExpExamples {
	
	/**
	 * Displays a round clock face with an hour hand, a minute hand, and a second hand.
	 */
	public class CurrencyConverter {
 		/**
		 * Converts strings of US dollar values (such as "$9.95") 
		 * to Euro strings (such as "8.24 €".
		 */
		public static function usdToEuro(input:String):String {
			
			/**
			 * A regular expression matching a pattern for a US dollar value.
			 * A $ symbol (\$) followed by a number pattern. The number pattern
			 * matches a string of one or more characters that are either digits
			 * or commas (	[\d,]+) followed by at least one digit (\d+). 
			 * Note that parentheses are used to capture the number pattern.
			 */
			var usdPrice:RegExp = /\$([\d,]+.\d+)+/g;
			
			/**
			 * Replaces the matching dollar strings with the Euro equivalent string.
			 * The second parameter defines a function, used to define the 
			 * replacement string.
			 */
			return input.replace(usdPrice, usdStrToEuroStr); 
		}
		
		/**
		 * Called as the second parameter of the replace() method of a String.
		 * As such, the call passes the following parameters:
		 *     
		 * - The matching portion of the string, such as "$9.95"
		 * - The parenthetical match, such as "9.95" 
		 * - The index position in the string where the match begins
		 * - The complete string
		 * 
		 * This method takes the second parameter (args[1]), converts it to
		 * a number, and then converts it to a Euro string, by applying a
		 * conversion factor and then appending the € character.
		 */
		private static function usdStrToEuroStr(...args):String {
			var usd:String = args[1];
			usd = usd.replace(",", "");
			var exchangeRate:Number = 0.828017;
			var euro:Number = Number(usd) * exchangeRate;
			trace(usd, Number(usd), euro);
			const euroSymbol:String = String.fromCharCode(8364);
			return euro.toFixed(2) + " " + euroSymbol;
		}
	}
}