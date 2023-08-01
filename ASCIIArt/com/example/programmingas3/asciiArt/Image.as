package com.example.programmingas3.asciiArt
{
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import com.example.programmingas3.asciiArt.AsciiArtBuilder;

	/**
	 * Represents a loadable image and metadata about that image.
	 */
	public class Image extends EventDispatcher
	{
		// ------- Private vars -------

		private var _loader:Loader;

		
		//
		// ------- Constructor -------
		//
		public function Image(imageInfo:ImageInfo)
		{
			this.info = imageInfo;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		
		// ------- Public Properties -------

		public var info:ImageInfo;
		
		
		// ------- Public Methods -------

 		public function getBitmapData():BitmapData
		{
			return Bitmap(_loader.content).bitmapData;
		}
		
		
 		/**
 		 * Loads the image file associated with this instance.
 		 */
 		public function load():void
		{
			var request:URLRequest = new URLRequest(AsciiArtBuilder.IMAGE_PATH + info.fileName);
			_loader.load(request);
		}
 		
 		
  		// ------- Event Handling -------

		/**
		 * Called when the image associated with this instance has completely loaded. In essence
		 * it passes the event along to any listeners which have subscribed with this instance.
		 */
		private function completeHandler(event:Event):void
		{
			dispatchEvent(event);
		}
	}
}