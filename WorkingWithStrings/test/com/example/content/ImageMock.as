package com.example.content {
	import com.example.content.Image;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventType;
	import flash.util.trace;
	
	public class ImageMock extends Image {
		private var image:Bitmap;

		public function ImageMock() {
		}
		
		public function setImage(bitmap:Bitmap):Void {
			image = bitmap;
			addChild(image);
			dispatchEvent(new Event(EventType.COMPLETE));
		}
		
		public override function getBitmapData():BitmapData {
			return image.bitmapData;
		}
	}
}
