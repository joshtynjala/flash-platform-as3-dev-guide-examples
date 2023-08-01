package com.example.programmingas3.podcastplayer 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.Timer;

    /**
     * Provides a slightly simpler interface to the sound-related classes in the 
     * flash.media package. Dispatches "playProgress" ProgressEvents and adds 
     * pause and resume functionality.
     */ 
	public class SoundFacade extends EventDispatcher
	{
	    /**
	     * The Sound object used to load the sound file.
	     */
		public var s:Sound;
		
	    /**
	     * The SoundChannel object used to play and track playback progess
	     * of the sound.
	     */		
		public var sc:SoundChannel;
		
		/**
		 * The URL of the sound file to load.
		 */
		public var url:String;
		
		/**
		 * The buffer time to use when loading this object's sound file.
		 */
		public var bufferTime:int = 1000;
		
		/**
		 * Identifies when the sound file has been fully loaded.
		 */
		public var isLoaded:Boolean = false;
		
		/**
		 * Identifies when the sound file has been fully loaded.
		 */
		public var isReadyToPlay:Boolean = false;
		
		/**
		 * Identifies when the sound file is being played.
		 */
		public var isPlaying:Boolean = false;
		
		/**
		 * Specifies that the sound file can be played while it is being loaded.
		 */
		public var isStreaming:Boolean = true;
		
		/**
		 * Indicates that sound loading should start as soon as this object is created.
		 */
		public var autoLoad:Boolean = true;
		
		/**
		 * Indicates that sound playing should start as soon as enough sound data has been loaded.
		 * If this is a streaming sound, playback will begin as soon as enough data, as specified
		 * by the bufferTime property, has been loaded.
		 */
		public var autoPlay:Boolean = true;
		
		/**
		 * The position of the playhead in the sound data when the playback was last paused.
		 */
		public var pausePosition:int = 0;
		
		/**
		 * Defines how often to dispatch the playback progress event.
		 */
		public var progressInterval:int = 1000;
		
		/**
		 * Defines the "playProgress" event type.
		 */
		public static const PLAY_PROGRESS:String = "playProgress";
			
		/**
		 * The Timer that's used to update the progress display.
		 */
		public var playTimer:Timer;
		
		/**
		 * Constructor.
		 */
		public function SoundFacade(soundUrl:String, autoLoad:Boolean = true, autoPlay:Boolean = true, streaming:Boolean = true, bufferTime:int = -1):void
		{
		    this.url = soundUrl;

            // sets boolean values that determine the behavior of this object
		    this.autoLoad = autoLoad;
		    this.autoPlay = autoPlay;
		    this.isStreaming = streaming;
		    
		    // defaults to the global bufferTime value
		    if (bufferTime < 0)
		    {
		        bufferTime = SoundMixer.bufferTime;
		    }
            // keeps buffer time reasonable, between 0 and 30 seconds
		    this.bufferTime = Math.min(Math.max(0, bufferTime), 30);
		    
		    if (autoLoad)
		    {
		        load();
		    }
		}
				
		public function load():void
		{
			if (this.isPlaying)
			{
				this.stop();
				this.s.close();
				this.pausePosition = 0;
			}
			this.isLoaded = false;
			
			this.s = new Sound();
			
			this.s.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			this.s.addEventListener(Event.OPEN, onLoadOpen);
			this.s.addEventListener(Event.COMPLETE, onLoadComplete);
			this.s.addEventListener(Event.ID3, onID3);
			this.s.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIOError);
			
			var req:URLRequest = new URLRequest(this.url);
			
			var context:SoundLoaderContext = new SoundLoaderContext(this.bufferTime, true);
			this.s.load(req, context);
		}


		public function onLoadOpen(event:Event):void
		{
			if (this.isStreaming)
			{
				this.isReadyToPlay = true;
				if (autoPlay)
				{
					this.play();
				}
			}
			this.dispatchEvent(event.clone());
		}
		
		public function onLoadProgress(event:ProgressEvent):void
		{   
			this.dispatchEvent(event.clone());
		}
		
		
		public function onLoadComplete(event:Event):void
		{
			this.isReadyToPlay = true;
			this.isLoaded = true;
			this.dispatchEvent(event.clone());
			
			// if the sound hasn't started playing yet, start it now
			if (autoPlay && !isPlaying)
			{
				play();
			}
		}
				
		public function play(pos:int = 0):void
		{
			if (!this.isPlaying)
			{
				if (this.isReadyToPlay)
				{
					this.sc = this.s.play(pos);
					this.sc.addEventListener(Event.SOUND_COMPLETE, onPlayComplete);
					this.isPlaying = true;
					
					this.playTimer = new Timer(this.progressInterval);
					this.playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer);
					this.playTimer.start();
				}
				else if (this.isStreaming && !this.isLoaded)
				{
					// start loading again and play when ready
					// it appears to resume loading from the spot where it left off...cool
					this.load();
					return;
				}
			} 
		}
		
		public function stop(pos:int = 0):void
		{
			if (this.isPlaying)
			{
				this.pausePosition = pos;
				this.sc.stop();
				this.playTimer.stop();
				this.isPlaying = false;
			}
			if (this.isStreaming && !this.isLoaded)
			{
			    // stop streaming
			    this.s.close();
			    this.isReadyToPlay = false;
			}
		}
		
		public function pause():void
		{
			stop(this.sc.position);
		}
		
		public function resume():void
		{
			play(this.pausePosition);
		}

        public function get isPaused():Boolean
        {
            return (this.pausePosition > 0)
        }

        public function onPlayComplete(event:Event):void
        {
            this.pausePosition = 0;
            this.playTimer.stop();
            this.isPlaying = false;
            
            this.dispatchEvent(event.clone());
        }
		
		public function onID3(event:Event):void
		{
		    try
		    {
    		    var id3:ID3Info = event.target.id3;
    		    
    		    for (var propName:String in id3)
    		    {
    		        trace(propName + " = " + id3[propName]);
    		    }
    		}
    		catch (err:SecurityError)
    		{
    		    trace("Could not retrieve ID3 data.");
    		}
		}
		
		public function get id3():ID3Info
		{
			return this.s.id3;
		}
	
		public function onIOError(event:IOErrorEvent):void
		{
		    trace("SoundFacade.onIOError: " + event.text);
		    this.dispatchEvent(event.clone());
		}
		

		public function onPlayTimer(event:TimerEvent):void 
		{
			var estimatedLength:int = 
				Math.ceil(this.s.length / (this.s.bytesLoaded / this.s.bytesTotal));
			var progEvent:ProgressEvent = 
				new ProgressEvent(PLAY_PROGRESS, false, false, this.sc.position, estimatedLength);
			this.dispatchEvent(progEvent);
		}
        


	}
}