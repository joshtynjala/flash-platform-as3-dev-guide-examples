package com.example.data {
	import com.example.display.SampleComponent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.util.trace;
	import flash.errors.IllegalOperationError;

	public class StringData extends URLLoader {

		public function StringData(request:URLRequest = null) {
			super(request);
			configureListeners();
		}

		protected function configureListeners():void {
			addEventListener(Event.COMPLETE, completeHandler);
			addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		protected function completeHandler(event:Event):void {
		}

		protected function httpStatusHandler(event:HTTPStatusEvent):void {
		}

		protected function ioErrorHandler(event:IOErrorEvent):void {
			throw new IllegalOperationError(event.toString());
		}

		protected function securityErrorHandler(event:SecurityErrorEvent):void {
			throw new IllegalOperationError(event.toString());
		}
	}
}
