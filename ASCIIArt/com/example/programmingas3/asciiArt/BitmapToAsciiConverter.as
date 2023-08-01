package com.example.programmingas3.asciiArt
{
	import flash.display.BitmapData;

	/*
	 * Provides functionality for converting a bitmap image to an "ASCII Art" representation
	 * of that image.
	 */
	public class BitmapToAsciiConverter
	{
		// ------- Private vars -------

		private static const _resolution:Number = .025;
		private var _data:BitmapData;
		private var _whiteThreshold:Number;
		private var _blackThreshold:Number;
		
		/* The characters in this string become increasingly darker.
		* This set of characters are the "grayscale values" which are used to create the image.
		* There are 64 characters, meaning each character is used to represent four values in a common
		* 256-value grayscale color palette (which has color values in the 0-255 range).
		* The characters are in order from darkest to lightest, so that their position (index)
		*  in the string corresponds to a relative color value (with 0 = black).
		*/
		private static const palette:String = "@#$%&8BMW*mwqpdbkhaoQ0OZXYUJCLtfjzxnuvcr[]{}1()|/?Il!i><+_~-;,. ";


		// ------- Constructor -------

		public function BitmapToAsciiConverter(image:Image)
		{
			this._data = image.getBitmapData();
			this._whiteThreshold = image.info.whiteThreshold;
			this._blackThreshold = image.info.blackThreshold;
		}


		// ------- Public Methods -------

		/*
		 * Parses the bitmap data associated with this instance and converts it to its "ASCII Art"
		 * (String) representation.
		 * @return		The String representation of the bitmap image.
		 */
		public function parseBitmapData():String
		{
			var rgbVal:uint;
			var redVal:uint;
			var greenVal:uint;
			var blueVal:uint;
			var grayVal:uint;
			var index:uint;
			
			/* 
			* Determine the "resolution" (dimensions) of the resulting "image" (the number
			* of rows of text, and the number of characters per row):
			*/
			var verticalResolution:uint = Math.floor(_data.height * _resolution); 
			/* 
			* Since the "pixels" (characters) aren't square, multiply by 0.45 to maintain the
			* scale of the original image:
			*/
			var horizontalResolution:uint = Math.floor(_data.width * _resolution * 0.45);
			
			var result:String = "";
			
			// Loop through the rows of pixels top to bottom:
			for (var y:uint = 0; y < _data.height; y += verticalResolution)
			{
				// Eithin each row, loop through the individual pixels left to right:
				for (var x:uint = 0; x < _data.width; x += horizontalResolution)
				{
					// Extract individual red, green, and blue values for the pixel:
					rgbVal = _data.getPixel(x, y);
					redVal = (rgbVal & 0xFF0000) >> 16;
					greenVal = (rgbVal & 0x00FF00) >> 8;
					blueVal = rgbVal & 0x0000FF;

					/* 
					* Calculate the gray value of the pixel.
					* The formula for grayscale conversion: (Y = gray): Y = 0.3*R + 0.59*G + 0.11*B
					*/
					grayVal = Math.floor(0.3 * redVal + 0.59 * greenVal + 0.11 * blueVal);

					/* 
					* The white threshold and black threshold values (read from the "images.txt" file)
					* determine the grayscale values that are the cut-off limits for white and black.
					* Values outside the threshold will be "rounded" to pure white or black.
					*/
					if (grayVal > _whiteThreshold)
					{
						grayVal = 0xFF;
					}
					else if (grayVal < _blackThreshold)
					{
						grayVal = 0x00;
					}
					else
					{
						/* Normalize the grayscale value along the relative scale between the white threshold
						* and the black threshold. In other words, adjust the palette so that
						* the black threshold acts as the "0x00" value and the white threshold acts as the "0xFF" value,
						* then determine where the gray value falls along that scale:
						*/
						grayVal = Math.floor(0xFF * ((grayVal - _blackThreshold) / (_whiteThreshold - _blackThreshold)));
					}
					/* The value is now a gray value in the 0-255 range, which needs to be converted
					* to a value in the 0-64 range (since that's the number of available "shades of gray"
					* in the set of available characters):
					*/
					index = Math.floor(grayVal / 4);
					result += palette.charAt(index);
				}
				result += "\n";
			}
			return result;
		}
	}
}