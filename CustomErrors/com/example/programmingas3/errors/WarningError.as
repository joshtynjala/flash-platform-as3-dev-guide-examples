package com.example.programmingas3.errors {
    
	public class WarningError extends ApplicationError {
	    
		public function WarningError(errorID:int) 
		{
		    id = errorID;
			severity = ApplicationError.WARNING
			message = super.getMessageText(errorID);
		}
		
		public override function getTitle():String {
			return "Error #" + id + " -- Warning"
		}
		
		public override function toString():String {
			return "[WARNING ERROR #" + id + "] " + message;
		}

	}
}
