package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class BlurFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:BlurFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function BlurFactory(blurX:Number = 4, blurY:Number = 4, quality:int = 1)
		{
			_filter = new BlurFilter(blurX, blurY, quality);
			_paramString = buildParamString(blurX, blurY, quality);
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
			result += "import flash.filters.BlurFilter;\n";
			result += "\n";
			result += "var blur:BlurFilter;\n";
			result += "blur = new BlurFilter(" + _paramString + ");\n";
			result += "\n";
			result += "myDisplayObject.filters = [blur];";
			return result;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(blurX:Number = 4, 
									   blurY:Number = 4, 
									   quality:int = 1):void
		{
			_filter = new BlurFilter(blurX, blurY, quality);
			_paramString = buildParamString(blurX, blurY, quality);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function buildParamString(blurX:Number, blurY:Number, quality:int):String
		{
			var result:String = "\n\t\t\t" + blurX.toString() + ",\n\t\t\t" + blurY.toString() + ",\n\t\t\t";
			
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
			
			return result;
		}
	}
}