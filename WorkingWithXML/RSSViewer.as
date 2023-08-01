package {
	import com.example.controls.ExampleContainer;
	import com.example.display.LabelTextField;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.util.trace;
	
	public class RSSViewer extends ExampleContainer {
		public var url:String = "./RSSData/ak.rss" //http://www.weather.gov/alerts/ak.rss";
		public var rssXML:XML;
		public var rssOutput:LabelTextField;
		public var rssTitle:LabelTextField;
		private var myLoader:URLLoader;
		public function RSSViewer() {
			title.text = "RSS Viewer Example";
			init();
			getRssData(url);
		}
		public function getRssData(url:String):void 
		{
			private var rssXMLURL:URLRequest = new URLRequest(url);
			myLoader = new URLLoader(rssXMLURL);
			myLoader.addEventListener("complete", xmlLoaded);
		}
		public function xmlLoaded(evtObj:Event) { 
			rssXML = XML(myLoader.data);
			var outXML:XML = <span />;
			for each (var item:XML in rssXML.channel.item) {
				var heading:XML = <div></div>;
				heading.b = item.title.toString() + "\n";
				heading = heading.b[0];
				var body:XML = <div></div>;
				body.p = item.description.toString() + "\n";
				var link:XML = <a></a>;
				link.font = "More...\n";
				link.font.@color = "#008000";
				link.@href = item.link.toString();
				body.appendChild(link);
				outXML.appendChild(heading);
				outXML.appendChild(body);
			}
			rssOutput.inputTextField.htmlText = outXML.toXMLString();		
			rssTitle.inputTextField.text = rssXML.channel.title.toString();
			
		}
		public function init():void {
			rssTitle = new LabelTextField("RSS Feed Title:", "", 40);
			rssTitle.inputTextField.wordWrap = true;
			addChild(rssTitle);			

			rssOutput = new LabelTextField("RSS Output:", "", 200);
			rssOutput.inputTextField.wordWrap = true;
			addChild(rssOutput);
			arrangeTextFields();
		}
	}
}

			//"http://www.weather.gov/alerts/ca.rss"
			//"http://www.nasa.gov/rss/breaking_news.rss";
			//"http://rss.news.yahoo.com/rss/mostviewed";
			//"http://www.macromedia.com/cfusion/webforums/forum/rss.cfm?forumid=68";
			//"http://rss.news.yahoo.com/rss/topstories"; 

