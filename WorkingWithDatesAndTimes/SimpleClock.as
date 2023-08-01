package 
{
	import com.example.programmingas3.clock.AnalogClockFace;
	import com.example.programmingas3.shared.component.SampleContainer;
	
	import flash.events.TimerEvent;
	import flash.util.Timer;
	import flash.util.trace;

	public class SimpleClock extends SampleContainer 
	{
		/**
		 * The time display component.
		 */
		public var face:AnalogClockFace;
		
		/**
		 * The Timer that acts like a heartbeat for the application.
		 */
		public var ticker:Timer;
		
		/**
		 * Instantiates a new SimpleClock of a given size, border
		 * thickness, and container padding.
		 * The constructor uses default parameter values to set 
		 * application size, border thickness, and container padding. 
		 * This application could also be instantiated by another
		 * application with different parameter values if desired.
		 */
		public function SimpleClock(w:uint = 210, 
									h:uint = 210, 
									thickness:Number = 0.0, 
									pad:uint = 5) 
		{
			super(w, h, thickness, pad);
			
			// Creates the clock display.
			face = new AnalogClockFace(Math.max(20, w - pad - pad));
			face.init();
			addComponent(face);
			
			init();
		}
		
				
		public override function init():void
		{
			this.showBorder = false;
			this.backgroundAlpha = 0;
			
			// Draws the initial clock display
			draw();

			// Creates a Timer that fires an event once per second.
        	ticker = new Timer(1000); 
        	
        	// Designates the onTick() method to handle Timer events
            ticker.addEventListener(TimerEvent.TIMER, onTick);
            
            // Starts the clock ticking
            ticker.start();
        }

		/**
		 * Called once per second when the Timer event is received.
		 */
        public function onTick(evt:TimerEvent):void 
        {
        	// Updates the clock display.
            draw();
        }
	}
}