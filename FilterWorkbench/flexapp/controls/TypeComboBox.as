package flexapp.controls
{
	import flash.filters.BitmapFilterType;
	
	import mx.controls.ComboBox;

	public class TypeComboBox extends ComboBox
	{
		[Bindable]
		private var _typeList:Array = 
			[
			{label:"Inner", data:BitmapFilterType.INNER},
			{label:"Outer", data:BitmapFilterType.OUTER},
			{label:"Full", data:BitmapFilterType.FULL}
			];
			
		
		public function TypeComboBox()
		{
			super();
			
			width = 75;
			dataProvider = _typeList;
		}
	}
}