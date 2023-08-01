package com.example.programmingas3.stockticker
{
	/**
	 * Stores all of the data for the GlobalStockTicker example.
	 */
	public class StockDataModel 
	{

		private var usStocks : Array = [
        	{ ticker:"EQXE", volume: 1232131, price:31.62, change:23.5 },
        	{ ticker:"FRRQ", volume: 4435921, price:26.21, change:-1.2 },
        	{ ticker:"GXQQ", volume:  915832, price:16.24, change: 4.6 },
        	{ ticker:"OQKE", volume: 7712977, price:1251.18, change:14.8 },
        	{ ticker:"QJEL", volume:13523881, price:17.95, change: 7.3 },
        	{ ticker:"ZQRW", volume: 5834773, price:32.83, change:-2.6 }
		];
		private var euStocks : Array = [
        	{ ticker:"AVGOX", volume:  6905431, price:26.31, change:-4.5 },
        	{ ticker:"BRAGK", volume: 84959872, price:62.26, change: 3.9 },
        	{ ticker:"KXAQA", volume: 40596529, price:42.16, change: 6.4 },
        	{ ticker:"MZAOS", volume:154959562, price:81.51, change:-5.6 },
        	{ ticker:"RXAQR", volume: 84171312, price:59.17, change: 7.7 },
        	{ ticker:"TOSQK", volume:  4841984, price:38.32, change: 5.1 }
		];
		private var jaStocks : Array = [
        	{ ticker:"後芝電器産業(株)",	volume: 3716026, price: 1233, change:  5.62 },
        	{ ticker:"トヤタ自動車(株)",	volume:  925569, price:31234, change: 24.81 },
        	{ ticker:"キョノン(株)",		volume: 2971599, price:51231, change: -9.51 },
        	{ ticker:"任端堂(株)",		volume: 9849265, price: 4324, change: 20.34 },
        	{ ticker:"パニソナック(株)",	volume:15195171, price:12234, change: -4.08 },
        	{ ticker:"武畑薬品工業(株)",	volume: 5423988, price: 5523, change: 13.74 }
		];
		
		/**
		 * Depending on your system you might have problems rendering some of the text,
		 * or might have locales that are not supported.
		 */
		public const locales:Array = [
			{ data:"de-de",	label: "de-DE (German, Germany)" },
			{ data:"el",	label: "el (Greek)" },
			{ data:"en-gb",	label: "en-GB (English, Great Britain)" }, 
			{ data:"en-us",	label: "en-US (English, U.S.)" }, 
			{ data:"fr-ca",	label: "fr-CA (French, Canada)" }, 
			{ data:"fr-ch",	label: "fr-CH (French, Swiss)" }, 
			{ data:"fr-fr",	label: "fr-FR (French, France)" },
			{ data:"hi",	label: "hi (Hindi)" },
			{ data:"ja",	label: "ja (Japanese)" },
			{ data:"ru",	label: "ru (Russian)" },
			{ data:"zh-cn",	label: "zh-CN (Chinese, China)" }
		];
		
		public const markets:Array = [
			{label:"US", data:1, currency:"USD", symbol:"$", fraction:2},
			{label:"Japanese", data:2, currency:"JPY", symbol:"¥", fraction:0},
			{label:"European", data:3, currency:"EUR", symbol:"€", fraction:2}
		];

		public var stocks:Array;
		
		public function StockDataModel() 
		{
			stocks = new Array(3);
			stocks[0] = usStocks;
			stocks[1] = jaStocks;
			stocks[2] = euStocks;
		}
	}
}
