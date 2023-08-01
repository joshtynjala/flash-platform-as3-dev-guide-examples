package flexapp.controls
{
	import flash.filters.BitmapFilterQuality;
	
	import mx.controls.ComboBox;

	public class QualityComboBox extends ComboBox
	{
		[Bindable]
		private var _qualityList:Array = 
			[
			{label:"Low", data:BitmapFilterQuality.LOW},
			{label:"Medium", data:BitmapFilterQuality.MEDIUM},
			{label:"High", data:BitmapFilterQuality.HIGH}
			];
			
		
		public function QualityComboBox()
		{
			super();
			
			width = 85;
			dataProvider = _qualityList;
		}
	}
}