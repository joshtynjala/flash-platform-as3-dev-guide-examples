package com.example.programmingas3.podcastplayer
{
    import com.example.programmingas3.utils.DateUtil;
    import flash.geom.Point;
    
    public dynamic class RSSChannel extends RSSBase
    {
         /*
		     * title
		     * description or itunes:summary
		     * itunes:subtitle
		     * copyright
		     * language
		     * link
		     * pubDate
		     * itunes:category (recursive)
		     * itunes:keywords
		     * image->url,title,link or itunes:image
		     * itunes:explicit
         */ 
         
        /*
        *  The following RSS 2.0 elements are defined in the RSSBase superclass
        
        // Required RSS 2.0 elements
        public var title:String;
        public var link:String;
        public var description:String;
        public var pubDate:String;
        public var category:String;
        
        // derived values
        public var categoryArray:Array;
        public var publishDate:Date;
        */
        
        // ITunes RSS 2.0 elements
        public var subtitle:String;
        public var summary:String;
        
        // Optional RSS 2.0 elements        
        public var author:String;
        public var content:Object; // contains fileSize, rating, type, uid, url
        public var contentType:String;
        public var copyright:String;
        public var language:String;
        public var webMaster:String;
        public var managingEditor:String;
        
        public var guid:String;
        public var _keywords:String;

        public var origLink:String;
        public var _lastBuildDate:String;
        public var lastPublishDate:Date;

        public var uid:String;
        
        public var keywordsArray:Array;
        
        public var items:Array;

        public function get keywords():String
        {
            return this._keywords;
        }
                        
        public function set keywords(keywordStr:String):void
        {
            this._keywords = keywordStr;
            
            var delim:String = " ";
            if (keywordStr.indexOf(", ") > 0)
            {
                delim = ", ";
            }
            else if (keywordStr.indexOf(", ") > 0)
            {
                delim = ",";
            }
            this.keywordArray = keywordStr.split(delim);
        }
        
        public function get lastBuildDate():String
        {
            return this._lastBuildDate;
        }
            
        public function set lastBuildDate(dateStr:String):void
        {
            if (dateStr != null)
            {
                this._lastBuildDate = dateStr;
                this.lastPublishDate = DateUtil.parseRFC822(dateStr);
            }
        }
        
 		public static function parseFeed(channelXml:XML):RSSChannel
		{
		    var feed:RSSChannel = new RSSChannel();

		    var kids:XMLList = channelXml.children();
		    var elementName:String;
		    var propName:String;
		    for each (var element:XML in kids)
		    {
		        elementName = element.localName();
		        if (elementName != "item")
		        {
    		        // handle itunes names
    		        var iTunesIndex:int = element.name().toString().indexOf("itunes");
    		        if (iTunesIndex >= 0)
    		        {
    		            propName = "itunes_" + elementName;
    		        }
    		        else
    		        {
    		            propName = elementName;
    		        }
    		        
                    if (element.hasSimpleContent() && element.attributes().length() == 0)
                    {
                        feed[propName] = element.toString();  
                    }
                    else
                    {
                        feed[propName] = element;
                    }
                }
		    }
		    
		    var itemArray:Array = new Array();
		    var itemObj:Object;
		    var itemList:XMLList = channelXml.item;
		    for each (var itemXml:XML in itemList)
		    {
		        itemObj = RSSItem.parseItem(itemXml);
		        itemArray.push(itemObj);
		    }
		    feed.items = itemArray;
			
			return feed;
		}
		
		public function getFullHTML():String
		{
		    var html:String = "";
		    if (this.imageUrl != null)
		    {
		        html += "<img src='" + this.imageUrl + "' />";
		    }

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
		    
		    if (this.link != null)
		    {
		        html += "<p><font color='#0000cc'><a href='" + this.link + "' target='_blank'>[link]</a></font></p>";
		    }
		    		    
		    return html;
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
		    
		    if (this.link != null)
		    {
		        html += "<p><font color='#0000cc'><a href='" + this.link + "' target='_blank'>[link]</a></font></p>";
		    }
		    
		    return html;
		}	
			
		public function getImageSize():Point
		{
		    var p:Point = new Point(88, 31);
		    if (this.image != null)
		    {
    		    var h:int = int(this.image.height);
    		    var w:int = int(this.image.width);
    		    if (this.image.height > 31 || this.image.width > 88)
    		    {
    		        p = new Point(w, h);
    		    }
    		}
    		return p;
		}
    }
}