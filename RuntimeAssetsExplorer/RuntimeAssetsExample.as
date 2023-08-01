package {
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.ColorTransform;

	import com.example.programmingas3.runtimeassetexplorer.RuntimeLibrary;
	
	public class RuntimeAssetExplorer extends Sprite {
		
		public function RuntimeAssetExplorer() {
			var path:URLRequest = new URLRequest("GeometricAssets.swf");
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,runtimeAssetsLoadComplete);
			loader.load(path,context);
		}
		private function runtimeAssetsLoadComplete(event:Event):void {			
			var ra:* = event.target.content;
			populateDropdown(ra.getAssets());

			btn1.label = "Add";
			btn1.addEventListener(MouseEvent.CLICK, addAssetToStage);
		}
		private function populateDropdown(assetList:Array):void {
			var shortNameList:Array = new Array();
			for(var i:uint = 0; i < assetList.length; i++) {
				var className:String = assetList[i];
				var splicePoint:Number = className.lastIndexOf(".")+1;
				var shortName:String = splicePoint ? className.substr(splicePoint) : className;
				shortNameList.push( { label:shortName, data:className } );
			}
			cb.dataProvider = new DataProvider(shortNameList);	
			cb.setSize(150,20);
		}		
		private function drawAsset(AssetClass:Class, posX:uint, posY:uint):MovieClip {
			var mc:MovieClip = new AssetClass();
			mc.transform.colorTransform = getRandomColor();
			mc.rotation = Math.random() * 360;
			mc.addEventListener(MouseEvent.CLICK,rotate);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,startDragAsset);
			mc.addEventListener(MouseEvent.MOUSE_UP,stopDragAsset);			
			mc.stop();
			mc.x = posX;
			mc.y = posY;
			addChild(mc);
			return mc;
		}
		private function rotate(event:MouseEvent):void {
			var target:MovieClip = MovieClip(event.currentTarget);
			target.play();
		}
		private function getRandomColor():ColorTransform {
			return new ColorTransform(Math.random(),Math.random(),Math.random(),1,(Math.random() * 512)-255,(Math.random() * 512)-255,(Math.random() * 512)-255,0);
		}
		private function startDragAsset(event:MouseEvent):void {
			var target:MovieClip = MovieClip(event.currentTarget);
			target.startDrag();
		}
		private function stopDragAsset(event:MouseEvent):void {
			var target:MovieClip = MovieClip(event.currentTarget);
			target.stopDrag();
		}		
		
		private function addAssetToStage(me:MouseEvent):void {
			var AssetClass:Class = getDefinitionByName(cb.selectedItem.data) as Class;
			if(AssetClass) {
				drawAsset(AssetClass, 200, 75);		
			}
		}
	}
}