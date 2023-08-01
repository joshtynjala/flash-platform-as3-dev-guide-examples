package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class ColorMatrixFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:ColorMatrixFilter;
		private var _paramString:String;
		
		private var _matrix:Array;
		
		
		// ------- Constructor -------
		public function ColorMatrixFactory(matrix:Array = null)
		{
			if (matrix == null)
			{
				resetMatrix();
			}
			else
			{
				_matrix = matrix;
			}
			
			_filter = new ColorMatrixFilter(_matrix);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			var result:String = "";
			result += "import flash.filters.ColorMatrixFilter;\n";
			result += "\n";
			
			result += "var matrix:Array = [";
			for (var i:int = 0; i < 20; i++)
			{
				if (i > 0)
				{
					result += ", ";
				}
				if (i % 5 == 0)
				{
					result += "\n\t\t\t";
				}
				result += _matrix[i].toString();
			}
			result += "\n\t\t\t];\n";
			result += "\n";
			
			result += "var colorMatrix:ColorMatrixFilter;\n";
			result += "colorMatrix = new ColorMatrixFilter(matrix);\n";
			result += "\n";
			result += "myDisplayObject.filters = [colorMatrix];";
			
			return result;
		}
		
		
		// ------- Public properties -------
		public function get matrix():Array
		{
			return _matrix;
		}
		
		
		// ------- Public methods -------
		public function modifyFilterBasic(brightness:Number, contrast:Number, saturation:Number, hue:Number):void
		{
			// calculate the combined matrix using the preset values
			resetMatrix();
			setHue(hue);
			setSaturation(saturation);
			setContrast(contrast);
			setBrightness(brightness);
			
			_filter = new ColorMatrixFilter(_matrix);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function modifyFilterCustom(matrix:Array = null):void
		{
			if (matrix == null)
			{
				resetMatrix();
			}
			else
			{
				_matrix = matrix;
			}
			
			_filter = new ColorMatrixFilter(_matrix);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Color adjustments -------
		private function resetMatrix():void
		{
			_matrix = [1, 0, 0, 0, 0,
					   0, 1, 0, 0, 0,
					   0, 0, 1, 0, 0,
					   0, 0, 0, 1, 0];
		}
		
		
		// Color matrix algorithms derived from:
		// Haeberli, Paul (1993) "Matrix Operations for Image Processing."
		// Graphica Obscura: http://www.graficaobscura.com/matrix/index.html
		
		// takes a brightness value between -100 and 100
		private function setBrightness(value:Number):void
		{
			// convert the value to a percentage of 255
			var brightness:Number = (value / 100) * 255;
			
			var matrix:Array =  [1, 0, 0, 0, brightness,
								  0, 1, 0, 0, brightness,
								  0, 0, 1, 0, brightness,
								  0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		
		// takes a contrast value between -100 and 100
		private function setContrast(value:Number):void
		{
			var base:Number = value / 100;
			var multiplier:Number = 1 + ((value > 0) ? 4 * base : base);
			var offset:Number = (-128 * base) * ((value > 0) ? 5 : 1);
			var matrix:Array = [multiplier, 0, 0, 0, offset,
								 0, multiplier, 0, 0, offset,
								 0, 0, multiplier, 0, offset,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		
		// takes a saturation value between -100 and 100
		private function setSaturation(value:Number):void
		{
			var saturation:Number = 1 + ((value > 0) ? 3 * (value / 100) : (value / 100));
			
			// RGB to Luminance conversion constants by Charles A. Poynton:
			// http://www.faqs.org/faqs/graphics/colorspace-faq/
			var rWeight:Number = 0.212671;
			var gWeight:Number = 0.715160;
			var bWeight:Number = 0.072169;
			var baseSat:Number = 1 - saturation;
			var rSat:Number = (baseSat * rWeight) + saturation;
			var r:Number = baseSat * rWeight;
			var gSat:Number = (baseSat * gWeight) + saturation;
			var g:Number = baseSat * gWeight;
			var bSat:Number = (baseSat * bWeight) + saturation;
			var b:Number = baseSat * bWeight;
			
			var matrix:Array = [rSat, g, b, 0, 0,
								 r, gSat, b, 0, 0,
								 r, g, bSat, 0, 0,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		
		// takes a hue value (an angle) between -180 and 180 degrees
		private function setHue(value:Number):void
		{
			var angle:Number = value * Math.PI / 180;
			
			var c:Number = Math.cos(angle);
            var s:Number = Math.sin(angle);
			
            var lumR:Number = 0.213;
            var lumG:Number = 0.715;
            var lumB:Number = 0.072;
			
            var matrix:Array = [lumR + (c * (1 - lumR)) + (s * (-lumR)), lumG + (c * (-lumG)) + (s * (-lumG)), lumB + (c * (-lumB)) + (s * (1 - lumB)), 0, 0,
								 lumR + (c * (-lumR)) + (s * 0.143), lumG + (c * (1 - lumG)) + (s * 0.14), lumB + (c * (-lumB)) + (s * (-0.283)), 0, 0,
								 lumR + (c * (-lumR)) + (s * (-(1 - lumR))), lumG + (c * (-lumG)) + (s * lumG), lumB + (c * (1 - lumB)) + (s * lumB), 0, 0,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		
		// Performs matrix multiplication between two 4x5 matrices
		private static function mMultiply(m1:Array, m2:Array):Array
		{
			var result:Array = new Array(20);
			
			for (var row:int = 0; row < 19; row += 5)
			{
				for (var col:int = 0; col < 5; col++)
				{
					var cell:Number = (m1[row] * m2[col]) + (m1[row + 1] * m2[col + 5]) + (m1[row + 2] * m2[col + 10]) + (m1[row + 3] * m2[col + 15]);
					if (col == 4)
					{
						cell += m1[row + 4];
					}
					result[row + col] = cell;
				}
			}
			
			return result;
		}
	}
}