package flexapp.controls
{
	import com.example.programmingas3.filterWorkbench.GradientColor;
	
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridListData;

	public class BGColorCellRenderer extends Label
	{
		public function BGColorCellRenderer()
		{
			super();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{ 
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			
			var grid:DataGrid = DataGrid(DataGridListData(listData).owner);
			
			if (grid.isItemSelected(data) || grid.isItemHighlighted(data))
			{
				return;
			}
			
			var gColor:GradientColor = data as GradientColor;
			if (gColor != null)
			{
				// calculate the foreground color
				var r:Number = (gColor.color >> 16) & 0xFF;
				var g:Number = (gColor.color >> 8) & 0xFF;
				var b:Number = gColor.color & 0xFF;
				var avg:int = Math.round((r + g + b) / 3);
				var foreground:uint = (avg > 0x99 || gColor.alpha < .6) ? 0x000000 : 0xFFFFFF;
				setStyle("color", foreground);
				
				// draw the background
				graphics.beginFill(data.color, data.alpha);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
		}
	}
}