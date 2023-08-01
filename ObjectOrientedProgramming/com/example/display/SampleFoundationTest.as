package com.example.display {
	import asunit.framework.TestCase;

	public class SampleFoundationTest extends TestCase {
		private var instance:SampleFoundationMock;
		private var width:Number = 400;
		private var height:Number = 300;

		public function SampleFoundationTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new SampleFoundationMock();
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("SampleFoundationMock instantiated", instance is SampleFoundationMock);
		}

		public function testSetWidth():Void {
			instance.setWidth(100);
			assertTrue(instance.getWidth() == 100);
		}
		
		public function testSetHeight():Void {
			instance.setHeight(100);
			assertTrue(instance.getHeight() == 100);
		}
		
		public function testSetTitle():Void {
			instance.setWidth(width);
			instance.setHeight(height);
			instance.draw();
		}
	}
}
