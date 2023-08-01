package com.example.content {
	import asunit.framework.TestCase;
	import flash.util.trace;
	import flash.util.getClassByName;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.display.Bitmap;

	public class ASCIIPrinterTest extends TestCase {
		[Embed(source="img/Banana.jpg")]
		private var Banana:Class;
		private var instance:ASCIIPrinter;
		private var image:Bitmap;

		public function ASCIIPrinterTest(testMethod:String = null) {
			super(testMethod);
		}

		protected override function setUp():Void {
			image = new Banana();
			image.x = 5;
			image.y = 5;
			addChild(image);
			
			instance = new ASCIIPrinter();
			instance.setBitmapData(image.bitmapData);
			instance.setWidth(600);
			instance.setHeight(400);
			instance.setX(400);
			instance.draw();
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(image);
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("ASCIIPrinter instantiated", instance is ASCIIPrinter);
		}
	}
}
