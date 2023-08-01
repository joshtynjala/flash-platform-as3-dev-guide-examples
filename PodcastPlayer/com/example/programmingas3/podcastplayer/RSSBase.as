package com.example.programmingas3.podcastplayer
{
    import com.example.programmingas3.utils.DateUtil;
    import flash.events.EventDispatcher;
    
    /**
     * This class contains properties that are common to both an RSSChannel and an RSSItem.
     */
    public dynamic class RSSBase extends EventDispatcher
    {
        // Required RSS 2.0 elements
        public var title:String;
        public var link:String;
        public var description:String;
        private var _pubDate:String;
        private var _category:Object;

        public var imageUrl:String; 
        private var _image:Object;
                
        // derived values
        public var categoryArray:Array = new Array();
        public var publishDate:Date;
    
        public function set pubDate(dateStr:String):void
        {
            this._pubDate = dateStr;
            if (dateStr != null)
            {
                this.publishDate = DateUtil.parseRFC822(dateStr);
            }  
        }
        
        public function get pubDate():String
        {
            return _pubDate;
        } 
  
        public function get category():Object
        {
            return _category;
        }
           
        public function set category(catObj:Object):void
        {
            if (catObj != null)
            {
                var catXml:XML = catObj as XML;
                if (catXml != null && catXml.attributes().length() > 0)
                {
                    var domain:String = getAttribute(catXml, "domain");
                    var cat:String = getAttribute(catXml, "text");
                    var kittens:XMLList = catXml.children();
                    for (var i:int = 0; i < kittens.length(); i++)
                    {
                        cat += " > " + getAttribute(kittens[0], "text");
                    }
                    while (kittens.length() > 0)
                    {
                        cat += " > " + getAttribute(kittens[0], "text");
                        kittens = kittens[0].children();
                    }
                    
                    this._category = cat;
                    if (this.categoryArray.length > 0)
                    {
                        this.categoryArray.push(cat);
                    }
                    else
                    {
                        this.categoryArray = [ cat ];
                    }
                }
                else
                {
                    this._category = catObj.toString();
                    if (this.categoryArray.length > 0)
                    {
                        this.categoryArray.push( this._category );
                    }
                    else
                    {
                        this.categoryArray = [ this._category ];
                    }
                }
            }       
        }
               
        public function buildCategory(catStr:String, catObj:XML):String
        {
            var subCat:String = getAttribute(catObj, "text");
            if (subCat != null)
            {
                catStr += " > " + subCat;
            }
            
            var kittens:XMLList = catObj.children();
            if (kittens.length() > 0)
            {
                return buildCategory(catStr, kittens[0]);;
            }
            
            return catStr; 
        }
        
        public function get image():Object
        {
            return this._image;
        }
        
        public function set image(elementObj:Object):void
        {
            var element:XML = elementObj as XML;
            var imageObj:Object = new Object();

            if (element.url.length() > 0)
            {
                imageObj.url = getElementText(element, "url");
                imageObj.title = getElementText(element, "title");
                imageObj.link = getElementText(element, "link");
                imageObj.width = getElementText(element, "width");
                imageObj.height = getElementText(element, "height");
                imageObj.description = getElementText(element, "description");
                                
                this.imageUrl = imageObj.url;
                this._image = imageObj;
            }
            else if (element.@href.length() > 0)
            {
                this.imageUrl = getAttribute(element, "href")
                imageObj.url = this.imageUrl;
            }
            this._image = imageObj;
        }
        
        public function set itunes_image(elementObj:Object):void
        {
            this.image = elementObj;
        }
                
    	public static function getAttribute(element:XML, attName:String):String
    	{
    	    var attValue:String = "";
    	    var attribs:XMLList = element.attribute(attName);
    	    if (attribs.length() > 0)
    	    {
    	        attValue = attribs[0].toString();
    	    }
    	    return attValue;
    	}
    	
    	public static function getElementText(parent:XML, elemName:String):String
    	{
    	    var elemText:String = "";
    	    var kids:XMLList = parent.child(elemName);
    	    if (kids.length() > 0)
    	    {
    	        elemText = kids[0].toString();
    	    }
    	    return elemText;
    	}
    }
}