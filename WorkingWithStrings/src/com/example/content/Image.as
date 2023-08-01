package com.example.content {
	import com.example.display.SampleComponent;
	import flash.events.Event;
	import flash.events.EventType;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.util.trace;

	public class Image extends SampleComponent {
		protected var loader:Loader;

		public function Image() {
			gutter = 5;
			loader = new Loader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			addChild(loader);
		}
		
		public function load(request:URLRequest):void {
			loader.load(request);
		}
		
		private function completeHandler(event:Event):void {
			draw();
			dispatchEvent(event);
		}
		
		public function getBitmapData():BitmapData {
			return Bitmap(loader.content).bitmapData;
		}
		
		public override function draw():void {
			super.draw();
			if(loader.content == null) {
				return;
			}
			var imageWidth:Number = loader.content.width;
			var imageHeight:Number = loader.content.height;
			var availableWidth:Number = getWidth();
			var availableHeight:Number = getHeight();			
			var availableRatio:Number = availableWidth / availableHeight;
			var imageRatio:Number = imageWidth / imageHeight;
			
			if(availableRatio > imageRatio) {
				loader.width = availableHeight * imageRatio;
				loader.height = availableHeight;
				loader.x = ((availableWidth - loader.width) / 2) + gutter;
				loader.y = gutter;
			}
			else {
				loader.width = availableWidth;
				loader.height = availableWidth * (1/imageRatio);
				loader.x = gutter;
				loader.y = ((availableHeight - loader.height) / 2) + gutter;
			}
			loader.width = loader.width - (gutter * 2);
			loader.height = loader.height - (gutter * 2);
		}
	}
}
