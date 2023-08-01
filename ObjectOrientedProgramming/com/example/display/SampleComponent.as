package com.example.display {
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class SampleComponent extends Sprite implements ISampleComponent {
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var gutter:Number = 5;
		protected var backgroundColor:int = 0xFEFEFE;
		protected var strokeColor:int = 0x333333;
		protected var strokeSize:int = 0;

		public function SampleComponent() {
			init();
		}
		
		protected function init():void {
		}
		
		public function draw():void {
			graphics.clear();
			graphics.beginFill(backgroundColor);
			graphics.lineStyle(strokeSize, strokeColor);
			graphics.drawRect(0, 0, getWidth(), getHeight());
			graphics.endFill();
		}
		
		public function setWidth(width:Number):void {
			_width = width;
		}
		
		public function getWidth():Number {
			return _width;
		}
		
		public function setHeight(height:Number):void {
			_height = height;
		}
		
		public function getHeight():Number {
			return _height;
		}
		
		public function getX():Number {
			return x;
		}
		
		public function setX(x:Number):void {
			this.x = x;
		}
		
		public function getY():Number {
			return y;
		}
		
		public function setY(y:Number):void {
			this.y = y;
		}
		
	}
}
