package com.example.programmingas3.introvertIM
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	import com.example.programmingas3.introvertIM.IMMessageEvent;
	import com.example.programmingas3.introvertIM.IMStatus;
	
	public class IMManager extends EventDispatcher
	{
		// ------- Private vars -------
		/**
		* Keeps track of the current "availability" status of the user.
		*/
		private var _status:IMStatus;
		
		
		// ------- Constructor -------
		public function IMManager(initialStatus:IMStatus)
		{
			_status = initialStatus;
			
			// check if the container is able to use the External API
			if (ExternalInterface.available)
			{
				try
				{
					// This calls the isContainerReady() method, which in turn calls
					// the container to see if Flash Player has loaded and the container
					// is ready to receive calls from the SWF.
					var containerReady:Boolean = isContainerReady();
					if (containerReady)
					{
						// if the container is ready, register the SWF's functions
						setupCallbacks();
					}
					else
					{
						// If the container is not ready, set up a Timer to call the
						// container at 100ms intervals. Once the container responds that
						// it's ready, the timer will be stopped.
						var readyTimer:Timer = new Timer(100);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				}
				catch (error:SecurityError)
				{
				    trace("A SecurityError occurred: " + error.message + "\n");
				    throw error;
				}
				catch (error:Error)
				{
				    trace("An Error occurred: " + error.message + "\n");
				    throw error;
				}
			}
			else
			{
				trace("External interface is not available for this container.");
			}
		}
		
		
		// ------- Public Properties -------
		/**
		 * Gets or sets the user's current availability.
		 */
		public function get status():IMStatus
		{
			return _status;
		}
		public function set status(newStatus:IMStatus):void
		{
			_status = newStatus;
			// notify the container that the SWF user's status has changed
			ExternalInterface.call("statusChange");
		}
		
		
		// -------- Public Methods -------
		/**
		 * Sends a new message to the container IM client
		 * @param message	The message to send
		 */
		public function sendMessage(message:String):void
		{
			ExternalInterface.call("newMessage", message);
		}
		
		
		// ------- Externally-callable Methods -------
		/**
		 * Called by the container to send a new message to the SWF client.
		 * @param message	The message that was sent
		 */
		private function newMessage(message:String):void
		{
			// notify listeners (i.e. the UI) that there's a new message;
			// the UI will then update itself accordingly
			var ev:IMMessageEvent = new IMMessageEvent(message);
			dispatchEvent(ev);
		}
		
		
		/**
		 * Called by the container to retrieve the current status
		 * @return 	The current status of the SWF IM client
		 */
		private function getStatus():String
		{
			return status.toString();
		}
		
		
		// ------- Private Methods -------
		/**
		 * Calls the container's isReady() function, to check if the container is loaded
		 * and ready to communicate with the SWF file.
		 * @return 	Whether the container is ready to communicate with ActionScript.
		 */
		private function isContainerReady():Boolean
		{
			var result:Boolean = ExternalInterface.call("isReady");
			return result;
		}
		
		
		/**
		 * Registers the appropriate ActionScript functions with the container, so that
		 * they can be called, and calls the "setSWFIsReady()" function in the container
		 * which tells the container that the SWF file is ready to receive function calls.
		 */
		private function setupCallbacks():void
		{
			// register the SWF client functions with the container
			ExternalInterface.addCallback("newMessage", newMessage);
			ExternalInterface.addCallback("getStatus", getStatus);
			// notify the container that the SWF is ready to be called.
			ExternalInterface.call("setSWFIsReady");
		}
		

		/**
		 * Handles the timer event; this function is called by the timer each
		 * time the elapsed time has been reached.
		 * The net effect is that on regular intervals this function checks
		 * to see if the container is ready to receive communication.
		 * @param event		The event object for the Timer event.
		 */
		private function timerHandler(event:TimerEvent):void
		{
			// check if the container is now ready
			var isReady:Boolean = isContainerReady();
			if (isReady)
			{
				// If the container has become ready, we don't need to check anymore,
				// so stop the timer.
				Timer(event.target).stop();
				// Set up the ActionScript methods that will be available to be
				// called by the container.
				setupCallbacks();
			}
		}
	}
}