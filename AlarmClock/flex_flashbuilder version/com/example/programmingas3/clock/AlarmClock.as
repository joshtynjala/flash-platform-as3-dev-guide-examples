package com.example.programmingas3.clock
{
	public class AlarmClock extends SimpleClock 
	{
		import com.example.programmingas3.clock.AnalogClockFace; 
		import flash.events.TimerEvent;
		import flash.utils.Timer;
			
		public var alarmTime:Date;
		
		public var alarmMessage:String;
		
		/**
		 * The Timer that will be used for the alarm.
		 */
		public var alarmTimer:Timer;
		
		public static var MILLISECONDS_PER_DAY:Number = 1000 * 60 * 60 * 24;
		
		/**
		 * Instantiates a new AlarmClock of a given size
		 */
		public override function initClock(faceSize:Number = 200):void
		{
			super.initClock(faceSize);

			alarmTimer = new Timer(0, 1);
        	alarmTimer.addEventListener(TimerEvent.TIMER, onAlarm);
        }


        /**
         * Sets the time at which the alarm should go off.
         * @param hour		The hour portion of the alarm time
         * @param minutes	The minutes portion of the alarm time
         * @param message	The message to display when the alarm goes off.
         * @return The time at which the alarm will go off.
         */
        public function setAlarm(hour:Number = 0, minutes:Number = 0, message:String = "Alarm!"):Date
        {
        	this.alarmMessage = message;
        	
         	var now:Date = new Date();
        	
        	// create this time on today's date
        	alarmTime = new Date(now.fullYear, now.month, now.date, hour, minutes);
        	
        	// determine if the specified time has already passed today
        	if (alarmTime <= now)
        	{
        		alarmTime.setTime(alarmTime.time + MILLISECONDS_PER_DAY);
        	}
        	
        	// reset the alarm timer if it's currently set
        	alarmTimer.reset();
			// calculate how many milliseconds should pass before the alarm should
			// go off (the difference between the alarm time and now) and set that
			// value as the delay for the alarm timer
			alarmTimer.delay = Math.max(1000, alarmTime.time - now.time);
			alarmTimer.start();
        	
			return alarmTime;
        }


		/**
		 * Called when the Timer event is received
		 */
		public function onAlarm(event:TimerEvent):void 
		{
			trace("Alarm!");
			var alarm:AlarmEvent = new AlarmEvent(this.alarmMessage);
			this.dispatchEvent(alarm);
		}
	}
}