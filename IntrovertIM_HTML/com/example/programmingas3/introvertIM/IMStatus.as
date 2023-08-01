package com.example.programmingas3.introvertIM
{
	public final class IMStatus
	{
		// ------- "Enum" members -------
		public static var NeedAFriend:IMStatus = new IMStatus(1, "Please talk to me!");
		public static var ImHere:IMStatus = new IMStatus(2, "I'm here");
		public static var NotTooBusy:IMStatus = new IMStatus(3, "Not too busy for you");
		public static var EmergenciesOnly:IMStatus = new IMStatus(4, "Emergencies Only");
		public static var GoAway:IMStatus = new IMStatus(5, "Go Away!");
		
		
		/**
		 * An array containing all the available statuses, for populating the list
		 * of statuses.
		 */
		public static const allStatuses:Array = [
					NeedAFriend,
					ImHere,
					NotTooBusy,
					EmergenciesOnly,
					GoAway
					];
		
		// ------- Private vars -------
		private var _uid:uint;
		private var _displayText:String;
		
		
		// ------- Constructor -------
		public function IMStatus(uid:uint, displayText:String)
		{
			_uid = uid;
			_displayText = displayText;
		}
		
		
		// ------- Public Accessors -------
		
		/**
		 * Provides a String representation of the current IMStatus object.
		 * This property is provided to satisfy the Flash components, which require a "label" field on data items.
		 */
		public function get label():String
		{
			return this.toString();
		}
		
		public function get icon():String
		{
			return null;
		}
		
		// ------- Public Methods -------
		
		/**
		 * Provides a String representation of the current IMStatus object.
		 * @return 	The appropriate String
		 */
		public function toString():String
		{
			return (_displayText != null && _displayText.length > 0) ? _displayText : "[Object IMStatus uid:" + _uid.toString() + "]";
		}
	}
}