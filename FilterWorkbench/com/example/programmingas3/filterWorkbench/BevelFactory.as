package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.ColorStringFormatter;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.BevelFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class BevelFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:BevelFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function BevelFactory(distance:Number = 4,
									   angle:Number = 45,
									   highlightColor:uint = 0xFFFFFF,
									   highlightAlpha:Number = 1,
									   shadowColor:uint = 0x000000,
									   shadowAlpha:Number = 1,
									   blurX:Number = 4,
									   blurY:Number = 4,
									   strength:Number = 1,
									   quality:int = 1,
									   type:String = "inner",
									   knockout:Boolean = false)
		{
			_filter = new BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			var result:String = "";
			result += "import flash.filters.BevelFilter;\n";
			result += "import flash.filters.BitmapFilterQuality;\n";
			result += "import flash.filters.BitmapFilterType;\n";
			result += "\n";
			result += "var bevel:BevelFilter;\n";
			result += "bevel = new BevelFilter(" + _paramString + ");\n";
			result += "\n";
			result += "myDisplayObject.filters = [bevel];";
			return result;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(distance:Number = 4,
									   angle:Number = 45,
									   highlightColor:uint = 0xFFFFFF,
									   highlightAlpha:Number = 1,
									   shadowColor:uint = 0x000000,
									   shadowAlpha:Number = 1,
									   blurX:Number = 4,
									   blurY:Number = 4,
									   strength:Number = 1,
									   quality:int = 1,
									   type:String = "inner",
									   knockout:Boolean = false):void
		{
			_filter = new BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function buildParamString(distance:Number,
											angle:Number,
											highlightColor:uint,
											highlightAlpha:Number,
											shadowColor:uint,
											shadowAlpha:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											type:String,
											knockout:Boolean):String
		{
			var result:String = distance.toString() + ",\n\t\t" + angle.toString() + ",\n\t\t";
			result += ColorStringFormatter.formatColorHex24(highlightColor) + ",\n\t\t" + highlightAlpha.toString() + ",\n\t\t";
			result += ColorStringFormatter.formatColorHex24(shadowColor) + ",\n\t\t" + shadowAlpha.toString() + ",\n\t\t";
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
	}
}