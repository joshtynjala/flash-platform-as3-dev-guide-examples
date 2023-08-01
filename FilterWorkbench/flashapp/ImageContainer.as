package flashapp
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ImageContainer extends Sprite
	{
		private var _image:DisplayObject;
		private var _container:Sprite;
		
		
		// ------- Constructor -------
		public function ImageContainer()
		{
			_container = new Sprite();
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