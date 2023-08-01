package 
{
	public class Greeter 
	{
		/**
		 * Defines the names that should receive a proper greeting.
		 */
		public static var validNames:Array = ["Sammy", "Frank", "Dean"];

		/**
		 * Builds a greeting string using the given name.
		 */
		public function sayHello(userName:String = ""):String 
		{
			var greeting:String;
			if (userName == "") 
			{
				greeting = "Hello. Please type your user name, and then press the Enter key.";
			} 
			else if (validName(userName)) 
			{
				greeting = "Hello, " + userName + ".";
			} 
			else 
			{
				greeting = "Sorry, " + userName + ", you are not on the list.";
			}
			return greeting;
		}
		
		/**
		 * Checks whether a name is in the validNames list.
		 */
		public static function validName(inputName:String = ""):Boolean 
		{
			if (validNames.indexOf(inputName) > -1) 
			{
				return true;
			} 
			else 
			{
				return false;
			}
		}
	}
}