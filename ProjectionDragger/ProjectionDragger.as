package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.events.*;
	
	public class ProjectionDragger extends Sprite
	{
		private var center:Sprite;
		private var boxPanel:Shape;
		private var inDrag:Boolean = false;
		
		public function ProjectionDragger():void
		{
			createBoxes();
			createCenter();
		}
		
		public function createCenter():void
		{
			var centerRadius:int = 20;
			
			center = new Sprite();
			
			// circle
			center.graphics.lineStyle(1,0x000099);
			center.graphics.beginFill(0xCCCCCC, 0.5);
			center.graphics.drawCircle(0,0,centerRadius);
			center.graphics.endFill();
			
			// cross hairs
			center.graphics.moveTo(0,centerRadius);
			center.graphics.lineTo(0,-centerRadius);
			center.graphics.moveTo(centerRadius,0);
			center.graphics.lineTo(-centerRadius,0);
			center.x = 175;
			center.y = 175;
			center.z = 0;
			
			this.addChild(center);
			
			center.addEventListener(MouseEvent.MOUSE_DOWN, startDragProjectionCenter);
			center.addEventListener(MouseEvent.MOUSE_UP, stopDragProjectionCenter);
			center.addEventListener(MouseEvent.MOUSE_MOVE, doDragProjectionCenter);
			
			root.transform.perspectiveProjection.projectionCenter = new Point(center.x, center.y);
		}

		public function createBoxes():void
		{
			//createBoxPanel();
			var boxWidth:int = 50;
			var boxHeight:int = 50;
			var numLayers:int = 12;
			var depthPerLayer:int = 50;
			
			//var boxVec:Vector.<Shape> = new Vector.<Shape>(numLayers);
			for (var i:int = 0; i < numLayers; i++)
			{
				this.addChild(createBox(150, 50, (numLayers - i) * depthPerLayer, boxWidth, boxHeight, 0xCCCCFF));
				this.addChild(createBox(50, 150, (numLayers - i) * depthPerLayer, boxWidth, boxHeight, 0xFFCCCC));
				this.addChild(createBox(250, 150, (numLayers - i) * depthPerLayer, boxWidth, boxHeight, 0xCCFFCC));
				this.addChild(createBox(150, 250, (numLayers - i) * depthPerLayer, boxWidth, boxHeight, 0xDDDDDD));
			}
		}
		
		public function createBox(xPos:int = 0, yPos:int = 0, zPos:int = 100, w:int = 50, h:int = 50, color:int = 0xDDDDDD):Shape
		{
			var box:Shape = new Shape();
			box.graphics.lineStyle(2, 0x666666);
			box.graphics.beginFill(color, 1.0);
			box.graphics.drawRect(0, 0, w, h);
			box.graphics.endFill();
			box.x = xPos;
			box.y = yPos;
			box.z = zPos;
			return box;
		}

		public function startDragProjectionCenter(e:Event)  
		{  
			center.startDrag(); 
			inDrag = true;
		}
		
		public function doDragProjectionCenter(e:Event)  
		{  
			if (inDrag)
			{
				root.transform.perspectiveProjection.projectionCenter = new Point(center.x, center.y);
			}
		}
		
		public function stopDragProjectionCenter(e:Event) 
		{ 
			center.stopDrag();  
			root.transform.perspectiveProjection.projectionCenter = new Point(center.x, center.y);
			inDrag = false;
		}
	}
}







