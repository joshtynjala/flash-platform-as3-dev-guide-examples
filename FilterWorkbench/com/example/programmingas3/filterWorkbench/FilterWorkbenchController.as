package com.example.programmingas3.filterWorkbench
{
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.ImageType;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BitmapFilter;
	import flash.net.URLRequest;
	
	
	// ------- Events -------
	/**
	 * Dispatched when progress occurs while the filter target image is loading.
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 * Dispatched when the filter target image finishes loading.
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the filter target image changes (its filters change).
	 */
	[Event(name="change", type="flash.events.Event")]
	
	
	/**
	 * The main class that provides the functionality of the FilterWorkbench application,
	 * including tracking sets of filters and applying the filters to the currently
	 * selected filter target.
	 */
	public class FilterWorkbenchController extends EventDispatcher
	{
		// ------- Private vars -------
		private var _filterFactory:IFilterFactory;
		private var _currentFilters:Array;
		private var _currentTarget:DisplayObject;
		private var _loader:Loader;
		
		private var _loading:Boolean;
		
		
		// ------- Constructor -------
		public function FilterWorkbenchController()
		{
			super();
		}
		
		
		// ------- Public Methods -------
		/**
		 * Selects a new type of image to be the "filter target" (the image to which
		 * the filters will be applied). Calling this method starts the process of
		 * loading the specified image; the image is available when the Event.COMPLETE
		 * event is dispatched.
		 * 
		 * @param	targetType	The ImageType constant representing the type of image
		 * 						desired.
		 */
		public function setFilterTarget(targetType:ImageType):void
		{
			if (targetType == null) { return; }
			
			if (_loading)
			{
				_loader.close();
				_loading = false;
			}
			
			if (_currentTarget != null)
			{
				_currentTarget = null;
			}
			
			_loader = new Loader();
			
			_loader.load(new URLRequest(targetType.url));
			_loading = true;
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, targetLoadIOError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, targetLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, targetLoadComplete);
			
			setFilter(null);
			
			// Reset the filters array
			_currentFilters = new Array();
		}
		
		/**
		 * Retrieves the current "filter target" -- the image that was selected to have filters
		 * applied to it
		 * @return The current filter target image
		 */
		public function getFilterTarget():DisplayObject
		{
			return _currentTarget;
		}
		
		
		/**
		 * Adds a new filter to the set of filters that are applied to
		 * the current filter target. Calling this method clears away the
		 * current "temporary" filter and replaces it with the one
		 * that's passed in the factory parameter.
		 * 
		 * @param	factory		The IFilterFactory that will build the
		 * 						current working filter.
		 */
		public function setFilter(factory:IFilterFactory):void
		{
			if (_filterFactory == factory) { return; }
			
			// Clean up the previous filter factory
			if (_filterFactory != null)
			{
				_filterFactory.removeEventListener(Event.CHANGE, filterChange);
				
				if (_currentTarget != null)
				{
					// refresh the image's filters (removing the last temporary filter)
					_currentTarget.filters = _currentFilters;
				}
			}
			
			// Store the new one (even if it's null)
			_filterFactory = factory;
			
			// Notify listeners that the filter has changed
			dispatchEvent(new Event(Event.CHANGE));
			
			if (factory == null || _currentTarget == null)
			{
				return;
			}
			
			// apply the new filter
			applyTemporaryFilter();
			
			_filterFactory.addEventListener(Event.CHANGE, filterChange);
		}
		
		
		/**
		 * "Permanently" adds the current filter to the set of filters applied
		 * to the target image. After this method is called, the next time
		 * a filter's values change it is added as an additional filter rather than 
		 * replacing the filter that is current when applyFilter() is called.
		 */
		public function applyFilter():void
		{
			if (_filterFactory != null)
			{
				_currentFilters.push(_filterFactory.getFilter());
				_currentTarget.filters = _currentFilters;
				setFilter(null);
			}
		}
		
		
		/**
		 * Retrieves a String containing the ActionScript code that would be used to create the
		 * currently selected filter.
		 * 
		 * @return The ActionScript code to create the filter effect
		 */
		public function getCode():String
		{
			return (_filterFactory != null) ? _filterFactory.getCode() : "";
		}
		
		
		// ------- Event Handling -------
		private function filterChange(event:Event):void
		{
			applyTemporaryFilter();
			
			// dispatch our own change event so the app knows to update the code display
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// Called when an IO Error is reported by a loading filter target image.
		private function targetLoadIOError(event:IOErrorEvent):void
		{
			_loading = false;
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, targetLoadIOError);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, targetLoadProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, targetLoadComplete);
			trace("load error");
		}
		
		
		// Called when loading progress is reported by a loading filter target image.
		private function targetLoadProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		
		// Called when a filter target image finishes loading.
		private function targetLoadComplete(event:Event):void
		{
			_loading = false;
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, targetLoadIOError);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, targetLoadProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, targetLoadComplete);
			
			_currentTarget = _loader.content;
			
			dispatchEvent(event);
		}
		
		
		private function applyTemporaryFilter():void
		{
			var currentFilter:BitmapFilter = _filterFactory.getFilter();
			// Add the current filter to the set temporarily
			_currentFilters.push(currentFilter);
			
			// Refresh the filter set of the filter target
			_currentTarget.filters = _currentFilters;
			
			// Remove the current filter from the set
			// (This doesn't remove it from the filter target, since 
			// the target uses a copy of the filters array internally.)
			_currentFilters.pop();
		}
	}
}