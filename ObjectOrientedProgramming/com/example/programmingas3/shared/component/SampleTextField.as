package com.example.programmingas3.shared.component
{
	import flash.display.TextField;
	import flash.text.TextFormat;
	import flash.util.trace;
	
	import com.example.programmingas3.shared.component.SampleComponent;

	/**
	 * A simple text field with a border and a default TextFormat.
	 * By defualt it shows a background and a border. The background
	 * changes colors when you change the selectable property.
	 */
	public class SampleTextField extends SampleComponent 
	{
		/**
		 * The main TextField instance used for display.
		 */
		public var field:TextField;

		/**
		 * A static default available to all instances.
		 */
		protected static var defaultFormat:TextFormat = null;

  		/**
		 * The TextFormat object of this particular SampleTextField.
		 */
		protected var _format:TextFormat;

		/**
		 * You can pass in a TextFormat object to the constructor. If none is passed in it will use
		 * the static defaultFormat object.
		 */			
		public function SampleTextField(w:uint, h:uint, textFormat:TextFormat = null, selectable:Boolean = true) 
		{
			// defaults to a single-pixel black border
			super();
			
			field = new TextField();
			
			//trace("w=" + w + ", h=" + h);
			if (w > 0)
			{
				this.w = w;
				field.width = w;
			}
			if (h > 0)
			{
				this.h = h;
				field.height = h;
			}
			
			this.selectable = selectable;
			
			field.wordWrap = true;
			field.autoSize = TextFieldAutoSize.NONE;
			
			// if this is the first SampleTextField to be instantiated, it must prime the default format
			if (SampleTextField.defaultFormat == null)
			{
				SampleTextField.defaultFormat = getTextFormat();
			}

			// if a TextFormat object is passed in, use it, otherwise use the default			
			if (textFormat == null)
			{
				this._format = SampleTextField.defaultFormat;
			}
			else
			{
				this._format = textFormat;
			}
		}
		
		public override function init():void 
		{
			this.field.defaultTextFormat = this._format;
			
			this.addChild(field);
			
			//this.draw();
		}

		
		private function getTextFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = false;
			return format;
		}
		
		public override function draw():void 
		{
			//trace("SampleTextField.draw()");
			super.draw();
		}

		/**
		 * The contents of the text field. 
		 * Sets it to a blank string if the value comes in as null or undefined.
		 */
		public function get text():String
		{
			return field.text;
		}
		public function set text(str:String):void 
		{
			if (str == null || str == undefined)
			{
				str = "";
			}
			field.text = str;
		}
		
		/**
		 * The background color to use when the field contents are editable.
		 */		
		public var _selectableColor:Number = 0xFFFFFF;
		
		public function get selectableColor():Number
		{
			return _selectableColor;
		}
		public function set selectableColor(color:Number):void
		{
			this._selectableColor = color;
			if (this.field.selectable)
			{
				this.backgroundColor = color;
			}
		}
		
		/**
		 * The background color to use when the field contents cannot be edited.
		 */
		public var _unselectableColor:Number = 0xEEEEEE;
		
		public function get unselectableColor():Number
		{
			return _unselectableColor;
		}
		public function set unselectableColor(color:Number):void
		{
			this._unselectableColor = color;
			if (!this.field.selectable)
			{
				this.backgroundColor = color;
			}
		}
		
		/**
		 * The background color to use when the field contents cannot be edited.
		 */
		public function get selectable():Boolean
		{
			return field.selectable;
		}
		public function set selectable(isSelectable:Boolean):void
		{
			//trace("setting selectable=" + isSelectable);
			
			field.selectable = isSelectable;
			if (isSelectable)
			{
				this.backgroundColor = this._selectableColor;
				field.backgroundColor = this._selectableColor;
			}
			else
			{
				this.backgroundColor = this._unselectableColor;
				field.backgroundColor = this._unselectableColor;
			}
		}
	}
}
