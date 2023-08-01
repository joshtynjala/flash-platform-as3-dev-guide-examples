package {
	import asunit.textui.TestRunner;
	import flash.system.fscommand;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.util.trace;
	import com.example.display.SampleComponentTest;
	import com.example.display.SampleHeaderTest;

	public class SampleFoundationRunner extends TestRunner {

		public function SampleFoundationRunner() {
			fscommand("fullscreen", "true");
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			start(AllTests);
//			start(SampleHeaderTest, "testTitleAndDescription");
//			start(SampleComponentTest, "testDisplayMock");
		}
	}
}
