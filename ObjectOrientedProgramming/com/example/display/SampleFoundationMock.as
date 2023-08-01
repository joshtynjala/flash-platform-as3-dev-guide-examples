package com.example.display {
	import com.example.display.SampleFoundation;
	import flash.events.Event;

	public class SampleFoundationMock extends SampleFoundation {

		public function SampleFoundationMock() {
		}
		
		protected override function init():Void {
			title = "Chapter Four: Object-Oriented Programming";
			description = "This is a description about OOP.";
			content = new ChapterFourContent();
			super.init();
		}
		
		protected override function configureResize():Void {
		}
	}
}
