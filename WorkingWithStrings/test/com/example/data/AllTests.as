package com.example.data {
	import asunit.framework.TestSuite;
	import com.example.data.ASCIIDataTest;
	import com.example.data.ASCIIRecordTest;
	import com.example.data.StringDataTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.data.ASCIIDataTest());
			addTest(new com.example.data.ASCIIRecordTest());
			addTest(new com.example.data.StringDataTest());
		}
	}
}
