package com.example.programmingas3.podcastplayer
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SecurityErrorEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.DataEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
	/**
	 * A convenience class that loads data from a URL and handles
	 * all the resulting events.
	 */
    public class URLService extends EventDispatcher
    {
        public var url:String;
        //public var rssData:String;
        public var loader:URLLoader;
        
        public function URLService(url:String):void
        {
            this.url = url;
        }
        
        public function send():void
        {
            loader = new URLLoader();
            var request:URLRequest = new URLRequest(this.url);
            
            loader.addEventListener(Event.COMPLETE, onLoadComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            
            loader.load(request);
        }
        
        public function onLoadComplete(event:Event):void
        {
            var loaded:URLLoader = event.target as URLLoader;
            if (loaded != null && loaded.data != null)
            {
                //this.rssData = loaded.data;
                
                var dataEvent:DataEvent = new DataEvent(DataEvent.DATA);
                dataEvent.data = loaded.data;
                dispatchEvent(dataEvent);
            }
            else
            {
                trace("No data was received.");
                
                var errorEvent:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
                errorEvent.text = "No data was received.";
                dispatchEvent(errorEvent);
            }
        }

        public function onHTTPStatus(event:HTTPStatusEvent):void
        {
            trace("HTTPStatus: " + event.status);
            var newEvent:Event = event.clone();
            dispatchEvent(newEvent);
        }

        public function onLoadProgress(event:ProgressEvent):void
        {
            trace("Progress: " + event.bytesLoaded + "/" + event.bytesTotal + " = " + 100 * (event.bytesLoaded / event.bytesTotal) + "%");
            var newEvent:Event = event.clone();
            dispatchEvent(newEvent);
        }
                
        public function onIOError(event:IOErrorEvent):void
        {
            trace("IOError: " + event.text);
            var newEvent:Event = event.clone();
            dispatchEvent(newEvent);
        }
        
        public function onSecurityError(event:SecurityErrorEvent):void
        {
            trace("SecurityError: " + event.text);
            var newEvent:Event = event.clone();
            dispatchEvent(newEvent);
        }
    }
}