package {
	import flash.display.*;
	import flash.geom.*;
	import flash.util.trace;
	import flash.events.*;
	import flash.errors.*;
	import flash.events.*;
	import com.examples.display.DropDownList;
	import com.examples.display.StandardTextButton;
	public class GeometrySample extends Sprite {
		public var gradientViewBox:GradientViewBox;
		public var entryPane:Sprite;
		public var gradientFields:Array;
		public var gradProps:Object;
		public function GeometrySample() {
			gradProps = new GradProps();
			gradientViewBox = new GradientViewBox(gradProps);
			addChild(gradientViewBox);
			gradientViewBox.draw();
			setUpEntryFields();
		}
		public function redrawGradient(e:Event):void {
			try {
				gradProps.type = gradientFields["Type"].currentSelection.text;
				gradProps.colors = arrayToNumbers(gradientFields["Colors"].input.text.split(","));
				gradProps.alphas = arrayToNumbers(gradientFields["Alphas"].input.text.split(","));
				gradProps.ratios = arrayToNumbers(gradientFields["Ratios"].input.text.split(","));
				gradProps.spreadMethod = gradientFields["Spread"].currentSelection.text;
				gradProps.interp = gradientFields["Interpolation"].currentSelection.text;
				gradProps.focalPtRatio = Number(gradientFields["Focal Point"].input.text);
				gradProps.boxWidth = Number(gradientFields["Box Width"].input.text);
				gradProps.boxHeight = Number(gradientFields["Box Height"].input.text);
				gradProps.boxRotation = Number(gradientFields["Box Rotation"].input.text);
				gradProps.tx = Number(gradientFields["tx"].input.text);
				gradProps.ty = Number(gradientFields["ty"].input.text);
				var temp:GradientViewBox = gradientViewBox;
				gradientViewBox = new GradientViewBox(gradProps);
				removeChild(temp);
				addChild(gradientViewBox);
				gradientViewBox.draw();
				gradientViewBox.addEventListener(MouseEvent.CLICK, redrawGradient);
			} catch (e:Error) {
				trace("bad data.")
			}
		}
		private function arrayToNumbers(a:Array):Array {
			var returnArray:Array = []
			for(var i:uint = 0; i < a.length; i++) {
				returnArray = returnArray.concat(Number(a[i]));
			}
			return returnArray;
		}
		private function setUpEntryFields():void {
			entryPane = new Sprite();
			gradientFields = new Array();
			entryPane.y = stage.stageHeight / 2 ;
			entryPane.x = 20;
			
			addDropDownList(["linear", "radial"], "Type");			
			addTextEntryBox("Colors", arrayToHexString(gradProps.colors));
			addTextEntryBox("Alphas", gradProps.alphas);			
			addTextEntryBox("Ratios", gradProps.ratios.toString());
			addDropDownList(["pad", "reflect", "repeat"], "Spread");			
			addDropDownList(["linearRGB", "RGB"], "Interpolation");			
			addTextEntryBox("Focal Point", gradProps.focalPtRatio.toString());
			addTextEntryBox("Box Width", gradProps.boxWidth.toString());
			addTextEntryBox("Box Height", gradProps.boxHeight.toString());
			addTextEntryBox("Box Rotation", gradProps.boxRotation.toString());
			addTextEntryBox("tx", gradProps.tx.toString());
			addTextEntryBox("ty", gradProps.ty.toString());
			arrangeFields();
			
			var drawButton:StandardTextButton = new StandardTextButton("Draw");
			drawButton.x = stage.stageWidth - drawButton.width - 10;
			drawButton.y = stage.stageHeight - drawButton.height - 10;
			drawButton.addEventListener(MouseEvent.CLICK, redrawGradient);
			addChild(drawButton);
			
			addChild(entryPane);
		}
		private function arrayToHexString(a:Array):String {
			var str:String = "";
			for (var i:uint = 0; i < a.length - 1; i++) {
				var hStr:String = hexStr(a[i]) + ",";
				str += hStr;
			}
			str += hexStr(a[a.length - 1]);
			str.toUpperCase();
			return str;
		}
		private function hexStr(n:uint):String {
			var str:String = "";
			str += n.toString(16);
			str = str.toUpperCase();
			var prependZeros:String = "";
			for (var i:uint = str.length; i < 6; i++) {
				prependZeros += "0";
			}
			str = "0x" + prependZeros + str;
			return str;
		}
		private function addTextEntryBox(label:String, txt:String, inputType:Boolean = true):void {
			gradientFields[label] = new TextEntryBox(label, txt, inputType);
			entryPane.addChild (gradientFields[label]);
		}
		private function addDropDownList(list:Array, label:String):void {
			gradientFields[label] = new DropDownList(list, label);
			entryPane.addChild (gradientFields[label]);
		}
		private function arrangeFields():void {
			var midValue:uint = Math.floor(entryPane.numChildren/2);
			for (var i:uint = 1; i < midValue; i++) {
				entryPane.getChildAt(i).y = entryPane.getChildAt(i - 1).y + 22;
			}
			entryPane.getChildAt(midValue).y = entryPane.getChildAt(0).y;
			entryPane.getChildAt(midValue).x = stage.stageWidth / 2;
			for (var i:uint = midValue + 1; i < entryPane.numChildren; i++) {
				entryPane.getChildAt(i).y = entryPane.getChildAt(i - 1).y + 22;
				entryPane.getChildAt(i).x = stage.stageWidth / 2;
			}
			for (var i:uint = 0; i < entryPane.numChildren; i++) {
				if (entryPane.getChildAt(i) is DropDownList) {
					DropDownList(entryPane.getChildAt(i)).repositionDropDownList(entryPane.getChildAt(i).y)
				}
			}			
		}
			
	}
}

