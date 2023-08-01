package com.example.programmingas3.stockticker
{
	import flash.globalization.CurrencyFormatter;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeNameStyle;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LastOperationStatus;
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;

	/**
	 * Manages the localization of numbers, currency amounts, and dates by using the
	 * features of the flash.globalization library.
	 */
	public class Localizer
	{
		private var locale:LocaleID;
		private var currentCurrency:String = "USD";
		private var currentFraction:Number = 2;
		private var currentSymbol:String = "$";
		private var symbolIsSafe:Boolean;

		public var df:DateTimeFormatter;
		public var nf:NumberFormatter;
		public var cf:CurrencyFormatter;
		
		public var monthNames:Vector.<String>;
		
		public function Localizer():void
		{
			//
		}
		
		/**
		 * Creates new formatters when the locale ID changes.
		 */
		public function setLocale(newLocale:String):void
		{
			locale = new LocaleID(newLocale);

			nf = new NumberFormatter(locale.name);
			traceError(nf.lastOperationStatus, "NumberFormatter", nf.actualLocaleIDName);
			
			cf = new CurrencyFormatter(locale.name);
			traceError(cf.lastOperationStatus, "CurrencyFormatter", cf.actualLocaleIDName);
			symbolIsSafe = cf.formattingWithCurrencySymbolIsSafe(currentCurrency);
			cf.setCurrency(currentCurrency, currentSymbol);
			cf.fractionalDigits = currentFraction;
			
			df = new DateTimeFormatter(locale.name, DateTimeStyle.LONG, DateTimeStyle.SHORT);
			traceError(df.lastOperationStatus, "DateTimeFormatter", df.actualLocaleIDName);
			
			monthNames = df.getMonthNames(DateTimeNameStyle.LONG_ABBREVIATION);
		}
		
		/**
		 * Sends information about errors and fallbacks to the console. 
		 * In a real application this should be replaced by error handling logic.
		 */
		public function traceError(status:String, serviceName:String, localeID:String):void
		{
			if(status != LastOperationStatus.NO_ERROR) 
			{
				if(status == LastOperationStatus.USING_FALLBACK_WARNING) 
				{
					trace("Warning - Fallback locale ID used by " + serviceName + ": " + localeID);
				} 
				else
				{
					trace("Error in " + serviceName + ": " + status);
				}
			}
			else
			{
				trace(serviceName + " created for locale ID: " + localeID);
			}
		}
		
		/**
		 * Saves the currency string, currency symbol, and number of franctional digits for the 
		 * currently selected market.
		 */
		public function setFormatProperties(fractionalDigits:int, currency:String, symbol:String):void
		{
			currentFraction = fractionalDigits;
			currentCurrency = currency;
			currentSymbol = symbol;
		}
														
		public function formatNumber(value:Number, fractionalDigits:int = 2):String
		{
			nf.fractionalDigits = fractionalDigits;
			return nf.formatNumber(value);
		}
		
		public function formatPercent(value:Number, fractionalDigits:int = 2):String
		{
			nf.fractionalDigits = fractionalDigits;

			// Most operating systems don't support formatting of percentages,
			// so it's not implemented in the first version of the 
			// flash.globalization package.  There are locales where the percent sign 
			// is not at the end, such as 12,34 %" (Danish, German, French, others), 
			// "-%�12,34" (Turkish), and "-%12,34" (Farsi).
			return nf.formatNumber(value) + "%";
		}
		
		public function formatCurrency(value:Number):String
		{
			return cf.format(value, symbolIsSafe)
		}
		
		public function formatDate(dateValue:Date):String
		{
			return df.format(dateValue);
		}
	}
}
