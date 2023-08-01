package com.example.programmingas3.playlist
{
	/**
	 * A pseudo-enum representing the different properties by which a Song instance
	 * can be sorted.
	 */
	public final class SortProperty
	{
		// ------- Public Constants -------
		
		// These constants represent the different properties
		// that the list of songs can be sorted by,
		// providing a mechanism to map a "friendly" name to the actual property name
		public static const TITLE:SortProperty = new SortProperty("title");
		public static const ARTIST:SortProperty = new SortProperty("artist");
		public static const YEAR:SortProperty = new SortProperty("year");

		
		// ------- Private Variables -------
		private var _propertyName:String;


		// ------- Constructor -------
		
		public function SortProperty(property:String)
		{
			_propertyName = property;
		}


		// ------- Public Properties -------
		
		public function get propertyName():String
		{
			return _propertyName;
		}
	}
}