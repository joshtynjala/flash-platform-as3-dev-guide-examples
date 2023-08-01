package {
	import com.example.display.SampleFoundation;
	import com.example.display.ChapterFourContent;
	
	public class ChapterFour extends SampleFoundation {
				
		protected override function init():Void {
			title = "Chapter Four: Object-Oriented Programming";
			description = "This is a description about OOP.";
			content = new ChapterFourContent();
			super.init();
		}
	}
}
