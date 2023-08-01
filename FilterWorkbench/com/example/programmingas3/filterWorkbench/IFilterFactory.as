package com.example.programmingas3.filterWorkbench
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filters.BitmapFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	/**
	 * Defines the common methods for the filter factory classes used in the FilterWorkbench application.
	 * Each IFilterFactory implementer has specific properties or methods for setting values for its specific
	 * filter. The interface's getFilter() method is used to retreive the filter in its current state.
	 * 
	 * Although it can't be explicitly enforced by the compiler, each IFilterFactory implementer should provide
	 * a flash.events.Event.CHANGE event indicating that the filter has changed. For this reason IFilterFactory 
	 * implementers must also implement flash.events.IEventDispatcher.
	 */
	public interface IFilterFactory extends IEventDispatcher
	{
		function getFilter():BitmapFilter;
		
		function getCode():String;
	}
}