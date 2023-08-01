package com.example.programmingas3.asciiArt
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.example.programmingas3.asciiArt.BitmapToAsciiConverter;
	import com.example.programmingas3.asciiArt.Image;
	import com.example.programmingas3.asciiArt.ImageInfo;
	
	/**
	 * Provides appication-level functionality for the AsciiArt sample.
	 */
	public class AsciiArtBuilder extends EventDispatcher
	{
		// ------- Private vars -------

		private const DATA_TARGET:String = "txt/ImageData.txt";
		private var _imageInfoLoader:URLLoader;
		private var _imageStack:Array;
		private var _currentImageIndex:uint;

		
		// ------- Constructor -------

		public function AsciiArtBuilder()
		{
			_imageStack = new Array();
			var request:URLRequest = new URLRequest(DATA_TARGET);
			_imageInfoLoader = new URLLoader();
			_imageInfoLoader.addEventListener(Event.COMPLETE, imageInfoCompleteHandler);
			_imageInfoLoader.load(request);
		}
		
		
		// ------- Public Properties -------

		public static const IMAGE_PATH:String = "image/";
		
		public var asciiArtText:String = "";
		
		public function get currentImage():Image
		{
			return _imageStack[_currentImageIndex];
		}
		
		
		// ------- Event Handlers -------

		/**
		 * Called when the image info text file is loaded.
		 */		
		private function imageInfoCompleteHandler(event:Event):void
		{
			var allImageInfo:Array = parseImageInfo();
			
			buildImageStack(allImageInfo);
		}
		
		
		/**
		 * Called when the first image is loaded.
		 */		
		private function imageCompleteHandler(event:Event):void
		{
			// move to the first image in the stack
			next();
			// notify any listeners that the application has finished its initial loading
			var readyEvent:Event = new Event("ready");
			dispatchEvent(readyEvent);
		}
		
		

		// ------- Public Methods -------
		
		/**
		 * Advances the image stack to the next image, and populates the asciiArtText property
		 * with that image's ASCII Art representation.
		 */
		public function next():void
		{
			// Advance the "current image" index (or set it back to 0 if we're on the last one)
			_currentImageIndex++;
			if (_currentImageIndex == _imageStack.length)
			{
				_currentImageIndex = 0;
			}
			// generate the ASCII version of the new "current" image
			var imageConverter:BitmapToAsciiConverter = new BitmapToAsciiConverter(this.currentImage);
			this.asciiArtText = imageConverter.parseBitmapData();
		}
		
		
		// ------- Private Methods -------

		/**
		 * Parses the contents of the loaded text file which contains information about the images
		 * to load, and creates an Array of ImageInfo instances from that data.
		 * 
		 * @return	An Array of ImageInfo instances.
		 */
		private function parseImageInfo():Array
		{
			var result:Array = new Array();
			
			/* Parse the contents of the text file, and put its contents into an Array of ImageInfo
			* instances.
			* Each line of text contains info about one image, separated by tab (\t) characters,
			* in this order:
			*		- file name
			*		- title
			*		- white threshold
			*		- black threshold
			*
			* Loop through the individual lines in the text file.
			* Note that we skip the first line, since it only contains column headers.
			*/
			var lines:Array = _imageInfoLoader.data.split("\n");
			var numLines:uint = lines.length;
			for (var i:uint = 1; i < numLines; i++)
			{
				var imageInfoRaw:String = lines[i];
				// trim leading or trailing white space from the current line
				imageInfoRaw = imageInfoRaw.replace(/^ *(.*) *$/, "$1");
				if (imageInfoRaw.length > 0)
				{
					// create a new image info record and add it to the array of image info
					var imageInfo:ImageInfo = new ImageInfo();
					// split the current line into values (separated by tab (\t) characters)
					// and extract the individual properties
					var imageProperties:Array = imageInfoRaw.split("\t");
					imageInfo.fileName = imageProperties[0];
					imageInfo.title = normalizeTitle(imageProperties[1]);
					imageInfo.whiteThreshold = parseInt(imageProperties[2], 16);
					imageInfo.blackThreshold = parseInt(imageProperties[3], 16);
					result.push(imageInfo);
				}
			}
			return result;
		}
		
		
		/**
		 * Capitalizes the first letter of each word in a String, unless the word
		 * is one of the English words which are not commonly capitalized
		 * 
		 * @param str	The String to "normalize"
		 * @return 		The String with the words capitalized
		 */
		private function normalizeTitle(title:String):String
		{
			var words:Array = title.split(" ");
			var len:uint = words.length;

			for(var i:uint; i < len; i++)
			{
				words[i] = capitalizeFirstLetter(words[i]);
			}
			
			return words.join(" ");
		}


		
		/**
		 * Capitalizes the first letter of a single word, unless it's one of
		 * a set of words which are normally not capitalized in English.
		 * 
		 * @param word		The word to capitalize
		 * @return 			The capitalized word
		 */
		private function capitalizeFirstLetter(word:String):String
		{
			switch (word)
			{
				case "and":
				case "the":
				case "in":
				case "an":
				case "or":
				case "at":
				case "of":
				case "a":
					// don't do anything to these words
					break;
				default:
					// for any other word, capitalize the first character
					var firstLetter:String = word.substr(0, 1);
					firstLetter = firstLetter.toUpperCase();
					var otherLetters:String = word.substring(1);
					word = firstLetter + otherLetters;
			}

			return word;
		}
		
		
		/**
		 * Using an Array of ImageInfo instances, populates the image stack with Image instances.
		 * 
		 * @param imageInfo		An array of ImageInfo instances, containing the data about the
		 * 						image files to be loaded into the image stack.
		 */
		private function buildImageStack(imageInfo:Array):void
		{
			var image:Image;
			var oneImageInfo:ImageInfo;
			var listenerAdded:Boolean = false;
			var numImages:uint = imageInfo.length;
			for (var i:uint = 0; i < numImages; i++)
			{
				_currentImageIndex = 0;
				oneImageInfo = imageInfo[i];
				image = new Image(oneImageInfo);
				_imageStack.push(image);
				if(!listenerAdded)
				{
					image.addEventListener(Event.COMPLETE, imageCompleteHandler);
					listenerAdded = true;
				}
				image.load();
			}
		}
	}
}