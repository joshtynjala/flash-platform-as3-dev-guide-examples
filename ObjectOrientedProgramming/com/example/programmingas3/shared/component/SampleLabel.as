package com.example.programmingas3.shared.component
{
	import com.example.display.SampleTextField;
	
	import flash.text.TextFormat;
	
	/**
	 * A simple label component with no background or border.
	 */
	public class SampleLabel extends SampleTextField 
	{
		public function SampleLabel(w:uint, h:uint, textFormat:TextFormat = null) 
		{
			// creates a nonselectable field
			super(w, h, textFormat, false);
			
			// suppresses the border
			this.showBorder = false;

			// suppresses the background
			this.backgroundAlpha = 0x000000;
			
			this.init();
		}
		
		public override function init():void 
		{
			super.init();
			
			this.draw();
		}
		
		private function getTextFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = false;
			format.align = "right";
			return format;
		}
	}
}