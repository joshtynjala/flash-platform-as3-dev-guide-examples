package com.example.data {
	import asunit.framework.TestCase;

	public class ASCIIRecordTest extends TestCase {
		private var instance:ASCIIRecord;
		private var fileName:String = "FruitBasket.Jpg";
		private var title:String = "Pear, apple, orange, and banana";
		private var whiteThreshold:String = "d8";
		private var blackThreshold:String = "10";

		public function ASCIIRecordTest(testMethod:String = null) {
			super(testMethod);
		}


		protected override function setUp():Void {
			instance = new ASCIIRecord();
		}

		protected override function tearDown():Void {
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("ASCIIRecord instantiated", instance is ASCIIRecord);
		}

		public function testSetters():Void {
			instance.setTitle(title);
			instance.setFileName(fileName);
			instance.setWhiteThreshold(whiteThreshold);
			instance.setBlackThreshold(blackThreshold);
			
			assertTrue(instance.getTitle() == "Pear, Apple, Orange, and Banana");
			assertTrue(instance.getFileName() == "FruitBasket.jpg");
			assertTrue(instance.getWhiteThreshold() == parseInt(whiteThreshold, 16));
			assertTrue(instance.getBlackThreshold() == parseInt(blackThreshold, 16));
		}
	}
}
