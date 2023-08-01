package {
	import asunit.framework.TestSuite;
	import com.AllTests;
	import test.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.AllTests());
			addTest(new test.AllTests());
		}
	}
}
