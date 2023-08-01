package com.example.content {
	import asunit.framework.TestCase;
	import flash.net.URLRequest;
	import flash.events.EventType;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.util.trace;

	public class ImageTest extends TestCase {
		[Embed(source="img/Banana.jpg")]
		private var Banana:Class;
		private var instance:ImageMock;

		public function ImageTest(testMethod:String = null) {
			super(testMethod);
		}

		private function completeHandler(event:Event):Void {
		}
		
		protected override function setUp():Void {
			var image:Bitmap = new Banana();
			instance = new ImageMock();
			instance.addEventListener(EventType.COMPLETE, completeHandler);
			instance.setImage(image);
			instance.x = 400;
			addChild(instance);
		}

		protected override function tearDown():Void {
			removeChild(instance);
			delete instance;
		}

		public function testInstantiated():Void {
			assertTrue("Image instantiated", instance is Image);
		}

		public function testGetBitmapData():Void {
			var bitmap:BitmapData = instance.getBitmapData();
			assertTrue("getBitmapData workded", bitmap is BitmapData);
		}

		public function testBitmapDataSize():Void {
			var bitmap_0:BitmapData = instance.getBitmapData();
			
			instance.setWidth(20);
			instance.setHeight(20);
			instance.draw();
		
			var bitmap_1:BitmapData = instance.getBitmapData();
			assertTrue("bitmapData retains size", bitmap_0.width == bitmap_1.width);
			assertTrue("bitmapData retains size", bitmap_0.height == bitmap_1.height);
		}
	}
}
