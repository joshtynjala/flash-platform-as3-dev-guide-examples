package com.example.content {
	import asunit.framework.TestSuite;
	import com.example.content.ASCIIPrinterTest;
	import com.example.content.ImageStackTest;
	import com.example.content.ImageTest;
	import com.example.content.StringSampleContentTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.example.content.ASCIIPrinterTest());
			addTest(new com.example.content.ImageStackTest());
			addTest(new com.example.content.ImageTest());
			addTest(new com.example.content.StringSampleContentTest());
		}
	}
}
