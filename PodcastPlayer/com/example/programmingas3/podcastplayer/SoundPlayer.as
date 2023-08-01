package com.example.programmingas3.podcastplayer
{
	import fl.controls.LabelButton;
	import fl.controls.CheckBox;
	import fl.controls.ProgressBar;
	import fl.controls.TextInput;
	import fl.controls.Label;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import flash.media.Sound;
	import flash.media.SoundMixer;
	
	import flash.utils.Timer;
	import com.example.programmingas3.podcastplayer.SoundFacade;
	
	public class SoundPlayer extends MovieClip
	{
		public var s:SoundFacade;
		
		public var positionTimer:Timer;
		
		/*public var playBtn:LabelButton;
		public var pauseBtn:LabelButton;
		public var resumeBtn:LabelButton;
		public var stopBtn:LabelButton;
		
		public var autoplayCb:CheckBox;
		
		public var loadingPb:ProgressBar;
		public var playingPb:ProgressBar;
		
		public var titleTxt:Label;
		public var urlTxt:TextInput;*/
					
		public function SoundPlayer():void
		{
			// default to 5 seconds of buffer time instead of 1 second
			SoundMixer.bufferTime = 5000;
			
			playBtn.addEventListener(MouseEvent.CLICK, onPlayBtn);
			pauseBtn.addEventListener(MouseEvent.CLICK, onPauseBtn);
			resumeBtn.addEventListener(MouseEvent.CLICK, onResumeBtn);
			stopBtn.addEventListener(MouseEvent.CLICK, onStopBtn);
			
			//playBtn.enabled = false;
			resumeBtn.enabled = false;
			pauseBtn.enabled = false;
			stopBtn.enabled = false;
			
			urlTxt.addEventListener("enter", onUrlChange);
		}
		
		public function load(url:String, title:String = ""):void
		{
			if (url != null)
			{
				this.loadingPb.setProgress(0, 1);
				this.playingPb.setProgress(0, 1);
				
				if (this.s != null && this.s.isPlaying)
				{
					this.s.stop();
				}
				
				this.s = new SoundFacade(url, true, this.autoPlayCb.selected, true, 100000);
				
				this.s.addEventListener(flash.events.ProgressEvent.PROGRESS, onLoadProgress);
				this.s.addEventListener(flash.events.Event.OPEN, onLoadOpen);
				this.s.addEventListener(flash.events.Event.COMPLETE, onLoadComplete);
				this.s.addEventListener("playProgress", onPlayProgress);
				this.s.addEventListener(flash.events.Event.SOUND_COMPLETE, onPlayComplete);

				this.urlTxt.text = url;
				this.titleTxt.text = title;
				
				if (this.autoPlayCb.selected)
				{
					playBtn.enabled = false;
				}
				else
				{
					playBtn.enabled = true;
				}

				this.pauseBtn.enabled = false;
				this.resumeBtn.enabled = false;
				this.stopBtn.enabled = true;
			}
		}
		
		public function onLoadOpen(evt:Event):void
		{
			// none of the properties are available when the open event arrives
			trace("onLoadOpen");
			
			if (!this.autoPlayCb.selected)
			{
				playBtn.enabled = true;
			}
		}
					
		public function onLoadProgress(evt:ProgressEvent):void
		{
			this.loadingPb.setProgress(evt.bytesLoaded, evt.bytesTotal);
		}
		
		public function onLoadComplete(evt:Event):void
		{
			// all of the properties are available when the complete event arrives
			trace("onLoadComplete");
			if (this.s.isPlaying)
			{
				// can't pause until the file is fully loaded
				pauseBtn.enabled = true;
			}
		}
		
		public function onPlayProgress(evt:ProgressEvent):void
		{
			this.playingPb.setProgress(evt.bytesLoaded, evt.bytesTotal);
		}
		
		public function onPlayComplete(evt:Event):void
		{
			trace("onPlayComplete");
			
			this.playBtn.enabled = true;
			this.stopBtn.enabled = false;
		}
			
		public function onPlayBtn(evt:Event):void
		{
			if (this.s != null)
			{
				this.s.play(); 
				this.stopBtn.enabled = true;
				if (this.s.isLoaded)
				{
					this.pauseBtn.enabled = true;
					this.resumeBtn.enabled = false;
				}
			}
		}

		public function onPauseBtn(evt:Event):void
		{
			this.s.pause();
			
			this.playBtn.enabled = true;
			this.pauseBtn.enabled = false;
			this.resumeBtn.enabled = true;
		}
		
		public function onResumeBtn(evt:Event):void
		{
			this.s.resume();
			
			this.pauseBtn.enabled = true;
			this.resumeBtn.enabled = false;
		}
		
		public function onStopBtn(evt:Event):void
		{
			this.s.stop();
			this.playingPb.setProgress(0, 1);
			
			this.playBtn.enabled = true;
			this.pauseBtn.enabled = false;
			this.resumeBtn.enabled = false;
			this.stopBtn.enabled = false;
		}
		
		public function onUrlChange(evt:Event):void
		{
			if (urlTxt.text != "")
			{
				if (this.s != null)
				{
					this.s.stop();
					this.playingPb.setProgress(0, 1);
				}
				load(urlTxt.text);
			}
		}
	}
}