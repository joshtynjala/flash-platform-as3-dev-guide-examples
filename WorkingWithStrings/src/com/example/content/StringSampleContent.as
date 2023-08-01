package com.example.content {
	import com.example.display.SampleComponent;
	import com.example.data.ASCIIData;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.util.trace;
	import flash.util.setInterval;
	import flash.events.EventType;
	import com.example.content.Image;
	import com.example.data.ASCIIRecord;
	import com.example.data.Iterable;
	import com.example.content.ASCIIPrinter;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class StringSampleContent extends SampleComponent {
		private const dataTarget:String = "txt/ImageData.txt";
		private var data:ASCIIData;
		private var iterator:Iterable;
		private var imageStack:ImageStack;
		private var printer:ASCIIPrinter;
		private var currentImage:Image;
		private var bitmap:BitmapData;
		private var title:SampleLabel;
		private var titleHeight:uint = 30;

		public function StringSampleContent() {
		}
		
		protected override function init():void {
			gutter = 5;
			imageStack = new ImageStack();
			var request:URLRequest = new URLRequest(dataTarget);
			data = new ASCIIData();
			data.addEventListener(Event.COMPLETE, completeHandler);
			data.load(request);

			printer = new ASCIIPrinter();
			addChild(printer);
			
			title = new SampleLabel();
			addChild(title);
		}
		
		private function completeHandler(event:Event):void {
			configureAssets();
		}
		
		private function imageCompleteHandler(event:Event):void {
			next();
			setInterval(next, 1500);
		}
		
		private function configureAssets():void {
			var image:Image;
			var record:ASCIIRecord;
			var itr:Iterable = data.getIterator();
			var runOnce:Boolean;
			while(itr.hasNext()) {
				record = ASCIIRecord(itr.next());
				image = getImage(record.getFileName());
				imageStack.addChild(image);
				if(!runOnce) {
					image.addEventListener(Event.COMPLETE, imageCompleteHandler);
					runOnce = true;
				}
			}
			addChild(imageStack);
			iterator = data.getIterator();
		}
		
		public function next():Object {
			if(!iterator.hasNext()) {
				iterator = data.getIterator();
			}
			var record:ASCIIRecord = ASCIIRecord(iterator.next());
			title.setLabel(record.getTitle());
			currentImage = Image(imageStack.next());
			printer.setBitmapData(currentImage.getBitmapData(), record.getWhiteThreshold(), record.getBlackThreshold());
			return null;
		}
		
		private function getImage(fileName:String):Image {
			var image:Image = new Image();
			var request:URLRequest = new URLRequest("img/" + fileName);
			image.load(request);
			return image;
		}
		
		public override function draw():void {
			var contentHeight:Number = getHeight() - titleHeight - gutter;
			
			imageStack.setWidth((getWidth() / 2) - gutter);
			imageStack.setHeight(contentHeight);
			imageStack.draw();

			printer.setX(imageStack.getWidth() + imageStack.getX() + gutter);
			printer.setWidth((getWidth() / 2));
			printer.setHeight(contentHeight);
			printer.draw();

			title.setY(printer.getHeight() + gutter);
			title.setWidth(getWidth());
			title.setHeight(titleHeight);
			title.draw();
		}
	}
}
