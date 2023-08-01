package com.example.content {
	import com.example.display.SampleComponent;
	import flash.display.BitmapData;
	import flash.util.trace;
	import flash.display.TextField;
	import flash.text.TextFormat;
	import flash.util.StringBuilder;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.display.TextFieldAutoSize;

	public class ASCIIPrinter extends SampleComponent {
		private var resolution:Number = .017;
		private var data:BitmapData;
		private var printer:TextField;
		private var output:Bitmap;
		private var buffer:StringBuilder;
		private var whiteThreshold:Number;
		private var blackThreshold:Number;
		private var result:BitmapData;
		// The characters in this string become increasingly darker.
		private var replacementChars:String = " .,;-~_+<>i!lI?/\|()1{}[]rcvunxzjftLCJUYXZO0Qoahkbdpqwm*WMB8&%$#@";

		public function ASCIIPrinter() {
		}
		
		protected override function init():void {
			gutter = 5;
			buildPrinter();
		}

		public function setBitmapData(data:BitmapData, whiteThreshold:Number = 0xC8, blackThreshold:Number = 20):void {
			this.whiteThreshold = whiteThreshold;
			this.blackThreshold = blackThreshold;
			this.data = data;

			clear();
//			var capacity:Number = (data.width * data.height) / resolution;
//			buffer.ensureCapacity(capacity);
			parseBitmapData(data);
			flush();

			result = new BitmapData(printer.width, printer.height);
			result.draw(printer, new Matrix());
			output = new Bitmap(result);
			addChild(output);
			draw();
		}
		
		private function println(line:String = ""):void {
			buffer.append(line + "\n"); 
		}
		
		private function print(str:String = ""):void {
			buffer.append(str); 
		}
		
		public function clear():void {
			buffer = new StringBuilder();
			printer.text = "";
			if(output != null) {
				removeChild(output);
			}
		}
		
		private function flush():void {
			printer.text = buffer.toString();
		}
		
		private function buildPrinter():void {
			printer = new TextField();
			printer.x = gutter;
			printer.y = gutter;

			printer.defaultTextFormat = getTextFormat();
			printer.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function getTextFormat():TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = "Courier";
			format.size = 8;
			return format;
		}

		// Returns an ASCII art (StringBuilder) representation of a bitmap.
		private function parseBitmapData(data:BitmapData):void {
			var rgbVal:uint;
			var redVal:uint;
			var greenVal:uint;
			var blueVal:uint;
			var grayVal:uint;
			var index:uint;
			var verticalResolution:uint = Math.floor(data.height * resolution); 
			var horizontalResolution:uint = Math.floor(data.width * resolution);
//			var verticalResolution:uint = 6; 
//			var horizontalResolution:uint = 3;
			trace("---------------------");
			trace("vertical: " + verticalResolution + " horizontal: " + horizontalResolution);
			for (var i:uint = 0; i < data.height; i += verticalResolution) {
				for (var j:uint = 0; j < data.width; j += horizontalResolution) {
					rgbVal = data.getPixel(j, i);
					redVal = (rgbVal & 0xFF0000) >> 16;
					greenVal = (rgbVal & 0x00FF00) >> 8;
					blueVal = rgbVal & 0x0000FF;

					// Formula for grayscale conversion (Y = gray): Y = 0.3*R + 0.59*G + 0.11*B
					grayVal = uint(0.3 * redVal + 0.59 * greenVal + 0.11 * blueVal);

					// The whiteThreshold and blackThreshold values (read from the "images.txt" file)
					// determine the grayscale values that are the cut-off limits for white and black
					if (grayVal > whiteThreshold) {
						grayVal = 0xFF;
					}
					else if (grayVal < blackThreshold) {
						grayVal = 0xFF;
					}
					else {
						grayVal = uint(0xFF * ((grayVal - blackThreshold)/(whiteThreshold - blackThreshold)));
					}
					index = uint(replacementChars.length - (grayVal / 4)); 
					print(replacementChars.charAt(index));
				}
				println();
			}
		}
		
		public override function draw():void {
			super.draw();
			if(data != null) {
				var imageWidth:Number = data.width;
				var imageHeight:Number = data.height;
				var availableWidth:Number = getWidth();
				var availableHeight:Number = getHeight();			
				var availableRatio:Number = availableWidth / availableHeight;
				var imageRatio:Number = imageWidth / imageHeight;
				
				if(availableRatio > imageRatio) {
					output.width = availableHeight * imageRatio;
					output.height = availableHeight;
					output.x = ((availableWidth - output.width) / 2) + gutter;
					output.y = gutter;
				}
				else {
					output.width = availableWidth;
					output.height = availableWidth * (1/imageRatio);
					output.x = gutter;
					output.y = ((availableHeight - output.height) / 2) + gutter;
				}
				output.width = output.width - (gutter * 2);
				output.height = output.height - (gutter * 2);
			}
		}
	}
}