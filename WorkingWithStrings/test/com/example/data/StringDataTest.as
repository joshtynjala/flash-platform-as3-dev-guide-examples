package com.example.data {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import asunit.framework.AsynchronousTestCase;
	import flash.events.Event;
	import com.example.content.StringData;
	import flash.util.trace;
	import com.example.content.StringDataMock;

	public class StringDataTest extends AsynchronousTestCase {
		private var stringData:StringDataMock;
		private var source:String = "txt/ImageData.txt";
		private var dataResult:String;

		public function StringDataTest(testMethod:String = null) {
			super(testMethod);
		}

		public override function run():Void {
			var request:URLRequest = new URLRequest(source);
			var loader:StringData = new StringData();
			configureListeners(loader);
			loader.load(request);
		}

		protected override function completeHandler(event:Event):Void {
			dataResult = event.target.data;
			super.run();
		}

		protected override function setUp():Void {
			stringData = new StringDataMock();
		}

		protected override function tearDown():Void {
			delete stringData;
		}

		public function testResult():Void {
			assertTrue("result: " + dataResult, dataResult.indexOf("FILENAME") > -1);
		}

		public function testMockResult():Void {
			assertTrue("result: " + dataResult, stringData.data.indexOf("FILENAME") > -1);
		}
	}
}
