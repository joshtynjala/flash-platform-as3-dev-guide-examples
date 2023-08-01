package  {

	public class StringSampleMock extends StringSample {

		public function StringSampleMock() {
		}
		
		protected override function configureResize():Void {
			setWidth(600);
			setHeight(400);
			draw();			
		}
	}
}
