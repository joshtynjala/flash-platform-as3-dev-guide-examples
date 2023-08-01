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
		protected var padding:Number = 5;
		
		protected var canvas:Sprite;

		public function SampleContainer(w:uint = 550, h:uint = 400, thickness:Number = 1.0, pad:uint = 5) 
		{
			this.w = w;
			this.h = h;
			this.borderThickness = thickness;
			this.padding = padding;
			
			this.canvas = new Sprite(); // could be a SampleComponent if we want an inner border
			this.addChild(canvas);
		}
		
		/**
		 * The init() method should be overridden by component subclasses.
		 */
		public override function init():void 
		{
			draw();
		}
		
		public override function draw():void 
		{
			// draw border and background
			super.draw();
			trace("SampleContainer.draw()");
			
			this.canvas.x = padding;
			this.canvas.y = padding;
			
			// draw internal components
			for (var i:uint = 0; i < this.canvas.numChildren; i++)
			{
				var child:DisplayObject = this.canvas.getChildAt(i);
				trace("child " + i + "=" + flash.util.getQualifiedClassName(child));
				
				try
				{
					SampleComponent(child).draw();
				}
				catch (err:Error)
				{
					trace("Error: " + err.message);
				}
			}
		}
		
		public function addComponent(comp:SampleComponent)
		{
			this.canvas.addChild(comp);
		}
		
		public function removeComponent(comp:SampleComponent)
		{
			this.canvas.removeChild(comp);
		}
	}
}
