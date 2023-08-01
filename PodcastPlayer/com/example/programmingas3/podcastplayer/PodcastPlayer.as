package com.example.programmingas3.podcastplayer
{
	import com.example.programmingas3.podcastplayer.RSSItem;
	import com.example.programmingas3.utils.DateUtil;
	import com.example.programmingas3.podcastplayer.URLService;
	import com.example.programmingas3.podcastplayer.RSSChannel;
	import com.example.programmingas3.podcastplayer.PlayButtonRenderer;
	
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;
	import fl.events.DataGridEvent;
	import fl.events.ListEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;	
	import flash.events.IOErrorEvent;	
	import flash.events.SecurityErrorEvent;	
	
	public class PodcastPlayer extends MovieClip
	{
		public var service:URLService;
		
		public var feeds:XMLList;
		public var feedArray:Array;
		public var articles:XMLList;
		
		public var currentFeed:RSSChannel;
		
		public const PLAY_COLUMN:int = 2;
		
		public function PodcastPlayer():void
		{
			var col1:DataGridColumn = new DataGridColumn("publishDate");
			col1.headerText = "date";
			col1.sortOptions = Array.NUMERIC;
			col1.labelFunction = formatDateColumn;
			col1.width = 90;
			
			var col2:DataGridColumn = new DataGridColumn("title");
			col2.headerText = "Title";
			col2.width = 220;
			
			var col3:DataGridColumn = new DataGridColumn("Play");
			col3.cellRenderer = PlayButtonRenderer;
			col3.width = 70;
			
			this.articleGrid.addColumn(col1);
			this.articleGrid.addColumn(col2);
			this.articleGrid.addColumn(col3);
			
			this.articleGrid.addEventListener(fl.events.ListEvent.ITEM_CLICK , onGridPlay);
			this.feedList.addEventListener(Event.CHANGE, onFeedSelected); 
			
			var configService:URLService = new URLService("playerconfig.xml");
			configService.addEventListener(DataEvent.DATA, onConfigReceived);
			configService.addEventListener(IOErrorEvent.IO_ERROR, onFeedError);
			configService.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFeedError);
			configService.send();
		}
		
		public function onConfigReceived(event:DataEvent):void
		{
			var result:XML = new XML(event.data);
			this.feeds = result.feed;
			trace("feeds.length()=" + this.feeds.length());
			
			// convert the XMLList to an array of objects
			var feedObj:Object;
			this.feedArray = new Array();
			for each (var feed:XML in this.feeds)
			{
				feedObj = { label:feed.label, url:feed.url };
				this.feedArray.push(feedObj);
			}

			this.feedList.dataProvider = new DataProvider(this.feedArray);
			this.feedList.selectedIndex = 0;
			this.feedList.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function onFeedSelected(event:Event):void
		{
			var url:String = feedList.selectedItem.url.toString();
			if (url != null)
			{
				service = new URLService(url);
				service.addEventListener(DataEvent.DATA, onFeedReceived);
				service.addEventListener(IOErrorEvent.IO_ERROR, onFeedError);
				service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFeedError);
				service.send();
			}
		}
		
		public function onFeedReceived(event:DataEvent):void
		{
			var result:XML = new XML(event.data);
			
			var channelXML:XMLList = result.child("channel");
			if (channelXML != null)
			{
				this.currentFeed = RSSChannel.parseFeed(channelXML[0]);
				
				// massage the data so the DataGrid is happy
				for each (var item:RSSItem in this.currentFeed.items)
				{
					item["Play"] = "Play";
					if (item.duration == "null")
					{
						item.duration = "";
					}
				}
			   
				if (this.currentFeed != null)
				{
					this.articleGrid.dataProvider = new DataProvider(this.currentFeed.items);
					this.feedImg.source = this.currentFeed.imageUrl;
				
					this.feedDescriptionTxt.htmlText = this.currentFeed.getDescriptionHTML();
				}
			}
		}
		
		public function onFeedError(event:ErrorEvent):void
		{
			showError(new Error(event.text));
		}
		
		/**
		 * A common method for displaying error messages.
		 * Should be enhanced to show a dialog box with an error message.
		 */		
		public function showError(e:Error):void
		{
			trace("Error: " + e.message);
		}
		
		/**
		 * Called when the Play button is clicked inside a row of the grid.
		 */
		public function onGridPlay(evt:ListEvent):void
		{
			trace("onGridPlay col=" + evt.columnIndex + ", url=" + evt.item.soundUrl);
			if (evt.columnIndex == PLAY_COLUMN)
			{
				var item:Object = evt.item;
				var title:String = item.title;
				if (item.soundUrl != null)
				{
					this.player.load(item.soundUrl, title);
				}
			}
		}
		
		public function formatDateColumn(data:Object):String
		{
			// remove milliseconds
			var dateStr:String = DateUtil.formatShort(data.publishDate);
			return dateStr;
		}
		
		public function formatDurationColumn(data:Object):String
		{
			var durStr:String = data.duration;
			return durStr as String;
		}
	}

}