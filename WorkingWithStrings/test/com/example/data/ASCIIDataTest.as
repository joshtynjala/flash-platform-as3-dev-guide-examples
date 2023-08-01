package com.example.data {
	import asunit.framework.TestCase;
	import flash.util.trace;
	import com.example.data.Iterable;
	
	public class ASCIIDataTest extends TestCase {
		private var instance:ASCIIDataMock;

		public function ASCIIDataTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new ASCIIDataMock();
		}

		protected override function tearDown():Void {
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("ASCIIDataMock instantiated", instance is ASCIIDataMock);
		}

		public function testData():Void {
			assertTrue("data: " + instance.data, instance.data.indexOf("FILENAME") > -1);
		}
		
		public function testHasNext():Void {
			var iterator:Iterable = instance.getIterator();
			assertTrue(iterator.hasNext());
		}
		
		public function testNext():Void {
			var iterator:Iterable = instance.getIterator();
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next().getFileName() == "FruitBasket.jpg");
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next().getFileName() == "Banana.jpg");
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next().getFileName() == "Orange.jpg");
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next().getFileName() == "Apple.jpg");
			assertTrue(iterator.hasNext());
			assertTrue(iterator.next().getFileName() == "Pear.jpg");
			assertFalse(iterator.hasNext());
		}
	}
}
