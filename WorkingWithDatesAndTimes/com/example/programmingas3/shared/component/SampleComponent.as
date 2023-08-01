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
		 * The desired width of this component, as opposed to the .width
		 * property which represents tha actual width.
		 */
		public var w:uint = 120;
		
		/**
		 * The desired height of this component, as opposed to the .height
		 * property which represents tha actual height.
		 */
		public var h:uint = 20;
		
		/**
		 * The alpha transparency of the background color.
		 */
		public var backgroundAlpha:Number = 1.0;

		/**
		 * The background fill color.
		 */		
		public var backgroundColor:Number = 0xFFFFFF;
	    
	    /**
	     * The pixel thickness of the border line.
	     */
		public var borderThickness:Number = 1.0;
		
	    /**
	     * The color of the border line.
	     */		
		public var borderColor:Number = 0x000000;
		
	    /**
	     * The alpha transparency of the border line.
	     * A value of 0 will make the border invisible.
	     * This value is set to either 1 or 0 by changing
	     * the showBorder property.
	     */
		private var _borderAlpha:Number = 1.0;
		
	    /**
	     * Shows or hides the border line.
	     * Works by changing the border's alpha transparency value.
	     */
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
		
		/**
		 * Creates a component with a given background and border.
		 */
		public function SampleComponent(bgColor:Number = 0xFFFFFF,
										bgAlpha:Number = 0xFFFFFF,
										borderThickness:Number = 1.0,
										borderColor:Number = 0x000000,
										showBorder:Boolean = true)
		{
			this.backgroundColor = bgColor;
			this.borderThickness = borderThickness;
			this.borderColor = borderColor;
		}
		
		/**
		 * The init() method should be overridden by component subclasses.
		 */
		public function init():void 
		{

		}
		
		/**
		 * Draws a simple border. For more complicated drawing
		 * override this method in a subclass.
		 */
		public function draw():void 
		{
			drawBorder();
		}
		
		/**
		 * Draws a rectangular border along the outside edges of the component
		 * and fills it with the background color.
		 */
		public function drawBorder():void
		{
			// draw the border
			graphics.clear();
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.lineStyle(borderThickness, borderColor, _borderAlpha);
			graphics.drawRect(0, 0, this.w, this.h);
			graphics.endFill();
		}
	}
}
