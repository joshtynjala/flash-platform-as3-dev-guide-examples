package com.example.display {
	import com.example.display.SampleComponent;
	import flash.display.DisplayObject;
	import com.example.display.SampleHeader;
	import flash.events.Event;
	import flash.events.EventType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.fscommand;

	public class SampleFoundation extends SampleComponent {
		protected var header:SampleHeader;
		protected var content:ISampleComponent;
		protected var title:String = "Default Title";
		protected var description:String = "Default Description";

		public function SampleFoundation() {
			configureResize();
		}
		
		protected override function init():void {
			super.init();
			header = new SampleHeader();
			header.setTitle(title);
			header.setDescription(description);
			addChild(header);

			addChild(DisplayObject(content));
			fscommand("showmenu", "false");
			configureResize();
		}

		protected function configureResize():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(new Event(Event.RESIZE));
		}

		public function setTitle(title:String):void {
			header.setTitle(title);
		}
	
		public function setDescription(description:String):void {
			header.setDescription(description);
		}
		
		public function getTitle():String {
			return header.getTitle();
		}
		
		public function getDescription(description:String):String {
			return header.getDescription();
		}
		
		public override function setWidth(width:Number):void {
			super.setWidth(width);
			var availableWidth:int = int(_width - (gutter*2));
			header.setX(gutter);
			header.setWidth(availableWidth);
			content.setX(gutter);
			content.setWidth(availableWidth);
		}
		
		public override function setHeight(height:Number):void {
			super.setHeight(height);
			header.setY(gutter);
			content.setY(header.getHeight() + (gutter*2));
			content.setHeight(_height - (header.getHeight() + (gutter*3)));
		}
		
		public override function draw():void {
			header.draw();
			content.draw();
		}

		private function resizeHandler(e:Event):void {
			setWidth(stage.stageWidth - 5);
			setHeight(stage.stageHeight - 5);
			x = y = 0;
			draw();
		}
	}
}
