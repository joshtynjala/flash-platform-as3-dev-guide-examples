package com {
	import asunit.framework.TestSuite;
	import com.example.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.AllTests());
		}
	}
}
