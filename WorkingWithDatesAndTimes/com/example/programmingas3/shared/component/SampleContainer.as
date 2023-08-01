package com.example.programmingas3.shared.component 
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import flash.util.trace;
	
	/**
	 * A SampleContainer maintains a padding area around its contents.
	 * It also provides specialized methods for managing SampleComponents
	 * in the display list of its own Sprite canvas.
	 * 
	 * Components added using the addComponent() method will be arranged
	 * according to the layout rules for this container. (DisplayObjects
	 * that are added using the standard addChild() method will not be
	 * subject to the layout rules).
	 */
	public class SampleContainer extends SampleComponent
	{
		/**
		 * The display object that holds all of this container's
		 * child components.
		 */
		protected var canvas:Sprite;
		
		/**
		 * The number of pixels or padding around the outer edge of the component.
		 * This container's canvas will be made this many pixels smaller in 
		 * each direction.
		 */
		protected var padding:Number = 5;
		
		/**
		 * Creates a container component with a given size, border thickness, and padding.
		 */
		public function SampleContainer(w:uint = 550, h:uint = 400, thickness:Number = 1.0, pad:uint = 5) 
		{
			this.w = w;
			this.h = h;
			this.borderThickness = thickness;
			this.padding = padding;
			
			// Creates an internal drawing area
			this.canvas = new Sprite(); // could be a SampleComponent if we want an inner border
			this.addChild(canvas);
		}
		
		/**
		 * The init() method should be overridden by component subclasses.
		 */
		public override function init():void 
		{
			// Draws the container and its components once at the start
			draw();
		}
		
		public override function draw():void 
		{
			// Draws the border and background
			super.draw();
			trace("SampleContainer.draw()");
			
			this.canvas.x = padding;
			this.canvas.y = padding;
			
			// Draws the internal components.
			for (var i:uint = 0; i < this.canvas.numChildren; i++)
			{
				var child:DisplayObject = this.canvas.getChildAt(i);
				trace("child " + i + "=" + flash.util.getQualifiedClassName(child));
				
				try
				{
					// Draws each component in the list
					SampleComponent(child).draw();
				}
				catch (err:Error)
				{
					// Catches errors if the child can't be cast to a SampleComponent instance
					// This isn't a show-stopper, so we don't have to stop running.
					trace("Error: " + err.message);
				}
			}
		}
		
		/**
		 * Adds a child component to the display list of the canvas object.
		 */
		public function addComponent(comp:SampleComponent)
		{
			this.canvas.addChild(comp);
		}
		
		/**
		 * Removes a child component from the display list of the canvas object.
		 */		
		public function removeComponent(comp:SampleComponent)
		{
			this.canvas.removeChild(comp);
		}
	}
}
