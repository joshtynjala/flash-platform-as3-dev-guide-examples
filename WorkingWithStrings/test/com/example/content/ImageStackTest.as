package com.example.content {
	import asunit.framework.TestCase;
	import com.example.display.SampleComponent;
	import com.example.display.SampleComponentMock;
	import com.example.data.Iterable;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	public class ImageStackTest extends TestCase {
		private var instance:ImageStack;

		public function ImageStackTest(testMethod:String = null) {
			super(testMethod);
		}


		protected override function setUp():Void {
			instance = new ImageStack();
		}

		protected override function tearDown():Void {
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("ImageStack instantiated", instance is ImageStack);
		}
		
		public function testBadAddChild():Void {
			try {
				instance.addChild(new Sprite());
				fail("Should have thrown an illegal operation error");
			}
			catch(e:IllegalOperationError) {
			}
		}

		public function testAddChild():Void {
			var component_0:SampleComponent = new ImageMock();
			var component_1:SampleComponent = new ImageMock();
			var component_2:SampleComponent = new ImageMock();
			
			assertFalse(instance.hasNext());
						
			instance.addChild(component_0);
			instance.addChild(component_1);
			instance.addChild(component_2);
			
			assertTrue(instance.hasNext());
			assertTrue("adding child " + component_0, instance.next() === component_0);
	
			assertTrue(instance.hasNext());
			assertTrue("adding child " + component_1, instance.next() === component_1);
			assertTrue(instance.hasNext());
			assertTrue("adding child " + component_2, instance.next() === component_2);

			assertTrue(instance.hasNext());
			assertTrue("adding child " + component_0, instance.next() === component_0);
		}
	}
}