import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.util.trace;
import flash.ui.Keyboard;
import flash.events.*;

class TextEntryBox extends Sprite{
	public var label:TextField;
	public var input:TextField;
	public function TextEntryBox(labelText:String = "label", inputText:String="", inputType:Boolean = true) {
		label = new TextField;
		label.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);
		label.text = labelText + ":";
		addChild(label);
		
		input = new TextField();
		input.defaultTextFormat = new TextFormat("Courier");
		input.backgroundColor = 0xFFFFFF;
		input.background = true;
		input.border = true;
		input.type = TextFieldType.INPUT;
		input.width = 125;
		input.height = 20;
		input.x = 80;
		input.text = inputText;
		addChild(input);
		if (!inputType) {
			input.type = TextFieldType.DYNAMIC;
			input.backgroundColor = 0xEEEEEE;
		}
	}
}

class GradientViewBox extends Sprite {
	public function GradientViewBox(gradProps:GradProps) {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(gradProps.boxWidth, 
									gradProps.boxHeight, 
									gradProps.boxRotation, 
									gradProps.tx, 
									gradProps.ty);
			
			graphics.beginGradientFill(gradProps.type, 
										gradProps.colors,
										gradProps.alphas,
										gradProps.ratios, 
										matrix, 
										gradProps.spreadMethod, 
										gradProps.interp, 
										gradProps.focalPtRatio);
			}
	public function draw():void {
		graphics.drawRect(20, 20, stage.stageWidth - 40, stage.stageHeight/2 - 30);
		graphics.lineStyle(1,0x000000);
	}
}	
class GradProps {
	public var type:String = GradientType.LINEAR;
	public var colors:Array = [0x00FF00, 0x000088];
	public var alphas:Array = [0.8, 1];
	public var ratios:Array = [0, 255];
	public var spreadMethod:String = SpreadMethod.PAD;
	public var interp:String = InterpolationMethod.LINEAR_RGB;
	public var focalPtRatio:Number = 0;
	public var boxWidth:Number = 100;
	public var boxHeight:Number = 50;
	public var boxRotation:Number = Math.PI/4;
	public var tx:Number = 0;
	public var ty:Number = 0;
}


