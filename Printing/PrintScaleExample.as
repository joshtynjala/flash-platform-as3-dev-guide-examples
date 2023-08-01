package {
	import flash.print.PrintJob;
	import flash.display.Sprite;
	import flash.display.TextField;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.util.trace;
	   
	public class PrintScaleExample extends Sprite {
		
		private var bg:Sprite;
		private var txt:TextField;
		   
		public function PrintScaleExample():void {
			init();
			draw();
			printPage();
		}
		
		private function printPage():void {
			var pj:PrintJob = new PrintJob();
			txt.scaleX = 3;
			txt.scaleY = 2;
			if(pj.start()) {
				trace(">> pj.orientation: " + pj.orientation);
				trace(">> pj.pageWidth: " + pj.pageWidth);
				trace(">> pj.pageHeight: " + pj.pageHeight);
				trace(">> pj.paperWidth: " + pj.paperWidth);
				trace(">> pj.paperHeight: " + pj.paperHeight);	

				try {
					pj.addPage(this, new Rectangle(0, 0, 100, 100)) ;
				}
				catch(e:Error) {
					//do nothing
					}
				try {
					pj.send();
					}
				catch(e:Error) {
					//do nothing
					}
			}
			else {
				txt.text = "Print job canceled";
			}
			//reset the txt scale properties
			txt.scaleX = 1;
			txt.scaleY = 1;
		}
		
		
		private function init():void {
			bg = new Sprite();
			bg.graphics.beginFill(0x00FF00);
			bg.graphics.drawRect(0, 0, 100, 200);
			bg.graphics.endFill();
			
			txt = new TextField();
			txt.border = true;
			txt.text = "Hello World";
		}
		
		private function draw():void {
			addChild(bg);
			addChild(txt);
			txt.x = 50;
			txt.y = 50;
		}
	}
}
