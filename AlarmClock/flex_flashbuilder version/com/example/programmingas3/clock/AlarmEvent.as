package com.example.programmingas3.clock
{
	import flash.events.Event;
	
	/**
	 * This custom Event class adds a message property to a basic Event.
	 */
	public class AlarmEvent extends Event 
	{
		/**
		 * The name of the new AlarmEvent type.
		 */
		public static const ALARM:String = "alarm";
		
		/**
		 * A text message that can be passed to an event handler
		 * with this event object.
		 */
		public var message:String;
		
		/**
		 *  Constructor.
		 *  @param message The text to display when the alarm goes off.
		 */
		public function AlarmEvent(message:String = "ALARM!")
		{
			super(ALARM);
	
			this.message = message;
		}
		
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return	A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new AlarmEvent(message);
		}
		
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("AlarmEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
	}
}