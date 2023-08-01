package flashapp.filterPanels
{
	import com.adobe.examples.flash.ComboDial;
	import com.adobe.examples.flash.ComboSlider;
	import com.example.programmingas3.filterWorkbench.ColorStringFormatter;
	import com.example.programmingas3.filterWorkbench.GradientBevelFactory;
	import com.example.programmingas3.filterWorkbench.GradientColor;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.CheckBox;
	import fl.controls.ColorPicker;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;
	import fl.events.DataGridEvent;
	import fl.events.DataGridEventReason;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.display.Sprite;
	
	import flashapp.BGColorCellRenderer;
	import flashapp.ButtonCellRenderer;
	
	public class GradientBevelPanel extends Sprite implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:GradientBevelFactory;
		
		private var _editValue:Number;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:ComboSlider;
		public var blurYValue:ComboSlider;
		public var strengthValue:ComboSlider;
		public var qualityValue:ComboBox;
		public var angleValue:ComboDial;
		public var distanceValue:ComboSlider;
		public var knockoutValue:CheckBox;
		public var typeValue:ComboBox;
		public var gradientValues:DataGrid;
		public var addColorValue:ColorPicker;
		public var addAlphaValue:ComboSlider;
		public var addRatioValue:ComboSlider;
		public var addGradientBtn:Button;
		
		
		// ------- Constructor -------
		public function GradientBevelPanel()
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
			angleValue.value = 45;
			distanceValue.value = 4;
			knockoutValue.selected = false;
			typeValue.selectedIndex = 0;
			gradientValues.dataProvider = getDefaultGradientValues();
			addColorValue.selectedColor = 0x000000;
			addAlphaValue.value = 1;
			addRatioValue.value = 128;
			
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
			_filterFactory = new GradientBevelFactory();
			
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
						
			// populate the gradient colors grid
			gradientValues.dataProvider = getDefaultGradientValues();
			var colorColumn:DataGridColumn = new DataGridColumn("Colors");
			colorColumn.cellRenderer = BGColorCellRenderer;
			colorColumn.dataField = "color";
			colorColumn.labelFunction = colorFormatter;
			colorColumn.resizable = false;
			colorColumn.width = 70;
			gradientValues.addColumn(colorColumn);
			var alphaColumn:DataGridColumn = new DataGridColumn("Alphas");
			alphaColumn.cellRenderer = BGColorCellRenderer;
			alphaColumn.dataField = "alpha";
			alphaColumn.resizable = false;
			alphaColumn.width = 55;
			gradientValues.addColumn(alphaColumn);
			var ratioColumn:DataGridColumn = new DataGridColumn("Ratios");
			ratioColumn.cellRenderer = BGColorCellRenderer;
			ratioColumn.dataField = "ratio";
			ratioColumn.resizable = false;
			ratioColumn.sortOptions = Array.NUMERIC;
			ratioColumn.width = 55;
			gradientValues.addColumn(ratioColumn);
			var deleteColumn:DataGridColumn = new DataGridColumn(" ");
			deleteColumn.cellRenderer = ButtonCellRenderer;
			deleteColumn.labelFunction = deleteButtonLabelFunction;
			deleteColumn.editable = false;
			gradientValues.addColumn(deleteColumn);
			
			
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			strengthValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			angleValue.addEventListener(Event.CHANGE, changeFilterValue);
			distanceValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			typeValue.addEventListener(Event.CHANGE, changeFilterValue);
			
			addGradientBtn.addEventListener(MouseEvent.CLICK, addNewGradient);
			
			// This one gets called before the datagrid updates the dataprovider (which happens in this same
			// event, with priority -20).
			gradientValues.addEventListener(DataGridEvent.ITEM_EDIT_END, editPreEnd, false, 100);
			// This one gets called after the datagrid updates the dataprovider.
			gradientValues.addEventListener(DataGridEvent.ITEM_EDIT_END, editPostEnd, false, -100);
			
			// Click handler for datagrid, to detect when the delete button is pressed
			gradientValues.addEventListener(MouseEvent.CLICK, checkForItemDelete);
		}
		
		
		// Called after editing ends in a datagrid cell, but before the dataprovider is updated.
		private function editPreEnd(event:DataGridEvent):void
		{
			if (event.reason == DataGridEventReason.CANCELLED)
			{
				return;
			}
			// save a snapshot of the pre-change data
			_editValue = gradientValues.dataProvider.getItemAt(Number(event.rowIndex))[event.dataField];
		}
		
		
		// Called after editing ends in a datagrid cell, and after the dataprovider is updated.
		private function editPostEnd(event:DataGridEvent):void
		{
			if (event.reason == DataGridEventReason.CANCELLED)
			{
				return;
			}
			
			var index:Number = Number(event.rowIndex);
			var data:GradientColor = gradientValues.dataProvider.getItemAt(index) as GradientColor;
			var newValue:Number = data[event.dataField];
			if (newValue == _editValue)
			{
				return;
			}
			// validate the changed data
			var needToRevert:Boolean = false;
			
			if (isNaN(newValue))
			{
				needToRevert = true;
			}
			else
			{
				switch (event.dataField)
				{
					case "color":
						if (newValue < 0) { needToRevert = true; }
						break;
					case "alpha":
						if (newValue > 1 || newValue < 0) { needToRevert = true; }
						break;
					case "ratio":
						if (newValue > 255 || newValue < 0) { needToRevert = true; }
						break;
				}
			}
			
			if (needToRevert)
			{
				data[event.dataField] = _editValue;
				gradientValues.dataProvider.replaceItemAt(data, index);
				return;
			}
			
			// resort the data if the ratio changed
			if (event.dataField == "ratio")
			{
				gradientValues.dataProvider.sortOn("ratio", Array.NUMERIC);
			}
			
			// update the filter
			updateFilter();
		}
		
		
		private function checkForItemDelete(event:MouseEvent):void
		{
			var cell:ButtonCellRenderer = event.target as ButtonCellRenderer;
			if (cell != null)
			{
				gradientValues.dataProvider.removeItem(cell.data);
				updateFilter();
			}
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// update the filter
			updateFilter();
		}
		
		
		private function addNewGradient(event:MouseEvent):void
		{
			var gradient:GradientColor = new GradientColor(addColorValue.selectedColor, addAlphaValue.value, addRatioValue.value);
			gradientValues.dataProvider.addItem(gradient);
			gradientValues.dataProvider.sortOn("ratio", Array.NUMERIC);
			updateFilter();
		}
		
		
		// ------- DataGrid utility methods -------
		private function colorFormatter(data:Object):String
		{
			var c:GradientColor = data as GradientColor;
			if (c != null)
			{
				return ColorStringFormatter.formatColorHex24(c.color);
			}
			else
			{
				return "";
			}
		}
		
		
		private function deleteButtonLabelFunction(data:Object):String
		{
			return "Delete";
		}
		
		
		// ------- Private methods -------
		private function updateFilter():void
		{
			var blurX:Number = blurXValue.value;
			var blurY:Number = blurYValue.value;
			var strength:Number = strengthValue.value;
			var quality:int = qualityValue.selectedItem.data;
			var angle:Number = angleValue.value;
			var distance:Number = distanceValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var type:String = typeValue.selectedItem.data;
			var colors:Array = gradientValues.dataProvider.toArray();
			
			_filterFactory.modifyFilter(distance, angle, colors, blurX, blurY, strength, quality, type, knockout);
		}
		
		
		private static function getDefaultGradientValues():DataProvider
		{
			return new DataProvider([new GradientColor(0xFFFFFF, 1, 0),
									  new GradientColor(0xFF0000, .25, 128),
									  new GradientColor(0x000000, 1, 255)]);
		}
	}
}