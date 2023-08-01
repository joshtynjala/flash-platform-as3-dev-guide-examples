package com.example.programmingas3.errors 
{
	public class FatalError extends ApplicationError 
	{
		public function FatalError(errorID:int) 
		{
			id = errorID;
			severity = ApplicationError.FATAL
			message = getMessageText(errorID);
		}
		
		public override function getTitle():String {
			return "Error #" + id + " -- FATAL";
		}
		
		public override function toString():String {
			return "[FATAL ERROR #" + id + "] " + message;
		}
	}
}