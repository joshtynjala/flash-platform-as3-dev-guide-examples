package com.example.programmingas3.newslayout
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.events.TextEvent;
	import flash.events.Event;

	public class MultiColumnText extends Sprite
	{
		public var fieldArray:Array;
		
		public var numColumns:uint = 2;
		
		public var lineHeight:uint = 16;
		public var linesPerCol:uint = 15;
		
		/**
		 * The space between columns.
		 */
		public var gutter:uint = 10;
		
		public var format:TextFormat;
		public var lastLineFormat:TextFormat;
		public var firstLineFormat:TextFormat;
		
		private var _text:String = "";
		
		public var preferredWidth:Number = 400;
		public var preferredHeight:Number = 100;

		/**
		 * The width of each column.
		 */
		public var colWidth:int = 200;
		
		
		public function MultiColumnText(cols:uint = 2, 
			gutter:uint = 10, w:Number = 400, h:Number = 100, 
			tf:TextFormat = null):void
		{
			this.numColumns = Math.max(1, cols);
			this.gutter = Math.max(1, gutter);
			
			this.preferredWidth = w;
			this.preferredHeight = h;
			
			if (tf != null)
            {
				applyTextFormat(tf);
            }
			
			this.setColumnWidth();
			
			this.fieldArray = new Array();
			
			// Create a text field for each column
        	for (var i:int = 0; i < cols; i++)
        	{
        		var field:TextField = new TextField();
				field.multiline = true;
        		field.autoSize = TextFieldAutoSize.NONE;
        		field.wordWrap = true;
        		field.width = this.colWidth;

                if (tf != null)
                {
                    field.setTextFormat(tf);
                }
        		
        		this.fieldArray.push(field);
        		this.addChild(field);
        	}
		}
		
		public function applyTextFormat(tf:TextFormat):void
		{
            this.format = tf;
            
            // The last line format starts as a direct copy
			this.lastLineFormat = new TextFormat(tf.font, tf.size, tf.color, tf.bold, 
                                                  tf.italic, tf.underline, tf.url, 
                                                  tf.target, tf.align, tf.leftMargin, 
                                                  tf.rightMargin, tf.indent, tf.leading);
			this.lastLineFormat["letterSpacing"] = this.format["letterSpacing"];
                                      
            // The first line format removes the indent value
			this.firstLineFormat = new TextFormat(tf.font, tf.size, tf.color, tf.bold, 
                                                  tf.italic, tf.underline, tf.url, 
                                                  tf.target, tf.align, tf.leftMargin, 
                                                  tf.rightMargin, 0, tf.leading);
			this.firstLineFormat["letterSpacing"] = this.format["letterSpacing"];
		}
		
		/**
		 * Spread the text across multiple text fields.
		 */
        public function layoutColumns():void
        {
        	if (this._text == "" || this._text == null)
        	{
        		return;
        	}
        	
    	    var field:TextField = fieldArray[0] as TextField;
    		field.text = this._text;
    		field.setTextFormat(this.format);

        	this.preferredHeight = this.getOptimalHeight(field);
        	
        	var remainder:String = this._text;
        	var fieldText:String = "";
        	var lastLineEndedPara:Boolean = true;
        	
        	var indent:Number = this.format.indent as Number;
        	
        	for (var i:int = 0; i < fieldArray.length; i++)
        	{
        		field = this.fieldArray[i] as TextField;
        		
				// First set the text for the field so we can find out where the
				// line break will be in the last line of the field
        		//field.width = colWidth;
        		field.height = this.preferredHeight;
    		    field.text = remainder;
    		    
    		    // Apply the text format for to get the lines to all wrap as intended
    		    field.setTextFormat(this.format);
    		    
    		    // Remove indents from the start of each new field, unless the new field
    		    // marks the start of a new paragraph
    		    var lineLen:int;
    		    if (indent > 0 && !lastLineEndedPara && field.numLines > 0)
    		    {
    		        lineLen = field.getLineLength(0);
    		        if (lineLen > 0)
    		        {
    		            field.setTextFormat(this.firstLineFormat, 0, lineLen);
    		        }
    		    }
        		
        		field.x = i * (colWidth + gutter);
        		field.y = 0;
        		
        		remainder = "";
        		fieldText = "";
        		
        		var linesRemaining:int = field.numLines;   	
        		var linesVisible:int = Math.min(this.linesPerCol, linesRemaining);

				// Now copy lines from the text into the field for display
				// purposes. Remaining lines will be saved for the next field.
        		for (var j:int = 0; j < linesRemaining; j++)
        		{
        			if (j < linesVisible)
        			{
        				fieldText += field.getLineText(j);
        			}
        			else
        			{
        				remainder +=  field.getLineText(j);
        			}
        		}
        		
        		field.text = fieldText;
        		
        		// Apply the format again, this time to the exactly-fitting text
        		field.setTextFormat(this.format);
        		
        		// Remove the indent again if needed
    		    if (indent > 0 && !lastLineEndedPara)
    		    {
    		        lineLen = field.getLineLength(0);
    		        if (lineLen > 0)
    		        {
    		            field.setTextFormat(this.firstLineFormat, 0, lineLen);
    		        }
    		    }
        		
        		// Check if a paragraph ends on the last line
    		    var lastLine:String = field.getLineText(field.numLines - 1);
        		var lastCharCode:Number = lastLine.charCodeAt(lastLine.length - 1);
        		
        		if (lastCharCode == 10 || lastCharCode == 13)
        		{
        		    lastLineEndedPara = true;
        		}
        		else
        		{
        		    lastLineEndedPara = false;
        		}
        		
        		// If the last line doesn't end a paragraph, manually justify itif needed
        		if ((this.format.align == TextFormatAlign.JUSTIFY) && (i < fieldArray.length - 1))
        		{
            		if (!lastLineEndedPara)
            		{
                        justifyLastLine(field, lastLine);
            		}
                }
        	}
        }
        
		/**
		 * If the text alignment style is set to "justify" it will not justify the final
		 * line in a paragraph. It also assumes that the last line in a field is the 
		 * final line in a paragraph. Of course when we split text across fields, the 
		 * last line in a field might be in the middle of a paragraph.
		 *
		 * This method "manually" justfies the last line in a text field by changing the 
		 * letter spacing style and applying it to space characters in the line. The effect
		 * is to add additional pixels to each space until the line width matches the 
		 * maximum text width for the field.
		 */
        public function justifyLastLine(field:TextField, lastLine:String):void
        {
         	// boost letter spacing to widen the last line
		    var metrics:TextLineMetrics = field.getLineMetrics(field.numLines - 1);
		    
		    // get the original letter spacing
		    var spacing:Number = this.format.letterSpacing as Number;
		    
		    var maxTextWidth:Number = field.width - 4 - (this.lastLineFormat.leftMargin as Number) - (this.lastLineFormat.rightMargin as Number);
		    
		    // adjust for paragraph indent value
		    var indent:Number = (this.lastLineFormat.indent as Number);
		    if (indent > 0)
		    {
		        var secondToLastLine:String = field.getLineText(field.numLines - 2);
            	var lastCharCode:int = secondToLastLine.charCodeAt(secondToLastLine.length - 1);
        		if (lastCharCode == 10 || lastCharCode == 13)
        		{
                    // previous line was the end of a paragraph, 
                    // so subtract the indent value from this line's max width
                    maxTextWidth -= indent;
        		}
		    }
		    var extraWidth:Number = maxTextWidth - metrics.width;
		    
		    // remove trailing spaces
		    while (lastLine.charAt(lastLine.length - 1) == " ")
		    {
		        lastLine = lastLine.substr(0, lastLine.length - 1);
		    }
		    
		    var wordArray:Array = lastLine.split(" ");
		    var numSpaces:int = wordArray.length - 1;
			// if there aren't any spaces, give up
		    if (numSpaces < 1)
		    {
		        return;
		    }
		    var spaceSize:int = Math.floor(extraWidth / numSpaces) + spacing;
		    this.lastLineFormat.letterSpacing = spaceSize;
            		    
		    var remainingPixels:int = extraWidth % spaceSize;
		    
		    var lastChars:String = lastLine;
		    var lastlineOffset:Number = field.getLineOffset(field.numLines - 1);
		    
		    var sPos:int;
		    var counter:int = -1;
		    
		    for (var i:int = 0; i < numSpaces; i++)
		    {
				// later in the loop add an extra pixel to the spacing
				// to account for the remaining pixels
		        if ((numSpaces - i) == remainingPixels)
		        {
		            this.lastLineFormat.letterSpacing = spaceSize + 1;
		        }
		        
		        sPos = lastChars.indexOf(" ");
		        counter += sPos + 1;
		        field.setTextFormat(this.lastLineFormat, lastlineOffset + counter, lastlineOffset + counter + 1); 
		        lastChars = lastChars.substring(sPos + 1);
		    }
        }
		
		public function set text(str:String):void
		{
			this._text = str;
			layoutColumns();
		}
		
		public function get text():String
		{
			return this._text;
		}

		public function set textFormat(tf:TextFormat):void
		{
			applyTextFormat(tf);
			layoutColumns();
		}
		
		public function get textFormat():TextFormat
		{
			return this.format;
		}
		
		public function setColumnWidth():void
		{
    		this.colWidth = Math.floor( (this.preferredWidth - 
    			((this.numColumns - 1) * this.gutter)) / this.numColumns);    
		}
		
        public function getOptimalHeight(field:TextField):int
        {
        	if (field.text == "" || field.text == null)
        	{
        		return this.preferredHeight;
        	}
        	else
        	{
        		this.linesPerCol = Math.ceil(field.numLines / this.numColumns);
        		
        		// Get the line height based on the font and size being used
        		var metrics:TextLineMetrics = field.getLineMetrics(0);
        		this.lineHeight = metrics.height;
        		var prefHeight:int = linesPerCol * this.lineHeight;

        		// Add 4 pixels as a buffer to account for the standard
        		// 2 pixel TextField border
        		return prefHeight + 4;
        	}
        }
	}
}