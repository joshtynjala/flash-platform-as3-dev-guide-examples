package flashapp.filterPanels
{
	import com.adobe.examples.flash.ComboSlider;
	import com.example.programmingas3.filterWorkbench.BlurFactory;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.display.Sprite;
	
	public class BlurPanel extends Sprite implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:BlurFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:ComboSlider;
		public var blurYValue:ComboSlider;
		public var qualityValue:ComboBox;
		
		
		// ------- Constructor -------
		public function BlurPanel()
		{
			addEventListener(Event.ADDED, setupChildren);
		}
		
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		
		// ------- Public methods -------
		public function resetForm():void
		{
			blurXValue.value = 4;
			blurYValue.value = 4;
			qualityValue.selectedIndex = 0;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
			}
		}
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			// create the filter factory
			_filterFactory = new BlurFactory();
			
			// populate the quality combo box
			var qualityList:DataProvider = new DataProvider();
			qualityList.addItem({label:"Low", data:BitmapFilterQuality.LOW});
			qualityList.addItem({label:"Medium", data:BitmapFilterQuality.MEDIUM});
			qualityList.addItem({label:"High", data:BitmapFilterQuality.HIGH});
			qualityValue.dataProvider = qualityList;
			
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// update the filter
			updateFilter();
		}
		
		
		// ------- Private methods -------
		private function updateFilter():void
		{
			var blurX:Number = blurXValue.value;
			var blurY:Number = blurYValue.value;
			var quality:int = qualityValue.selectedItem.data;
			
			_filterFactory.modifyFilter(blurX, blurY, quality);
		}
	}
}