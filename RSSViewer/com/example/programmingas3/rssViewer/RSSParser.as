package com.example.programmingas3.rssViewer {
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.*;

	/**
	 * RSSParser includes methods for
	 * converting RSS XML data into HTML text.	
	 */
	public class RSSParser extends EventDispatcher {
		
		/**
		 * The text to use as the title of the application
		 */
		public var sampleTitle:String = "Chapter 14: Working with XML";
		
		/**
		 * The text to use as the description of the application
		 */
		public var sampleDescription:String = "This example shows many concepts from the \"Working with XML\" chapter.";

		/**
		 * The URL of the source RSS data. Alternate URLs are listed as comments.
		 * Note that in order to use RSS data from a network address, the source server
		 * needs to impliment a cross-domain policy file. For details, see the "Flash Player
		 * Security" chapter in the Programming ActionScript 3.0 book.
		 */
		public var url:String = "http://weblogs.macromedia.com/product_feeds/archives/flex/index.rdf" 
								//"./RSSData/ak.rss" 
								// "http://www.weather.gov/alerts/ak.rss"
								
		/**
		 * The XML object containing the source RSS data
		 */
		public var rssXML:XML;
		
		/**
		 * The string that will contain the converted HTML version of the RSS topic data.
		 */
		public var rssOutput:String;
		
		/**
		 * The title of the RSS feed.
		 */
		public var rssTitle:String;
		
		/**
		 * Used to load RSS data.
		 */
		private var myLoader:URLLoader;
		
		/**
		 * An event used to signal that the HTML version of the RSS data has been written.
		 */
		private var dataWritten:Event;
		
		/**
		 * Initiates loading of the RSS data.
		 */
		public function RSSParser() {
			var rssXMLURL:URLRequest = new URLRequest(url);
			myLoader = new URLLoader(rssXMLURL);
			myLoader.addEventListener("complete", xmlLoaded);
		}
		
		/** 
		 * Invoked when the RSS data is loaded. This method parses through the 
		 * XML data by looping through each item element in the XML, extracting
		 * the title description and link elements in the item element. 
		 * The buildHTML() method returns HTML in the form of an XMLList
		 * object, which is converted to the rssOutput string.
		 * The channel.title property of the rssXML is used as the 
		 * title for the RSS feed. When the method is complete, it dispatches
		 * a dataWritten event, which notifies the host application of the
		 * completion.
		 */
		public function xmlLoaded(evtObj:Event):void { 
			rssXML = XML(myLoader.data);
			var outXML:XMLList = new XMLList();
			
			/* The source RSS data may or may not use a namespace to define
			 * its content.
			 */
			if (rssXML.namespace("") != undefined) {
				default xml namespace = rssXML.namespace("");
			}
			for each (var item:XML in rssXML..item) {
				var itemTitle:String = item.title.toString();
				var itemDescription:String = item.description.toString();
				var itemLink:String = item.link.toString();
				outXML += buildItemHTML(itemTitle, 
										itemDescription,
										itemLink);
			}
			XML.prettyPrinting = false;
			rssOutput = outXML.toXMLString();	
			trace(rssOutput);
			rssTitle = rssXML.channel.title.toString();
			
			dataWritten = new Event("dataWritten", true);
			dispatchEvent(dataWritten);
		}
		/**
		 * Builds an XMLList object that represents a segment of HTML code,
		 * based on the three string parameters that define the title, description,
		 * and link information from an RSS item.
		 * 
		 * The return text is of the following form:
		 * 
		 * <p>itemDescription<br/><a href="link"><font color="#008000">More...</font></a></p>
		 * 
		 */
		private function buildItemHTML(itemTitle:String, 
									itemDescription:String,
									itemLink:String):XMLList {
			default xml namespace = new Namespace();
			var body:XMLList = new XMLList();
			body += new XML("<b>" + itemTitle + "</b>");
			var p:XML = new XML("<p>" + itemDescription + "</p>");
			
			var link:XML = <a></a>;
			link.@href = itemLink; // <link href="itemLinkString"></link>
			link.font.@color = "#008000"; // <font color="#008000"></font></a>
											// 0x008000 = green
			link.font = "More...";
			
			p.appendChild(<br/>); 
			p.appendChild(link); 
			body += p;
			return body;
		}	
	}
}