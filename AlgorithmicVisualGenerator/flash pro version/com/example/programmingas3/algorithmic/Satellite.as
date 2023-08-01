package com.example.programmingas3.algorithmic
{
	import flash.display.Shape;
	
	public class Satellite extends Shape {
		public var position:Number;
		public var color:uint;
		public var radius:Number;
		public var orbitRadius:Number;
		
		public function Satellite(position:Number,color:uint) {
			this.position = position;
			this.color = color;
		}
		public function draw(useAlphaEffect:Boolean = false):void {
			var radians:Number = getRadians(position);
			var posX:Number = Math.sin(radians) * orbitRadius;
			var posY:Number = Math.cos(radians) * orbitRadius;
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawCircle(posX, posY, radius);

			alpha = useAlphaEffect ? Math.abs(Math.sin(radians)) : 1;
		}
		private function getRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		private function getDegrees(radians:Number):uint {
			return Math.round(180 * radians / Math.PI)
		}		
	}
}