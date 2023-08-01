package  {
	import com.example.display.SampleFoundation;
	import com.example.content.StringSampleContent;

	public class StringSample extends SampleFoundation {

		public function StringSample() {
		}
		
		protected override function init():void {
			title = "Chapter Ten: Working With Strings";
			description = "This is a description about Strings.";
			content = new StringSampleContent();
			super.init();
		}
	}
}
