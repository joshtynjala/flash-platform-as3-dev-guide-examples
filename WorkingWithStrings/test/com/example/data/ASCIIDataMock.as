package com.example.data {
	import flash.net.URLRequest;

	public class ASCIIDataMock extends ASCIIData {

		public function ASCIIDataMock(request:URLRequest = null) {
			super(request);
			data = getFauxData();
			parse();
		}
		
		private function getFauxData():String {
			var str:String = "";
			str += "FILENAME	TITLE	WHITE_THRESHHOLD	BLACK_THRESHHOLD\n"
				+ "FruitBasket.jpg	Pear, apple, orange, and banana	d8	10\n"
				+ "Banana.jpg	A picture of a banana	C8	20\n"
				+ "Orange.JPG	orange	FF	20\n"
				+ "Apple.jpg	picture of an apple	6E	10\n"
				+ "Pear.JPG	pear	0xBB	0x30";
			return str;
		}
	}
}
