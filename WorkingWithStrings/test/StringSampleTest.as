package  {
	import asunit.framework.TestCase;

	public class StringSampleTest extends TestCase {
		private var instance:StringSample;

		public function StringSampleTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			instance = new StringSampleMock();
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("StringSample instantiated", instance is StringSample);
		}

		public function testSize():Void {
			assertTrue(instance.getWidth() == 600);
			assertTrue(instance.getHeight() == 400);
		}
	}
}
