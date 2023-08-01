package {
	import asunit.textui.TestRunner;
	import flash.system.fscommand;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.util.trace;
	import com.example.content.ImageTest;

	public class StringSampleRunner extends TestRunner {

		public function StringSampleRunner() {
			fscommand("fullscreen", "true");
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			start(AllTests);
//			start(ImageTest);
		}
	}
}
