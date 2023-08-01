package com.example {
	import asunit.framework.TestSuite;
	import com.example.display.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.display.AllTests());
		}
	}
}
