package com.example.display {
	import asunit.framework.TestCase;

	public class SampleComponentTest extends TestCase {
		private var instance:SampleComponent;

		public function SampleComponentTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new SampleComponentMock();
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("SampleComponent instantiated", instance is SampleComponent);
		}
		
		public function testDefaultWidth():Void {
			assertTrue(instance.getWidth() == 0);
		}
		
		public function testDefaultHeight():Void {
			assertTrue(instance.getHeight() == 0);
		}
		
		public function testSetWidth():Void {
			instance.setWidth(100);
			assertTrue(instance.getWidth() == 100);
		}
		
		public function testSetHeight():Void {
			instance.setHeight(100);
			assertTrue(instance.getHeight() == 100);
		}
		
		public function testDisplayMock():Void {
			instance.setWidth(200);
			instance.setHeight(100);
			instance.draw();
			
		}
	}
}
