package com.example.programmingas3.shared.component
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.util.trace;

	/**
	 * Defines a simple component base class, with a background color and an optional border.
	 */
	public class SampleComponent extends Sprite 
	{
		/**
		 * The desired width of this componenet, as opposed to the .width
		 * property which represents tha actual width.
		 */
		public var w:uint = 120;
		
		/**
		 * The desired height of this componenet, as opposed to the .height
		 * property which represents tha actual height.
		 */
		public var h:uint = 20;
		
		// policy: do away with getters and setters, unless they add some value - 
		// like validating inputs, or triggering side effects?
		
		public var backgroundAlpha:Number = 1.0;
		
		public var backgroundColor:Number = 0xFFFFFF;
				
		public var borderThickness:Number = 0.5;
		
		public var borderColor:Number = 0x000000;
		
		private var _borderAlpha:Number = 1.0;
		private var _showBorder:Boolean = true;
		public function get showBorder():Boolean
		{
			return this._showBorder;
		}
		public function set showBorder(bool:Boolean)
		{
			this._showBorder = bool;
			this._borderAlpha = bool ? 1 : 0;
		}
		
		public function SampleComponent(bgColor:Number = 0xFFFFFF,
										bgAlpha:Number = 0xFFFFFF,
										borderThickness:Number = 1.0,
										borderColor:Number = 0x000000,
										showBorder:Boolean = true)
		{
			this.backgroundColor = bgColor;
			this.borderThickness = borderThickness;
			this.borderColor = borderColor;
			
			//init();
		}
		
		/**
		 * The init() method should be overridden by component subclasses.
		 */
		public function init():void 
		{

		}
		
		public function draw():void 
		{
			trace("SampleComponent.draw()");
			
			// draw the border
			graphics.clear();
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.lineStyle(borderThickness, borderColor, _borderAlpha);
			graphics.drawRect(0, 0, this.w, this.h);
			graphics.endFill(); // optional
		}
	}
}
