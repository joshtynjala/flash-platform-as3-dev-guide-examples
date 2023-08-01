package com.example.programmingas3.newslayout 
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.text.TextLineMetrics;
	import flash.text.TextField;

	/**
	 * 
	 */
	public class FormattedTextField extends flash.text.TextField
	{
		private var _format:TextFormat;
		
		public var preferredWidth:Number = 300;
		public var preferredHeight:Number = 100;
		
		public function FormattedTextField(tf:TextFormat = null) 
		{
			super();
			
			this.autoSize = TextFieldAutoSize.NONE;
			this.wordWrap = true;

			if (tf != null)
			{
				_format = tf;
			}
			else
			{
				_format = getDefaultTextFormat();
			}
			
			//this.setStyle(_format);
		}
		
		private function getDefaultTextFormat():TextFormat 
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.size = 10;
			format.bold = false;
			format.leading = 0;
			return format;
		}
				
		public function changeFace(faceName:String="Verdana"):void
		{
			if (faceName != null)
			{
				this._format.font = faceName;
				this.setTextFormat(this._format);
			}
		}

		public function changeSize(size:uint=12):void
		{
			if (size > 5)
			{
				this._format.size = size;
				this.setTextFormat(this._format);
			}
		}

		public function changeBold(isBold:Boolean = false):void
		{
			//this.setStyle("fontWeight", isBold ? "bold" : "normal");
			this._format.bold = isBold;
			this.setTextFormat(this._format);
		}
		
		public function changeItalic(isItalic:Boolean = false):void
		{
			//this.setStyle("fontStyle", isItalic ? flash.text.FontStyle.ITALIC : flash.text.FontStyle.REGULAR );
			this._format.italic = isItalic;
			this.setTextFormat(this._format);
		}

		public function changeNormal(isNormal:Boolean = false):void
		{
			this._format.italic = false;
			this._format.bold = false;
			this.setTextFormat(this._format);
		}
				
		public function changeSpacing(spacing:int=1):void
		{
			if (spacing > -10 && spacing < 100)
			{
				this._format.letterSpacing = spacing;
				this.setTextFormat(this._format);
			}
		}
		
		public function changeLeading(leading:int=0):void
		{
			if (leading > -100 && leading < 100)
			{
				this._format.leading = leading;
				this.setTextFormat(this._format);
			}
		}

		public function changeAlign(align:String = "left"):void
		{
			if (align == TextFormatAlign.LEFT || align == TextFormatAlign.RIGHT ||
				align == TextFormatAlign.JUSTIFY || align == TextFormatAlign.CENTER)
			{
				this._format.align = align;
				this.setTextFormat(this._format);
			}
		}
	}
}