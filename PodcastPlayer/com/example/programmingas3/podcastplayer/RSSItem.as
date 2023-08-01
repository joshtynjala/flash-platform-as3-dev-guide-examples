package com.example.programmingas3.podcastplayer
{
    public dynamic class RSSItem extends RSSBase
    {
        public static const STATUS_NEW:String = "new";
        public static const STATUS_LOADING:String = "loading";
        public static const STATUS_LOADED:String = "loaded";
        public static const STATUS_PLAYING:String = "playing";
        public static const STATUS_PLAYED:String = "played";

        // Required RSS 2.0 elements
        public var author:String;
        public var guid:Object; // contains @isPermaLink and text
        public var _enclosure:Object;
        
        [Bindable]
        public var soundUrl:String;
        
        // derived values
        public var size:int;
        public var duration:Object;
        
        // playback info
        public var status:String;
        public var pausePosition:Number;
        public var timesPlayed:int = 0;
        public var timesCompleted:int = 0;
        
        public function get enclosure():Object
        {
            return this._enclosure;
        }
        
        public function set enclosure(elemObj:Object):void
        {
            var element:XML = elemObj as XML;
            var obj:Object = new Object();
            
            var attrib:String = getAttribute(element, "url");
            if (attrib != null)
            {
                this.soundUrl = attrib;
                obj.url = attrib;
            }
            
            attrib = getAttribute(element, "type");
            if (attrib != null)
            {
                this.contentType = attrib;
                obj.type = attrib;
            }
            
            attrib = getAttribute(element, "length");
            if (attrib != null)
            {
                this.size = int(attrib);
                obj.length = attrib;
            }
            this._enclosure = obj;
        }
 
 		public static function parseItem(itemXml:XML):RSSItem
		{
		    var newItem:RSSItem = new RSSItem();

		    var kids:XMLList = itemXml.children();
		    var elementName:String;
		    var propName:String;
		    for each (var element:XML in kids)
		    {
		        elementName = element.name();
		        
		        // handle itunes names
		        var iTunesIndex:int = element.name().toString().indexOf("itunes");
		        if (iTunesIndex >= 0)
		        {
		            propName = "itunes_" + element.localName();
		        }
		        else
		        {
		            propName = elementName;
		        }
		        
		        var atts:XMLList = element.attributes();
                if (element.hasSimpleContent() && element.attributes().length() == 0)
                {
                    newItem[propName] = element.toString();  
                }
                else
                {
                    newItem[propName] = element;
                }
		    }
			return newItem;
		}
		
		public function getDescriptionHTML():String
		{
		    var html:String = "";

		    if (this.subtitle != null)
		    {
		        html += "<p><b>" + this.subtitle + "</b></p>";
		    }

		    if (this.description != null)
		    {
		        html += "<p>" + this.description + "</p>";
		    }
		    else if (this.summary != null)
		    {
		        html += "<p>" + this.summary + "</p>";
		    }
		    
		    return html;
		}
		
		public function getDuration():String
		{
		    if (this.duration == null)
		    {
		        if (this["itunes_duration"] == null)
		        {
		            return "";
		        }
		        else
		        {
		            return this["itunes_duration"].toString();
		        }
		    }
		    return this.duration.toString();
		}
		       
    }
}