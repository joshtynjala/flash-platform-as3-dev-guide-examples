package com.example.programmingas3.filterWorkbench
{
	public class ColorStringFormatter
	{
		public static function formatColorHex24(color:uint):String
		{
			var r:String = ((color >> 16) & 0xFF).toString(16);
			r = (r.length > 1) ? r : "0" + r;
			var g:String = ((color >> 8) & 0xFF).toString(16);
			g = (g.length > 1) ? g : "0" + g;
			var b:String = (color & 0xFF).toString(16);
			b = (b.length > 1) ? b : "0" + b;
			return "0x" + r.toUpperCase() + g.toUpperCase() + b.toUpperCase();
		}
	}
}