package com.example.programmingas3.newslayout
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Sprite;
	import flash.display.Graphics;

	public class StoryLayout extends Sprite
	{
		public var headlineTxt:HeadlineTextField;
		public var subtitleTxt:HeadlineTextField;
		public var storyTxt:MultiColumnText;
		public var sheet:StyleSheet;
		public var h1Format:TextFormat;
		public var h2Format:TextFormat;
		public var pFormat:TextFormat;
		
		private var loader:URLLoader;
		
		public var paddingLeft:Number;
		public var paddingRight:Number;
		public var paddingTop:Number;
		public var paddingBottom:Number;
		
		public var preferredWidth:Number;
		public var preferredHeight:Number;
		
		public var numColumns:int;
		
		public var bgColor:Number = 0xFFFFFF;
		
		public var headline:String = "News Layout Example";
		public var subtitle:String = "This example formats text like a newspaper page with a headline, a subtitle, and multiple columns. ";

		public var loremIpsum:String = "In ActionScript 3.0, text is usually displayed within a text field, \
but can occasionally appear as a property of an item on the display list (for example, as the label on a UI \
component). This chapter explains how to work with the script-defined contents of a text field and with user \
input, dynamic text from a remote file, or static text defined in Adobe Flash CS3 Professional. \r\
As an ActionScript programmer you can establish specific content for text fields, or designate the \
source for the text, and then set the appearance of that text using styles and formats. You can also respond \
to user events as the user inputs text or clicks a hyperlink.\r\
To display any text on the screen in Adobe Flash Player you use an instance of the TextField class. \
The TextField class is the basis for other text-based components, like the TextArea component or the \
TextInput component, that are provided in the Adobe Flex framework and in the Flash authoring environment.\r\
Text field content can be pre-specified in the SWF file, loaded from an external source like a text file or \
database, or entered by users interacting with your application. Within a text field, the text can appear as \
rendered HTML content, with images embedded in the rendered HTML. Once you establish an instance of a text \
field, you can use flash.text package classes, like the TextFormat class and the StyleSheet class, to control \
the text’s appearance. The flash.text package contains nearly all the classes related to creating, managing, \
and formatting text in ActionScript.\r\
You can format text by defining the formatting with a TextFormat object and assigning that object to the text \
field. If your text field contains HTML text, you can apply a StyleSheet object to the text field to assign \
styles to specific pieces of the text field content. The TextFormat object or StyleSheet object contains \
properties defining the appearance of the text, such as color, size, and weight. The TextFormat object assigns \
the properties to all the content within a text field or to a range of text.";
		 
		public function StoryLayout(w:int = 400, h:int = 200, cols:int = 3, padding:int = 10):void
		{
			this.preferredWidth = w;
			this.preferredHeight = h;
			
			this.numColumns = cols;
			
			this.paddingLeft = padding;
			this.paddingRight = padding;
			this.paddingTop = padding;
			this.paddingBottom = padding;
			
			var req:URLRequest = new URLRequest("story.css");
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onCSSFileLoaded);
			loader.load(req);
		}
		
		public function onCSSFileLoaded(event:Event):void
		{
			this.sheet = new StyleSheet(); 
			this.sheet.parseCSS(loader.data);
			
			// convert headline styles to TextFormat objects
			h1Format = getTextStyle("h1", this.sheet);
			if (h1Format == null)
			{
				h1Format = getDefaultHeadFormat();
			}

			h2Format = getTextStyle("h2", this.sheet);
			if (h2Format == null)
			{
				h2Format = getDefaultHeadFormat();
				h2Format.size = 16;
			}
			
			pFormat = getTextStyle("p", this.sheet);
			if (pFormat == null)
			{
				pFormat = getDefaultTextFormat();
				pFormat.size = 12;
			}
			
			displayText();
		}
		
		public function drawBackground():void
		{
		    var h:Number = this.storyTxt.y + this.storyTxt.height + this.paddingTop + this.paddingBottom;
		    var g:Graphics = this.graphics;
		    g.beginFill(this.bgColor);
		    g.drawRect(0, 0, this.width + this.paddingRight + this.paddingLeft, h);
		    g.endFill();
		}
		
		/**
		 * Reads a set of style properties for a named style and then creates
		 * a TextFormat object that uses the same properties.
		 */
        public function getTextStyle(styleName:String, ss:StyleSheet):TextFormat
        {
        	var format:TextFormat = null;
        	
        	var style:Object = ss.getStyle(styleName);
        	if (style != null)
        	{
        		var colorStr:String = style.color;
        		if (colorStr != null && colorStr.indexOf("#") == 0)
        		{
        			style.color = colorStr.substr(1);
        		}
        		format = new TextFormat(style.fontFamily, 
        							  style.fontSize, 
        							  style.color, 
        							  (style.fontWeight == "bold"), 
        							  (style.fontStyle == "italic"), 
        							  (style.textDecoration == "underline"), 
        							  style.url, 
        							  style.target, 
        							  style.textAlign, 
        							  style.marginLeft, 
        							  style.marginRight,
        							  style.indent,
        							  style.leading);
        		
        		if (style.hasOwnProperty("letterSpacing"))		
        		{				  
        			format.letterSpacing = style.letterSpacing;
        		}
        	}
        	return format;
        }

        public function getDefaultHeadFormat():TextFormat
        {
        	var tf:TextFormat = new TextFormat("Arial", 20, 0x000000, true);
        	return tf;
        }
        
        public function getDefaultTextFormat():TextFormat
        {
        	var tf:TextFormat = new TextFormat("Georgia", 12, 0x000000, true);
        	return tf;
        }
			
        public function displayText():void
        {        
        	headlineTxt = new HeadlineTextField(h1Format);			
        	headlineTxt.wordWrap = true;
        	headlineTxt.x = this.paddingLeft;
        	headlineTxt.y = this.paddingTop;
        	headlineTxt.width = this.preferredWidth;
        	this.addChild(headlineTxt);
        	
        	headlineTxt.fitText(this.headline, 1, true);
        	
        	subtitleTxt = new HeadlineTextField(h2Format); 
        	subtitleTxt.wordWrap = true;
        	subtitleTxt.x = this.paddingLeft;
        	subtitleTxt.y = headlineTxt.y + headlineTxt.height;
        	subtitleTxt.width = this.preferredWidth;
        	this.addChild(subtitleTxt);			
            
            subtitleTxt.fitText(this.subtitle, 2, false);
		            	
        	storyTxt = new MultiColumnText(this.numColumns, 
        	                                20, 
        	                                this.preferredWidth, 
        	                                this.preferredHeight, 
        	                                this.pFormat);
        	storyTxt.x = this.paddingLeft;
        	storyTxt.y = subtitleTxt.y + subtitleTxt.height + 10;
        	this.addChild(storyTxt);
        	
        	storyTxt.text = loremIpsum;
        	
            drawBackground();
        }
	}
}