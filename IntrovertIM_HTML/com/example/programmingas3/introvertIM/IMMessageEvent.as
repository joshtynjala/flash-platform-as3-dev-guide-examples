package com.example.programmingas3.introvertIM
{
	import flash.events.Event;

	public class IMMessageEvent extends Event
	{
		// ------- Public Constants -------
		public static const NEW_MESSAGE:String = "newmessage";
		
		
		// ------- Private vars -------
		private var _message:String;
		
		
		// ------- Constructor -------
		public function IMMessageEvent(message:String)
		{
			super(NEW_MESSAGE);
			_message = message;
		}
		
		
		// ------- Public Properties -------
		public function get message():String
		{
			return _message;
		}


		// ------- Event Method Overrides -------
		public override function clone():Event
		{
			return new IMMessageEvent(_message);
		}
		
		public override function toString():String
		{
			return formatToString("IMMessageEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
	}
}