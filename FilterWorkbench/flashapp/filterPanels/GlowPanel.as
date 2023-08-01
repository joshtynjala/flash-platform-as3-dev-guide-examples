package flashapp.filterPanels
{
	import com.adobe.examples.flash.ComboSlider;
	import com.example.programmingas3.filterWorkbench.GlowFactory;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.display.Sprite;
	
	public class GlowPanel extends Sprite implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:GlowFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:ComboSlider;
		public var blurYValue:ComboSlider;
		public var strengthValue:ComboSlider;
		public var qualityValue:ComboBox;
		public var colorValue:ColorPicker;
		public var alphaValue:ComboSlider;
		public var knockoutValue:CheckBox;
		public var innerValue:CheckBox;
		
		
		// ------- Constructor -------
		public function GlowPanel()
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
			blurXValue.value = 6;
			blurYValue.value = 6;
			strengthValue.value = 2;
			qualityValue.selectedIndex = 0;
			colorValue.selectedColor = 0xFF0000;
			alphaValue.value = 1;
			knockoutValue.selected = false;
			innerValue.selected = false;
			
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
			_filterFactory = new GlowFactory();
			
			// populate the quality combo box
			var qualityList:DataProvider = new DataProvider();
			qualityList.addItem({label:"Low", data:BitmapFilterQuality.LOW});
			qualityList.addItem({label:"Medium", data:BitmapFilterQuality.MEDIUM});
			qualityList.addItem({label:"High", data:BitmapFilterQuality.HIGH});
			qualityValue.dataProvider = qualityList;
			
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			strengthValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			colorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			alphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			innerValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
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
			var strength:Number = strengthValue.value;
			var quality:int = qualityValue.selectedItem.data;
			var color:uint = colorValue.selectedColor;
			var alpha:Number = alphaValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var inner:Boolean = innerValue.selected;
			
			_filterFactory.modifyFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
	}
}