package flexapp
{
	import mx.containers.Canvas;
	import flash.display.DisplayObject;
	import mx.core.UIComponent;

	public class ImageContainer extends Canvas
	{
		// ------- Private vars -------
		private var _image:DisplayObject;
		private var _container:UIComponent;
		
		
		// ------- Constructor --------
		public function ImageContainer()
		{
			super();
			_container = new UIComponent();
			addChild(_container);
		}
		
		
		// ------- Public properties -------
		public function get hasImage():Boolean
		{
			return (_image != null);
		}
		
		
		// ------- Public methods -------
		public function addImage(image:DisplayObject):void
		{
			if (_image == image) { return; }
			
			if (_image != null)
			{
				_container.removeChild(_image);
			}
			
			_container.addChild(image);
			image.x = (width / 2) - (image.width / 2);
			image.y = (height / 2) - (image.height / 2);
			
			_image = image;
		}
		
		
		public function removeImage():void
		{
			if (_image == null) { return; }
			
			_container.removeChild(_image);
			_image = null;
		}
	}
}