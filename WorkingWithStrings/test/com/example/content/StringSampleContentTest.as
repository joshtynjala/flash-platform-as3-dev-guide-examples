package com.example.content {
	import asunit.framework.TestCase;
	import com.example.data.StringData;

	public class StringSampleContentTest extends TestCase {
		private var instance:StringSampleContent;

		public function StringSampleContentTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new StringSampleContent();
			instance.setWidth(640);
			instance.setHeight(480);
			instance.draw();
			instance.x = 400;
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("StringSampleContent instantiated", instance is StringSampleContent);
		}
	}
}
