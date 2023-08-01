package com.examples.display {
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.util.*;
	import flash.ui.Keyboard;
	import flash.events.*;
	
	public class DropDownList extends Sprite{
		public var selectionList:Sprite;
		public var currentLine:uint = 0;
		public var currentSelection:ListEntry;
		public var label:TextField;
		public var listExpanded:Boolean = false;
		private var dropDownButton:DropDownButton;
		public function DropDownList(entryList:Array, labelText:String = "label") {
			label = new TextField;
			label.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000, true);
			label.text = labelText + ":";
			addChild(label);
			
			currentSelection = new ListEntry();
			currentSelection.border = true;
			currentSelection.selectable = true;
			currentSelection.text = entryList[0].toString();
			currentSelection.height = currentSelection.textHeight + 6;
			currentSelection.width = 125;
			currentSelection.addEventListener(MouseEvent.CLICK, textSelect);
			addChild(currentSelection);
			
			selectionList = new SelectionList(entryList);
			for (var i:uint = 0; i < entryList.length; i++) {
				SelectionList(selectionList).entries[i].addEventListener(MouseEvent.MOUSE_DOWN, listEntryClicked);
			}
			selectionList.x = currentSelection.x;
			selectionList.y = currentSelection.height + 2;
			
			dropDownButton = new DropDownButton();
			repositionDropDownList(0);
			dropDownButton.addEventListener(MouseEvent.CLICK, expandList)
			addChild(dropDownButton);		
		}
		public function listEntryClicked(e:Event):void {
			var index:uint = e.target.parent.getChildIndex(e.target);
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFFFF;
			TextField(selectionList.getChildAt(index)).backgroundColor = 0xFFFF00;
			currentLine = index;
			selectionList.addEventListener(MouseEvent.MOUSE_UP, collapseList);
			selectionList.addEventListener(MouseEvent.MOUSE_MOVE, checkMousePosition);
		}
		public function checkMousePosition(e:Event):void {
			var mousePt:Point = new Point(stage.mouseX, stage.mouseY);
			var selectedLine:uint;
			for (var i:uint = 0; i < selectionList.numChildren - 1; i++) {
				if (selectionList.getChildAt(i).hitTestPoint(mousePt.x, mousePt.y)) {
					highlightLine(i);
					trace(i);
				}
			}
		}
		public function repositionDropDownList(yOffset:Number):void {
			dropDownButton.x = width - 20; 
			selectionList.y = yOffset + currentSelection.height;
		}
		public function textSelect(e:Event):void {
			highlightCurrentSelection();
			currentSelection.addEventListener(KeyboardEvent.KEY_DOWN, arrowTextSelect);
		}
		public function arrowTextSelect(e:KeyboardEvent):void {
			var key:uint = e.keyCode;
			if (key == Keyboard.DOWN) {
				currentLine = Math.min(selectionList.numChildren - 2, currentLine + 1);				
			} else if (key == Keyboard.UP) {
				currentLine = Math.max(0, currentLine - 1);
			} 
			currentSelection.text = TextField(selectionList.getChildAt(currentLine)).text;
			setInterval(highlightCurrentSelection, 50);
			if (key == Keyboard.ENTER) {
				setInterval(unhighlightCurrentSelection, 50);
				currentSelection.removeEventListener(KeyboardEvent.KEY_DOWN, arrowTextSelect);
			}
		}
		public function highlightCurrentSelection():void {
			currentSelection.setSelection(0, currentSelection.length);
		}
		public function unhighlightCurrentSelection():void {
			currentSelection.setSelection(0, 0);
		}
		public function expandList(e:Event) {
			listExpanded = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clearDropDownLists)		
			parent.addChildAt(selectionList, parent.numChildren - 1);
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFF00;
			stage.focus = currentSelection;
			currentSelection.addEventListener(KeyboardEvent.KEY_DOWN, arrowListSelect);			
			var clickPt:Point = new Point(stage.mouseX, stage.mouseY);		
		}
		public function clearDropDownLists(e:Event):void {
			if (!hitTestPoint(stage.mouseX, stage.mouseY)) {
				collapseList();
			}
		}
		public function arrowListSelect(e:KeyboardEvent):void {
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFFFF;
			var key:uint = e.keyCode;
			if (key == Keyboard.DOWN) {
				currentLine = Math.min(selectionList.numChildren - 2, currentLine + 1);				
			} else if (key == Keyboard.UP) {
				currentLine = Math.max(0, currentLine - 1);
			} 
			currentSelection.text = TextField(selectionList.getChildAt(currentLine)).text;
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFF00;
			setInterval(highlightCurrentSelection, 50);
			if (key == Keyboard.ENTER) {
				setInterval(unhighlightCurrentSelection, 50);
				currentSelection.removeEventListener(KeyboardEvent.KEY_DOWN, arrowListSelect);
				collapseList();
			}
		}
		public function collapseList(...args) {
			if (listExpanded) parent.removeChild(selectionList);
			listExpanded = false;
			selectionList.removeEventListener(MouseEvent.MOUSE_MOVE, checkMousePosition);
			currentSelection.text = TextField(selectionList.getChildAt(currentLine)).text;
		}
		public function highlightLine(n:uint):void {
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFFFF;
			currentLine = n;
			TextField(selectionList.getChildAt(currentLine)).backgroundColor = 0xFFFF00;			
		}
	}
}

import flash.display.*;
import flash.geom.*;
import flash.util.trace;
import flash.text.TextFormat;

class ListEntry extends TextField {
	public function ListEntry() {
		defaultTextFormat = new TextFormat("Courier", 12);
		background = true;
		backgroundColor = 0xFFFFFF;
		width = 125;
		type = TextFieldType.DYNAMIC;
		wordWrap = true;
		height = 20;
		x = 80;
	}
}	

class SelectionList extends Sprite {
	public var entries:Array;
	public function SelectionList(entryList:Array):void {
		entries = new Array();
		for (var i:uint=0; i < entryList.length ; i++) {
			entries[i] = new ListEntry();
			entries[i].x = 0;
			entries[i].text += entryList[i].toString();
			if (i > 0) {
				entries[i].y = entries[i - 1].y + entries[i - 1].height;
			}
			addChild(entries[i]);
		}	
		var outline:Shape = new Shape();
		outline.graphics.lineStyle(1, 0x000000);
		outline.graphics.drawRect(0, 0, width, height);
		addChild(outline);
	}	
}
class DropDownButton extends SimpleButton {
	public function DropDownButton() {
		upState = new DropDownButtonState();
		hitTestState = upState;
		overState = upState;
		downState = new DropDownButtonState();
		var downStateTransform:Transform = downState.transform;
		const downShadeMultiplier:Number = 0.75;
		downStateTransform.colorTransform = new ColorTransform(downShadeMultiplier, downShadeMultiplier, downShadeMultiplier);
		downState.transform = downStateTransform;
		
	}
}

class DropDownButtonState extends Sprite {
	public function DropDownButtonState() {
		const size:Number = 19;
		const sideMargin:Number = 7;
		const topMargin:Number = 8;
		graphics.lineStyle(1, 0x000000);
		graphics.beginFill(0xDDDDDD);
		graphics.drawRect(1, 1, size, size);
		graphics.moveTo(sideMargin, topMargin);
		graphics.beginFill(0x000000);
		graphics.lineTo(size - sideMargin, topMargin);
		graphics.lineTo(size / 2, size - topMargin);
		graphics.lineTo(sideMargin, topMargin);
	}
}		