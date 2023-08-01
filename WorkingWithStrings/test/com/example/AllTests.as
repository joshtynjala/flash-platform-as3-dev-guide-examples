package com.example {
	import asunit.framework.TestSuite;
	import com.example.content.AllTests;
	import com.example.data.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.content.AllTests());
			addTest(new com.example.data.AllTests());
		}
	}
}
