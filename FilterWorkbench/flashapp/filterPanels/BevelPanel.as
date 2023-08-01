package flashapp.filterPanels
{
	import com.adobe.examples.flash.ComboDial;
	import com.adobe.examples.flash.ComboSlider;
	import com.example.programmingas3.filterWorkbench.BevelFactory;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.display.Sprite;
	
	public class BevelPanel extends Sprite implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:BevelFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:ComboSlider;
		public var blurYValue:ComboSlider;
		public var strengthValue:ComboSlider;
		public var qualityValue:ComboBox;
		public var shadowColorValue:ColorPicker;
		public var shadowAlphaValue:ComboSlider;
		public var highlightColorValue:ColorPicker;
		public var highlightAlphaValue:ComboSlider;
		public var angleValue:ComboDial;
		public var distanceValue:TextInput;
		public var knockoutValue:CheckBox;
		public var typeValue:ComboBox;
		
		
		// ------- Constructor -------
		public function BevelPanel()
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
			strengthValue.value = 1;
			qualityValue.selectedIndex = 0;
			shadowColorValue.selectedColor = 0x000000;
			shadowAlphaValue.value = 1;
			highlightColorValue.selectedColor = 0xFFFFFF;
			highlightAlphaValue.value = 1;
			angleValue.value = 45;
			distanceValue.text = "4";
			knockoutValue.selected = false;
			typeValue.selectedIndex = 0;
			
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
			_filterFactory = new BevelFactory();
			
			// populate the quality combo box
			var qualityList:DataProvider = new DataProvider();
			qualityList.addItem({label:"Low", data:BitmapFilterQuality.LOW});
			qualityList.addItem({label:"Medium", data:BitmapFilterQuality.MEDIUM});
			qualityList.addItem({label:"High", data:BitmapFilterQuality.HIGH});
			qualityValue.dataProvider = qualityList;
			
			// populate the type combo box
			var typeList:DataProvider = new DataProvider();
			typeList.addItem({label:"Inner", data:BitmapFilterType.INNER});
			typeList.addItem({label:"Outer", data:BitmapFilterType.OUTER});
			typeList.addItem({label:"Full", data:BitmapFilterType.FULL});
			typeValue.dataProvider = typeList;
						
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			strengthValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			shadowColorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			shadowAlphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			highlightColorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			highlightAlphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			angleValue.addEventListener(Event.CHANGE, changeFilterValue);
			distanceValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			typeValue.addEventListener(Event.CHANGE, changeFilterValue);
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (distanceValue.text.length <= 0) { return; }
			
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
			var shadowColor:uint = shadowColorValue.selectedColor;
			var shadowAlpha:Number = shadowAlphaValue.value;
			var highlightColor:uint = highlightColorValue.selectedColor;
			var highlightAlpha:Number = highlightAlphaValue.value;
			var angle:Number = angleValue.value;
			var distance:Number = Number(distanceValue.text);
			var knockout:Boolean = knockoutValue.selected;
			var type:String = typeValue.selectedItem.data;
			
			_filterFactory.modifyFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
	}
}