package com.example.programmingas3.moon
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;   
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class MoonSphere extends Sprite 
	{
		// The Bitmap containing the moon map that's actually displayed on the screen.
		private var sphere:Bitmap;
		
		// The moon map "source" -- pixels from this map are copied onto sphere
		// to create the animated motion of the moon.
		private var textureMap:BitmapData;
		
		// The radius of the moon.
		private var radius:int;
		
		// The current x position on textureMap from which the pixels are copied onto sphere.
		private var sourceX:int = 0;
		
		// MoonSphere constructor
		// Starts loading the moon image.
		public function MoonSphere() 
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
			imageLoader.load(new URLRequest("moonMap.png"));
		}
		
		// Movement (a'la rotation) routine
		private function rotateMoon(event:TimerEvent):void
		{
			sourceX += 1;
			if (sourceX >= textureMap.width / 2)
			{
				sourceX = 0;
			}
			
			sphere.bitmapData.copyPixels(textureMap,
												  new Rectangle(sourceX, 0, sphere.width, sphere.height),
												  new Point(0, 0));
			
			event.updateAfterEvent();
		}
		
		// Creates the displacement map image that's used to create the fisheye lens effect
		private function createFisheyeMap(radius:int):BitmapData
		{
			var diameter:int = 2 * radius;
			
			var result:BitmapData = new BitmapData(diameter,
																diameter,
																false,
																0x808080);
			
			// Loop through the pixels in the image one by one
			for (var i:int = 0; i < diameter; i++)
			{
				for (var j:int = 0; j < diameter; j++)
				{
					// Calculate the x and y distances of this pixel from
					// the center of the circle (as a percentage of the radius).
					var pctX:Number = (i - radius) / radius;
					var pctY:Number = (j - radius) / radius;
					
					// Calculate the linear distance of this pixel from
					// the center of the circle (as a percentage of the radius).
					var pctDistance:Number = Math.sqrt(pctX * pctX + pctY * pctY);
					
					// If the current pixel is inside the circle,
					// set its color.
					if (pctDistance < 1)
					{
						// Calculate the appropriate color depending on the
						// distance of this pixel from the center of the circle.
						var red:int;
						var green:int;
						var blue:int;
						var rgb:uint;
						red = 128 * (1 + 0.75 * pctX * pctX * pctX / (1 - pctY * pctY));
						green = 0;
						blue = 0;
						rgb = (red << 16 | green << 8 | blue);
						// Set the pixel to the calculated color.
						result.setPixel(i, j, rgb);
					}
				}
			}
			return result;
		}
		
		// Called when the moon map image finishes loading.
		// Sets up the on-screen elements (moon image with fisheye filter and its mask);
		// starts the Timer that creates the animation effect.
		private function imageLoadComplete(event:Event):void
		{
			textureMap = event.target.content.bitmapData;
			radius = textureMap.height / 2;
			
			sphere = new Bitmap();
			sphere.bitmapData = new BitmapData(textureMap.width / 2, textureMap.height);
			sphere.bitmapData.copyPixels(textureMap,
												  new Rectangle(0, 0, sphere.width, sphere.height),
												  new Point(0, 0));

			// Create the BitmapData instance that's used as the displacement map image
			// to create the fisheye lens effect.
			var fisheyeLens:BitmapData = createFisheyeMap(radius);
			
			// Create the fisheye filter
			var displaceFilter:DisplacementMapFilter;
			displaceFilter = new DisplacementMapFilter(fisheyeLens,
																	 new Point(radius, 0), 
																	 BitmapDataChannel.RED,
																	 BitmapDataChannel.BLUE,
																	 radius, 0);
			
			// Apply the filter
			sphere.filters = [displaceFilter];

			this.addChild(sphere);        
	
			// Create and apply the image mask
			var moonMask:Shape = new Shape();
			moonMask.graphics.beginFill(0);
			moonMask.graphics.drawCircle(radius * 2, radius, radius);
			this.addChild(moonMask);
			this.mask = moonMask;
			
			// Set up the timer to start the animation that 'spins' the moon
			var rotationTimer:Timer = new Timer(15);
			rotationTimer.addEventListener(TimerEvent.TIMER, rotateMoon);
			rotationTimer.start();
			
			// add a slight atmospheric glow effect
			this.filters = [new GlowFilter(0xC2C2C2, .75, 20, 20, 2, BitmapFilterQuality.HIGH, true)];
			
			dispatchEvent(event);
		}
	}
}