package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.ColorStringFormatter;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class GlowFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:GlowFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function GlowFactory(color:uint = 0xFF0000,
									  alpha:Number = 1,
									  blurX:Number = 6,
									  blurY:Number = 6,
									  strength:Number = 2,
									  quality:int = 1,
									  inner:Boolean = false,
									  knockout:Boolean = false)
		{
			_filter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			_paramString = buildParamString(color, alpha, blurX, blurY, strength, quality, inner, knockout);
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
			result += "import flash.filters.GlowFilter;\n";
			result += "\n";
			result += "var glow:GlowFilter;\n";
			result += "glow = new GlowFilter(" + _paramString + ");\n";
			result += "\n";
			result += "myDisplayObject.filters = [glow];";
			return result;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(color:uint = 0xFF0000,
									   alpha:Number = 1,
									   blurX:Number = 6,
									   blurY:Number = 6,
									   strength:Number = 2,
									   quality:int = 1,
									   inner:Boolean = false,
									   knockout:Boolean = false):void
		{
			_filter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			_paramString = buildParamString(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function buildParamString(color:uint,
											alpha:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											inner:Boolean,
											knockout:Boolean):String
		{
			var result:String = "\n\t\t" + ColorStringFormatter.formatColorHex24(color) + ",\n\t\t" + alpha.toString() + ",\n\t\t";
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
			
			result += inner.toString() + ",\n\t\t" + knockout.toString();
			
			return result;
		}
	}
}