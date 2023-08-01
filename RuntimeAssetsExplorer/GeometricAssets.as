package
{
	import flash.display.Sprite;
	import com.example.programmingas3.runtimeassetexplorer.RuntimeLibrary;
	
	public class GeometricAssets extends Sprite implements RuntimeLibrary 
	{
		public function GeometricAssets() {
			
		}
		public function getAssets():Array {
			return [ "com.example.programmingas3.runtimeassetexplorer.AnimatingBox",
					 "com.example.programmingas3.runtimeassetexplorer.AnimatingStar" ];	
		}
	}
}