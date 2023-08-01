package com.example.display {
	import asunit.framework.TestCase;
	import flash.util.trace;

	public class SampleHeaderTest extends TestCase {
		private var instance:SampleHeaderMock;
		private var width:int = 400;
		private var height:int = 80;
		private var title:String = "Hello World";
		private var description:String = "The following example is meant to demonstrate functionality of the XML object.";

		public function SampleHeaderTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new SampleHeaderMock();
			instance.setWidth(width);
			instance.setHeight(height);
			instance.draw();
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("SampleHeaderMock instantiated", instance is SampleHeaderMock);
		}
		
		public function testSetSize():Void {
			var gutter:Number = 5;
			var TITLE_HEIGHT:Number = 30;
			var DESCRIPTION_HEIGHT:Number = 50;
			assertTrue(instance.getWidth() == width);
			assertTrue(instance.getHeight() == (TITLE_HEIGHT + DESCRIPTION_HEIGHT + (2 * gutter)));
		}
		
		public function testSetTitle():Void {
			instance.setTitle(title);
			assertTrue(instance.getTitle() == title);
		}
		
		public function testSetDescription():Void {
			instance.setDescription(description);
			assertTrue(instance.getDescription() == description);
		}
		
		public function testTitleAndDescription():Void {
			instance.setTitle(title);
			instance.setDescription(description);
			assertTrue(instance.getTitle() == title);
			assertTrue(instance.getDescription() == description);
		}
	}
}
