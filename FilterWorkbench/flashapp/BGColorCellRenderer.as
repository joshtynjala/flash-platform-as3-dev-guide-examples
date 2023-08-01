package flashapp
{
	import com.example.programmingas3.filterWorkbench.GradientColor;
	
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	
	import flash.display.Shape;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	public class BGColorCellRenderer extends CellRenderer implements ICellRenderer
	{
		private var defaultTextFormat:TextFormat;
		private var tf:TextFormat;
		
		public function BGColorCellRenderer()
		{
			super();
			
			// grab the original font color
			defaultTextFormat = getStyleValue("textFormat") as TextFormat;
			
			tf = new TextFormat();
			tf.align = defaultTextFormat.align;
			tf.blockIndent = defaultTextFormat.blockIndent;
			tf.bold = defaultTextFormat.bold;
			tf.bullet = defaultTextFormat.bullet;
			tf.color = defaultTextFormat.color;
			tf.font = defaultTextFormat.font;
			tf.indent = defaultTextFormat.indent;
			tf.italic = defaultTextFormat.italic;
			tf.kerning = defaultTextFormat.kerning;
			tf.leading = defaultTextFormat.leading;
			tf.leftMargin = defaultTextFormat.leftMargin;
			tf.letterSpacing = defaultTextFormat.letterSpacing;
			tf.rightMargin = defaultTextFormat.rightMargin;
			tf.size = defaultTextFormat.size;
			tf.tabStops = defaultTextFormat.tabStops;
			tf.target = defaultTextFormat.target;
			tf.underline = defaultTextFormat.underline;
			tf.url = defaultTextFormat.url;
		}
		
		public static function getStyleDefinition():Object
		{
			return CellRenderer.getStyleDefinition();
		}
		
		protected override function drawBackground():void
		{
			super.drawBackground();
			var gColor:GradientColor = data as GradientColor;
			var bg:DisplayObjectContainer = background as DisplayObjectContainer;
			if (mouseState == "up" && gColor != null && bg != null)
			{
				// calculate the foreground color
				var r:Number = (gColor.color >> 16) & 0xFF;
				var g:Number = (gColor.color >> 8) & 0xFF;
				var b:Number = gColor.color & 0xFF;
				var avg:int = Math.round((r + g + b) / 3);
				var foreground:uint = (avg > 0x99 || gColor.alpha < .6) ? 0x000000 : 0xFFFFFF;
				
				// create the swatch background
				var swatch:Shape = new Shape();
				swatch.graphics.moveTo(0, 0);
				swatch.graphics.lineStyle(1, foreground, 1);
				swatch.graphics.beginFill(gColor.color, gColor.alpha);
				swatch.graphics.lineTo(bg.width, 0);
				swatch.graphics.lineTo(bg.width, bg.height);
				swatch.graphics.lineTo(0, bg.height);
				swatch.graphics.lineTo(0, 0);
				swatch.graphics.endFill();
				swatch.x = bg.x;
				swatch.y = bg.y;
				bg.addChild(swatch);
				
				// set the text color
				tf.color = foreground;
				
				setStyle("textFormat", tf);
			}
			else if (mouseState == "over" || mouseState == "down")
			{
				setStyle("textFormat", defaultTextFormat);
			}
		}
	}
}