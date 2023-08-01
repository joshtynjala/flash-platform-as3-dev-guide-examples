package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	
	/**
	 * Defines the common methods and properties that the application's 
	 * filter panels expose for getting data out of the panels.
	 * 
	 * All filter panels should implement this interface and be a display
	 * object.
	 */
	public interface IFilterPanel
	{
		/**
		 * Resets the filter panel to its original settings.
		 */
		function resetForm():void;
		
		
		/**
		 * Gets a filter factory that generates the bitmap filter
		 * with the settings and filter type specified by the 
		 * filter panel and its current settings.
		 */
		function get filterFactory():IFilterFactory;
	}
}