package com.example.programmingas3.regexp {

	import com.example.programmingas3.regexp.PatternConvertor;
	
	public class EuroConvertor extends PatternConvertor {
		
		public function EuroConvertor() {
			var usdPricePattern:RegExp = /\$([\d,]+.\d+)+/i;
			super(usdPricePattern);
		}
		
		/**
		 * Replaces a Dollar value with an equivalent Euro value.
		 */
		protected override function convertFunction(...args):String 
		{
			var usd:String = args[1];
			usd = usd.replace(",", "");
			var exchangeRate:Number = 0.853690;
			var euroValue:Number = usd * exchangeRate;
			
			const euroSymbol:String = String.fromCharCode(8364);
			return euroValue.toFixed(2) + euroSymbol;
		}
	}
}