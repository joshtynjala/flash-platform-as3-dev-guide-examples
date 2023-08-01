package com.example.programmingas3.filterWorkbench
{
	public class GradientColor
	{
		// ------- Private vars -------
		private var _color:uint;
		private var _alpha:Number;
		private var _ratio:Number;
		
		// ------- Constructor -------
		public function GradientColor(color:uint, alpha:Number, ratio:Number)
		{
			_color = color;
			_alpha = alpha;
			_ratio = ratio;
		}
		
		
		// ------- Public properties -------
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		
		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		
		public function get ratio():Number
		{
			return _ratio;
		}
		public function set ratio(value:Number):void
		{
			_ratio = value;
		}
	}
}