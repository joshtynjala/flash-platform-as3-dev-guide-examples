package com.example.programmingas3.newslayout 
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.text.TextLineMetrics;
	import flash.text.TextField;

	/**
	 * Changes the size of the text to fit a given width and number of lines.
	 * Useful for news headlines that should extend across a full column.
	 *
	 * We need to know:
	 * - which font family, weight, and style to use
	 * - the max width of the headline
	 * - the max height in pixels of the headline
	 * - the max number of lines
	 * 
	 * Algorithm 1:
	 * - figure out the N-width of a character that should work based on pixelWidth / numChars
	 * - translate that N-width into a point size
	 * - try the point size, if outside of tolerance,; 
	 *   - if too wide, adjust down a point, try again
	 *   - if too small, adjust up a point, try again
	 *   - if too wide last time, too small this time or vice versa, stick with the too small size
	 * 
	 * Pixels per character (width-wise) is roughly 1/2 the point size, so that's a good starting
	 * point. So to get a starting point size, divide the overall width by the number of characters
	 * to get pixels-per-character, then double to get the point size.
	 */
	public class HeadlineTextField extends FormattedTextField
	{

		public static var MIN_POINT_SIZE:uint = 6;
		public static var MAX_POINT_SIZE:uint = 128;
		
		public function HeadlineTextField(tf:TextFormat = null) 
		{
			super(tf);
			this.autoSize = TextFieldAutoSize.LEFT;
		}
				
		public function fitText(msg:String, maxLines:uint = 1, toUpper:Boolean = false, targetWidth:Number = -1):uint
		{
			this.text = toUpper ? msg.toUpperCase() : msg;
			
			if (targetWidth == -1)
			{
				targetWidth = this.width;
			}
			
			var pixelsPerChar:Number = targetWidth / msg.length;
			
			var pointSize:Number = Math.min(MAX_POINT_SIZE, Math.round(pixelsPerChar * 1.8 * maxLines));
			
			if (pointSize < 6)
			{
				// the point size is too small
				return pointSize;
			}
			
			this.changeSize(pointSize);
			
			if (this.numLines > maxLines)
			{
				return shrinkText(--pointSize, maxLines);
			}
			else
			{
				return growText(pointSize, maxLines);
			}
		}
		
		public function growText(pointSize:Number, maxLines:uint = 1):Number
		{
			if (pointSize >= MAX_POINT_SIZE)
			{
				return pointSize;
			}
			
			this.changeSize(pointSize + 1);
			
			if (this.numLines > maxLines)
			{
				// set it back to the last size
				this.changeSize(pointSize);
				return pointSize;
			}
			else
			{
				return growText(pointSize + 1, maxLines);
			}
		}
		
		public function shrinkText(pointSize:Number, maxLines:uint=1):Number
		{
			if (pointSize <= MIN_POINT_SIZE)
			{
				return pointSize;
			}
			
			this.changeSize(pointSize);
			
			if (this.numLines > maxLines)
			{
				return shrinkText(pointSize - 1, maxLines);
			}
			else
			{
				return pointSize;
			}
		}
	}
}