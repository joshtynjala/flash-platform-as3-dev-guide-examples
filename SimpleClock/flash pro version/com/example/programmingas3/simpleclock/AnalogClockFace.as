package com.example.programmingas3.clock
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.text.StaticText;
    import flash.events.*;
    import flash.text.TextField;
    import flash.text.TextFormat;
	
	/**
	 * Displays a round clock face with an hour hand, a minute hand, and a second hand.
	 */
    public class AnalogClockFace extends Sprite
    {
 		/**
		 * The desired width of this component, as opposed to the .width
		 * property which represents tha actual width.
		 */
		public var w:uint = 200;
		
		/**
		 * The desired height of this component, as opposed to the .height
		 * property which represents tha actual height.
		 */
		public var h:uint = 200;
		
	   	/**
    	 * The radius from the center of the clock to the 
    	 * outer edge of the circular face outline.
    	 */
        public var radius:uint;
        
        /**
         * The coordinates of the center of the face.
         */
        public var centerX:int;
        public var centerY:int;
        
        /**
         * The three hands of the clock.
         */
        public var hourHand:Shape;
        public var minuteHand:Shape;
        public var secondHand:Shape;
        
        /**
         * The colors of the background and each hand.
         * These could be set using parameters or 
         * styles in the future.
         */ 
        public var bgColor:uint = 0xEEEEFF;
        public var hourHandColor:uint = 0x003366;
        public var minuteHandColor:uint = 0x000099;
        public var secondHandColor:uint = 0xCC0033;
        
        /**
         * Stores a snapshot of the current time, so it
         * doesn't change while in the middle of drawing the
         * three hands.
         */
        public var currentTime:Date;
        
        /**
         * Contructs a new clock face. The width and
         * height will be equal.
         */  
        public function AnalogClockFace(w:uint) 
        {
			this.w = w;
			this.h = w;
			
			// Rounds to the nearest pixel
			this.radius = Math.round(this.w / 2);
			
			// The face is always square now, so the
			// distance to the center is the same
			// horizontally and vertically
			this.centerX = this.radius;
			this.centerY = this.radius;
        }
        
        /**
         * Creates the outline, hour labels, and clock hands.
         */ 
        public function init():void 
        {
        	// draws the circular clock outline
        	drawBorder();
        	
        	// draws the hour numbers
        	drawLabels();

        	// creates the three clock hands
        	createHands();
        }
        
        /**
        * Draws a circular border.
        */
        public function drawBorder():void
        {
        	graphics.lineStyle(0.5, 0x999999);
        	graphics.beginFill(bgColor);
        	graphics.drawCircle(centerX, centerY, radius);
        	graphics.endFill();
        }
  
  		/**
  		 * Puts numeric labels at the hour points.
  		 */
        public function drawLabels():void
        {
        	for (var i:Number = 1; i <= 12; i++)
        	{
        		// Creates a new TextField showing the hour number
        		var label:TextField = new TextField();
        		label.text = i.toString();
        		
        		// Places hour labels around the clock face.
        		// The sin() and cos() functions both operate on angles in radians.
        		var angleInRadians:Number = i * 30 * (Math.PI/180)
        		
        		// Place the label using the sin() and cos() functions to get the x,y coordinates.
        		// The multiplier value of 0.9 puts the labels inside the outline of the clock face.
        		// The integer value at the end of the equation adjusts the label position,
        		// since the x,y coordinate is in the upper left corner.
        		label.x = centerX + (0.9 * radius * Math.sin( angleInRadians )) - 5;
        		label.y = centerY - (0.9 * radius * Math.cos( angleInRadians )) - 9;
        		
        		// Formats the label text.
        		var tf:TextFormat = new TextFormat();
        		tf.font = "Arial";
        		tf.bold = "true";
        		tf.size = 12;
        		label.setTextFormat(tf);
        		
        		// Adds the label to the clock face display list.
	        	addChild(label);
        	}
        }
        
        /**
        * Creates hour, minute, and second hands using the 2D drawing API.
        */
        public function createHands():void
        {
        	// Uses a Shape since it's the simplest component that supports
        	// the 2D drawing API.
        	var hourHandShape:Shape = new Shape();
        	drawHand(hourHandShape, Math.round(radius * 0.5), hourHandColor, 3.0);
        	this.hourHand = Shape(addChild(hourHandShape));
        	this.hourHand.x = centerX;
        	this.hourHand.y = centerY;
        	
          	var minuteHandShape:Shape = new Shape();
        	drawHand(minuteHandShape, Math.round(radius * 0.8), minuteHandColor, 2.0);
        	this.minuteHand = Shape(addChild(minuteHandShape));
         	this.minuteHand.x = centerX;
        	this.minuteHand.y = centerY;
 
         	var secondHandShape:Shape = new Shape();
        	drawHand(secondHandShape, Math.round(radius * 0.9), secondHandColor, 0.5);
        	this.secondHand = Shape(addChild(secondHandShape));
        	this.secondHand.x = centerX;
        	this.secondHand.y = centerY;
        }
        
        /**
        * Draws a clock hand with a given size, color, and thickness.
        */
        public function drawHand(hand:Shape, distance:uint, color:uint, thickness:Number):void
        {
        	hand.graphics.lineStyle(thickness, color);
        	hand.graphics.moveTo(0, distance);
        	hand.graphics.lineTo(0, 0);
        }
        
       /**
        * Called by the parent container when the display is being drawn.
        */
        public function draw():void
        {
        	// Stores the current date and time in an instance variable
        	currentTime = new Date();
        	showTime(currentTime);
        }
        
        /**
         * Displays the given Date/Time in that good old analog clock style.
         */
        public function showTime(time:Date):void 
        {
        	// Gets the time values
	        var seconds:uint = time.getSeconds();
	        var minutes:uint = time.getMinutes();
	        var hours:uint = time.getHours();
	        
	        // Multiplies by 6 to get degrees
	        this.secondHand.rotation = 180 + (seconds * 6);
	        this.minuteHand.rotation = 180 + (minutes * 6);
	        
	        // Multiplies by 30 to get basic degrees, and then
	        // adds up to 29.5 degrees (59 * 0.5) to account 
	        // for the minutes
	        this.hourHand.rotation = 180 + (hours * 30) + (minutes * 0.5);
		}
    }
}