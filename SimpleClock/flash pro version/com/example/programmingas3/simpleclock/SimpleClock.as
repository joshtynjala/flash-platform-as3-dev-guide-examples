package com.example.programmingas3.clock {

	import flash.display.Sprite;
	
	public class SimpleClock extends Sprite
	{
		import com.example.programmingas3.clock.AnalogClockFace; 
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		/**
		 * The time display component.
		 */
		public var face:AnalogClockFace;
		
		/**
		 * The Timer that acts like a heartbeat for the application.
		 */
		public var ticker:Timer;
		
		public static const millisecondsPerMinute:int = 1000 * 60;
        public static const millisecondsPerHour:int = 1000 * 60 * 60;
        public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		
		/**
		 * Sets up a SimpleClock instance.
		 */
		public function initClock(faceSize:Number = 200):void 
		{
		    // sets the invoice date to today’s date
            var invoiceDate:Date = new Date();
            
            // adds 30 days to get the due date
            var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
            var dueDate:Date = new Date(invoiceDate.getTime() + (30 * millisecondsPerDay));

            var oneHourFromNow:Date = new Date(); // starts at the current time
		    oneHourFromNow.setTime(oneHourFromNow.getTime() + millisecondsPerHour);
		    
			// Creates the clock face and adds it to the Display List
			face = new AnalogClockFace(Math.max(20, faceSize));
			face.init();
			addChild(face);
			
			// Draws the initial clock display
			face.draw();

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
            face.draw();
        }		
	}
}