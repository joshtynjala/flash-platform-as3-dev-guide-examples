package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.ColorStringFormatter;
	import com.example.programmingas3.filterWorkbench.GradientColor;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.GradientBevelFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class GradientBevelFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:GradientBevelFilter;
		private var _paramString:String;
		private var _colorsString:String;
		private var _alphasString:String;
		private var _ratiosString:String;
		
		
		// ------- Constructor -------
		public function GradientBevelFactory(distance:Number = 4,
											   angle:Number = 45,
											   combinedColors:Array = null,
											   blurX:Number = 4,
											   blurY:Number = 4,
											   strength:Number = 1,
											   quality:int = 1,
											   type:String = "inner",
											   knockout:Boolean = false)
		{
			if (combinedColors == null)
			{
				combinedColors = getDefaultColors();
			}
			var colors:Array = new Array(combinedColors.length);
			var alphas:Array = new Array(combinedColors.length);
			var ratios:Array = new Array(combinedColors.length);
			
			separateColorParts(combinedColors, colors, alphas, ratios);
			
			_filter = new GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, blurX, blurY, strength, quality, type, knockout);
			_colorsString = buildArrayString(colors, true);
			_alphasString = buildArrayString(alphas);
			_ratiosString = buildArrayString(ratios);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			var result:String = "";
			result += "import flash.filters.BitmapFilterQuality;\n";
			result += "import flash.filters.BitmapFilterType;\n";
			result += "import flash.filters.GradientBevelFilter;\n";
			result += "\n";
			result += "var colors:Array = [" + _colorsString + "];\n";
			result += "var alphas:Array = [" + _alphasString + "];\n";
			result += "var ratios:Array = [" + _ratiosString + "];\n";
			result += "\n";
			result += "var gradientBevel:GradientBevelFilter;\n";
			result += "gradientBevel = new GradientBevelFilter(" + _paramString + ");\n";
			result += "\n";
			result += "myDisplayObject.filters = [gradientBevel];";
			return result;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(distance:Number = 4,
									   angle:Number = 45,
									   combinedColors:Array = null,
									   blurX:Number = 4,
									   blurY:Number = 4,
									   strength:Number = 1,
									   quality:int = 1,
									   type:String = "inner",
									   knockout:Boolean = false):void
		{
			if (combinedColors == null)
			{
				combinedColors = getDefaultColors();
			}
			var colors:Array = new Array(combinedColors.length);
			var alphas:Array = new Array(combinedColors.length);
			var ratios:Array = new Array(combinedColors.length);
			
			separateColorParts(combinedColors, colors, alphas, ratios);
			
			_filter = new GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, blurX, blurY, strength, quality, type, knockout);
			_colorsString = buildArrayString(colors, true);
			_alphasString = buildArrayString(alphas);
			_ratiosString = buildArrayString(ratios);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function getDefaultColors():Array
		{
			return [new GradientColor(0xFFFFFF, 1, 0),
					 new GradientColor(0xFF0000, .25, 128),
					 new GradientColor(0x000000, 1, 255)];
		}
		
		
		// takeas an array of GradientColor objects and splits it into three arrays of colors, alphas, and ratios
		// the destination arrays must be instantiated and sized before calling this method.
		private function separateColorParts(source:Array, colorsDest:Array, alphasDest:Array, ratiosDest:Array):void
		{
			var numColors:int = source.length;
			
			for (var i:int = 0; i < numColors; i++)
			{
				var gradientColor:GradientColor = source[i];
				
				colorsDest[i] = gradientColor.color;
				alphasDest[i] = gradientColor.alpha;
				ratiosDest[i] = gradientColor.ratio;
			}
		}
		
		
		private function buildParamString(distance:Number,
											angle:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											type:String,
											knockout:Boolean):String
		{
			var result:String = "\n\t\t" + distance.toString() + ",\n\t\t" + angle.toString() + ",\n\t\t";
			result += "colors, alphas, ratios,\n\t\t";
			result += blurX.toString() + ",\n\t\t" + blurY.toString() + ",\n\t\t" + strength.toString() + ",\n\t\t";
			
			switch (quality)
			{
				case 1:
					result += "BitmapFilterQuality.LOW";
					break;
				case 2:
					result += "BitmapFilterQuality.MEDIUM";
					break;
				case 3:
					result += "BitmapFilterQuality.HIGH";
					break;
			}
			
			result += ",\n\t\t";
			
			switch (type)
			{
				case "inner":
					result += "BitmapFilterType.INNER";
					break;
				case "outer":
					result += "BitmapFilterType.OUTER";
					break;
				case "full":
					result += "BitmapFilterType.FULL";
					break;
			}
			
			result += ",\n\t\t" + knockout.toString();
			
			return result;
		}
		
		
		private function buildArrayString(arr:Array, formatColor:Boolean = false):String
		{
			var len:int = arr.length;
			var result:String = "";
			
			for (var i:int = 0; i < len; i++)
			{
				if (i != 0)
				{
					result += ", ";
				}
				if (formatColor)
				{
					result += ColorStringFormatter.formatColorHex24(arr[i]);
				}
				else
				{
					result += arr[i].toString();
				}
			}
			
			return result;
		}
	}
}