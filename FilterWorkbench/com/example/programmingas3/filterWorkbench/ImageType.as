package com.example.programmingas3.filterWorkbench
{
	/**
	 * Combination value object and enumeration class whose values represent 
	 * the types of images that are available to be used as filter targets 
	 * in the FilterWorkbench application.
	 */
	public class ImageType
	{
		public static const IMAGE1:ImageType = new ImageType("Bitmap image 1", "images/sampleImage1.jpg");
		public static const IMAGE2:ImageType = new ImageType("Bitmap image 2", "images/sampleImage2.jpg");
		public static const SWF:ImageType = new ImageType("SWF animation", "images/sampleAnimation.swf");
		
		
		public static function getImageTypes():Array
		{
			return new Array(IMAGE1, IMAGE2, SWF);
		}
		
		// ------- Private vars -------
		private var _name:String;
		private var _url:String;
		
		
		// ------- Constructor -------
		public function ImageType(name:String, url:String)
		{
			_name = name;
			_url = url;
		}
		
		
		// ------- Public properties -------
		public function get name():String
		{
			return _name;
		}
		
		
		public function get url():String
		{
			return _url;
		}
	}
}