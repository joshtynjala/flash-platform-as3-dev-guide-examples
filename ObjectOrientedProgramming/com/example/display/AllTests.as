package com.example.display {
	import asunit.framework.TestSuite;
	import com.example.display.SampleComponentTest;
	import com.example.display.SampleFoundationTest;
	import com.example.display.SampleHeaderTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.display.SampleComponentTest());
			addTest(new com.example.display.SampleFoundationTest());
			addTest(new com.example.display.SampleHeaderTest());
		}
	}
}
