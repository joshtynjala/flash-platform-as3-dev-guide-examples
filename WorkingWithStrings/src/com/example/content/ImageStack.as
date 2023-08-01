package com.example.content {
	import com.example.content.Image;
	import com.example.display.SampleComponent;
	import com.example.data.Iterable;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.EventType;
	import flash.events.Event;
	import asunit.framework.Assert;
	import flash.util.trace;

	public class ImageStack extends SampleComponent implements Iterable{
		private var currentChild:Image;

		public function ImageStack() {
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			// The ImageStack requires all children to be SampleComponents because
			// of setWidth/setHeight...
			if(!(child is Image)) {
				throw new IllegalOperationError("Attempted to addChild with an instance that is not of type SampleComponent");
			}
			child.addEventListener(Event.COMPLETE, completeHandler);
			if(numChildren == 0) {
				currentChild = Image(child);
			}
			else {
				child.visible = false;
			}
			return super.addChild(child);
		}
		
		private function completeHandler(event:Event):void {
			draw();
		}
		
		public function hasNext():Boolean {
			return (numChildren > 0);
		}
		
		public override function draw():void {
			super.draw();
			if(hasNext()) {
				var child:Image = currentChild;
				child.setWidth(getWidth());
				child.setHeight(getHeight());
				child.draw();
			}
		}

		public function next():Object {
			currentChild.visible = false;
			currentChild = Image(getChildAt(0));
			setChildIndex(currentChild, numChildren - 1);
			currentChild.visible = true;
			draw();
			return currentChild;
		}
	}
}
