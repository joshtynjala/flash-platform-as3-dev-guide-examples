package flashapp.filterPanels
{
	import com.adobe.examples.flash.ComboSlider;
	import com.example.programmingas3.filterWorkbench.ColorMatrixFactory;
	import com.example.programmingas3.filterWorkbench.IFilterFactory;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	public class ColorMatrixPanel extends Sprite implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:ColorMatrixFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var brightnessValue:ComboSlider;
		public var contrastValue:ComboSlider;
		public var saturationValue:ComboSlider;
		public var hueValue:ComboSlider;
		public var m0:TextInput;
		public var m1:TextInput;
		public var m2:TextInput;
		public var m3:TextInput;
		public var m4:TextInput;
		public var m5:TextInput;
		public var m6:TextInput;
		public var m7:TextInput;
		public var m8:TextInput;
		public var m9:TextInput;
		public var m10:TextInput;
		public var m11:TextInput;
		public var m12:TextInput;
		public var m13:TextInput;
		public var m14:TextInput;
		public var m15:TextInput;
		public var m16:TextInput;
		public var m17:TextInput;
		public var m18:TextInput;
		public var m19:TextInput;
		public var resetButton:Button;
		
		
		// ------- Constructor -------
		public function ColorMatrixPanel()
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
			setMatrixForm([1, 0, 0, 0, 0,
						   0, 1, 0, 0, 0,
						   0, 0, 1, 0, 0,
						   0, 0, 0, 1, 0]);
			
			brightnessValue.value = 0;
			contrastValue.value = 0;
			saturationValue.value = 0;
			hueValue.value = 0;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilterCustom();
			}
		}
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			// create the filter factory
			_filterFactory = new ColorMatrixFactory();
			
			// add event listeners for child controls
			brightnessValue.addEventListener(Event.CHANGE, changePreset);
			contrastValue.addEventListener(Event.CHANGE, changePreset);
			saturationValue.addEventListener(Event.CHANGE, changePreset);
			hueValue.addEventListener(Event.CHANGE, changePreset);
			
			m0.addEventListener(Event.CHANGE, changeFilterValue);
			m1.addEventListener(Event.CHANGE, changeFilterValue);
			m2.addEventListener(Event.CHANGE, changeFilterValue);
			m3.addEventListener(Event.CHANGE, changeFilterValue);
			m4.addEventListener(Event.CHANGE, changeFilterValue);
			m5.addEventListener(Event.CHANGE, changeFilterValue);
			m6.addEventListener(Event.CHANGE, changeFilterValue);
			m7.addEventListener(Event.CHANGE, changeFilterValue);
			m8.addEventListener(Event.CHANGE, changeFilterValue);
			m9.addEventListener(Event.CHANGE, changeFilterValue);
			m10.addEventListener(Event.CHANGE, changeFilterValue);
			m11.addEventListener(Event.CHANGE, changeFilterValue);
			m12.addEventListener(Event.CHANGE, changeFilterValue);
			m13.addEventListener(Event.CHANGE, changeFilterValue);
			m14.addEventListener(Event.CHANGE, changeFilterValue);
			m15.addEventListener(Event.CHANGE, changeFilterValue);
			m16.addEventListener(Event.CHANGE, changeFilterValue);
			m17.addEventListener(Event.CHANGE, changeFilterValue);
			m18.addEventListener(Event.CHANGE, changeFilterValue);
			m19.addEventListener(Event.CHANGE, changeFilterValue);
			
			resetButton.addEventListener(MouseEvent.CLICK, resetClick);
		}
		
		
		private function changePreset(event:Event):void
		{
			// update the filter
			_filterFactory.modifyFilterBasic(brightnessValue.value, contrastValue.value, saturationValue.value, hueValue.value);
			
			// populate the form values with the new matrix
			setMatrixForm(_filterFactory.matrix);
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (m0.text.length <= 0) { return; }
			if (m1.text.length <= 0) { return; }
			if (m2.text.length <= 0) { return; }
			if (m3.text.length <= 0) { return; }
			if (m4.text.length <= 0) { return; }
			if (m5.text.length <= 0) { return; }
			if (m6.text.length <= 0) { return; }
			if (m7.text.length <= 0) { return; }
			if (m8.text.length <= 0) { return; }
			if (m9.text.length <= 0) { return; }
			if (m10.text.length <= 0) { return; }
			if (m11.text.length <= 0) { return; }
			if (m12.text.length <= 0) { return; }
			if (m13.text.length <= 0) { return; }
			if (m14.text.length <= 0) { return; }
			if (m15.text.length <= 0) { return; }
			if (m16.text.length <= 0) { return; }
			if (m17.text.length <= 0) { return; }
			if (m18.text.length <= 0) { return; }
			if (m19.text.length <= 0) { return; }
			
			// reset the brightness/contrast/saturation/hue controls
			brightnessValue.value = 0;
			contrastValue.value = 0;
			saturationValue.value = 0;
			hueValue.value = 0;
			
			// update the filter
			var matrix:Array = [Number(m0.text), Number(m1.text), Number(m2.text), Number(m3.text), Number(m4.text),
								 Number(m5.text), Number(m6.text), Number(m7.text), Number(m8.text), Number(m9.text),
								 Number(m10.text), Number(m11.text), Number(m12.text), Number(m13.text), Number(m14.text),
								 Number(m15.text), Number(m16.text), Number(m17.text), Number(m18.text), Number(m19.text)];
			
			_filterFactory.modifyFilterCustom(matrix);
		}
		
		
		private function resetClick(event:MouseEvent):void
		{
			resetForm();
		}
		
		
		// ------- Utility methods -------
		private function setMatrixForm(matrix:Array):void
		{
			m0.text = matrix[0].toString();
			m1.text = matrix[1].toString();
			m2.text = matrix[2].toString();
			m3.text = matrix[3].toString();
			m4.text = matrix[4].toString();
			m5.text = matrix[5].toString();
			m6.text = matrix[6].toString();
			m7.text = matrix[7].toString();
			m8.text = matrix[8].toString();
			m9.text = matrix[9].toString();
			m10.text = matrix[10].toString();
			m11.text = matrix[11].toString();
			m12.text = matrix[12].toString();
			m13.text = matrix[13].toString();
			m14.text = matrix[14].toString();
			m15.text = matrix[15].toString();
			m16.text = matrix[16].toString();
			m17.text = matrix[17].toString();
			m18.text = matrix[18].toString();
			m19.text = matrix[19].toString();
		}
	}
}