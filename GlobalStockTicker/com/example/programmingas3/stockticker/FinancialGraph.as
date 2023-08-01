package com.example.programmingas3.stockticker
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class FinancialGraph extends Sprite
	{
		public var granularity : int = 10;
		public var variation : Number = 0.5;
		
		public var gridColor : uint = 0x8080c0;
		public var gridThickness : uint = 1;
		
		public var borderColor : uint = 0xc0c0c0;
		public var borderThickness : uint = 2;
		
		public var bgColor : uint = 0x666666;
		public var graphColor : uint = 0x8080ff;
		public var graphThickness : uint = 2;
		
		public var graphGradientColors:Array = [0x000000, 0x000000];
		public var graphGradientAlphas:Array = [1, 0];
		
		public var graphHeight:Number;
		public var graphWidth:Number;
		
		/**
		 * Creates random line graphs that simulate stock price charts.
		 */
		public function FinancialGraph(w:Number = 740, h:Number = 310, graphColor:uint = 0x8080ff)
		{
			super();
			this.graphWidth = w;
			this.graphHeight = h;
			this.graphColor = graphColor;
		}
		public function init():void 
		{
			redraw();
		}
		
		private function fractalDraw( x1 : int, y1 : int, x2 : int, y2 : int ):void 
		{
			graphics.moveTo(x1,y1);
			fractalDrawRecurse( x1, y1, x2, y2 );
		}
		
		private function fractalDrawRecurse( x1 : int, y1 : int, x2 : int, y2 : int ):void 
		{
			var delta:int = x2 - x1;
			if( delta < 0 )
			{
				delta = -delta; 
			}
			
			if( delta <= granularity ) 
			{
				graphics.lineTo(x2,y2);
				return;
			}
			
			var midx : int = (x1 + x2)/2;
			var midy : int = (y1 + y2)/2;
			
			midy += (Math.random() - 0.5) * variation * (x2 - x1);
			
			if( midy > height )
			{
				midy = height;
			}
			if( midy < 0 )
			{
				midy = 0;
			}
			
			fractalDrawRecurse( x1, y1, midx, midy );
			fractalDrawRecurse( midx, midy, x2, y2 );
		}
		
		public function redraw() : void 
		{
			var ybegin: int = graphHeight * Math.random();
			var yend: int = graphHeight * Math.random();
			var ymin: int = Math.min(ybegin, yend);
			
			var ratios:Array = [0, 255];
			var verticalGradient:Matrix = new Matrix();
			verticalGradient.createGradientBox(graphWidth, graphHeight-ymin, Math.PI/2, 0, ymin);
			
			graphics.clear(); 
			
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, graphWidth, graphHeight);
			graphics.endFill();
			
			graphics.beginGradientFill( GradientType.LINEAR, graphGradientColors, 
				graphGradientAlphas, ratios, verticalGradient );
			graphics.lineStyle( graphThickness, graphColor );
			graphics.moveTo(0, graphHeight);
			graphics.lineTo(0, ybegin);
			fractalDraw( 0, ybegin, graphWidth, yend );
			graphics.lineTo(graphWidth, graphHeight);
			graphics.lineTo(0, graphHeight);
			graphics.endFill();
			
			graphics.lineStyle( gridThickness, gridColor );
			
			for( var i:int = 1; i < 3; ++i ) 
			{
				graphics.moveTo( 0, i * graphHeight / 3 );
				graphics.lineTo( graphWidth, i * graphHeight / 3 );
			}
			
			for( i = 1; i < 6; ++i ) 
			{
				graphics.moveTo( i * graphWidth / 6, 0 );
				graphics.lineTo( i * graphWidth / 6, graphHeight );
			}
		}
	}
}