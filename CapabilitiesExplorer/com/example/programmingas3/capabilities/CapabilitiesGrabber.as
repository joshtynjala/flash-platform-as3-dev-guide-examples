package com.example.programmingas3.capabilities {
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.display.Sprite;

	public class CapabilitiesGrabber extends Sprite {
		public static function getCapabilities():Array {
			var capDP:Array = new Array();
			capDP.push({name:"Capabilities.avHardwareDisable", value:Capabilities.avHardwareDisable}); 
			capDP.push({name:"Capabilities.hasAccessibility", value:Capabilities.hasAccessibility}); 
			capDP.push({name:"Capabilities.hasAudio", value:Capabilities.hasAudio}); 
			capDP.push({name:"Capabilities.hasAudioEncoder", value:Capabilities.hasAudioEncoder}); 
			capDP.push({name:"Capabilities.hasEmbeddedVideo", value:Capabilities.hasEmbeddedVideo}); 
			capDP.push({name:"Capabilities.hasIME", value:Capabilities.hasIME}); 
			capDP.push({name:"Capabilities.hasMP3", value:Capabilities.hasMP3}); 
			capDP.push({name:"Capabilities.hasPrinting", value:Capabilities.hasPrinting}); 
			capDP.push({name:"Capabilities.hasScreenBroadcast", value:Capabilities.hasScreenBroadcast}); 
			capDP.push({name:"Capabilities.hasScreenPlayback", value:Capabilities.hasScreenPlayback}); 
			capDP.push({name:"Capabilities.hasStreamingAudio", value:Capabilities.hasStreamingAudio}); 
			capDP.push({name:"Capabilities.hasStreamingVideo", value:Capabilities.hasStreamingVideo}); 
			capDP.push({name:"Capabilities.hasTLS", value:Capabilities.hasTLS});
			capDP.push({name:"Capabilities.hasVideoEncoder", value:Capabilities.hasVideoEncoder});
			capDP.push({name:"Capabilities.isDebugger", value:Capabilities.isDebugger});
			capDP.push({name:"Capabilities.language", value:Capabilities.language});
			capDP.push({name:"Capabilities.localFileReadDisable", value:Capabilities.localFileReadDisable});
			capDP.push({name:"Capabilities.manufacturer", value:Capabilities.manufacturer});
			capDP.push({name:"Capabilities.os", value:Capabilities.os});
			capDP.push({name:"Capabilities.pixelAspectRatio", value:Capabilities.pixelAspectRatio});
			capDP.push({name:"Capabilities.playerType", value:Capabilities.playerType});
			capDP.push({name:"Capabilities.screenColor", value:Capabilities.screenColor});
			capDP.push({name:"Capabilities.screenDPI", value:Capabilities.screenDPI});
			capDP.push({name:"Capabilities.screenResolutionX", value:Capabilities.screenResolutionX});
			capDP.push({name:"Capabilities.screenResolutionY", value:Capabilities.screenResolutionY});
			capDP.push({name:"Capabilities.version", value:Capabilities.version});
			var navArr:Array = CapabilitiesGrabber.getBrowserObjects();
			if (navArr.length > 0) {
				capDP = capDP.concat(navArr);
			}
			capDP.sortOn("name", Array.CASEINSENSITIVE);
			return capDP;
		}
		private static function getBrowserObjects():Array {
			var itemArr:Array = new Array();
			var itemVars:URLVariables;
			if (ExternalInterface.available) {
				try {
					var tempStr:String = ExternalInterface.call("JS_getBrowserObjects");
					itemVars = new URLVariables(tempStr);
					for (var i:String in itemVars) {
						itemArr.push({name:i, value:itemVars[i]});
					}
				} catch (error:SecurityError) {
					// ignore
				}
			}
			return itemArr;
		}
	}
}