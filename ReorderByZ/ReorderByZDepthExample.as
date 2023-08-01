package {
	import flash.display.MovieClip;
	import flash.display.Graphics;
    import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.display.GradientType;
	
	public class ReorderByZDepthExample extends MovieClip {
			
		public var box:Box3D;  			 // the 3d box
		private var boxSides:Array = new Array(6); // the 6 faces of the box
		private var boxMat3D:Matrix3D;   // cached referece to box's .transform.matrix3D 
		
		private var savedStageX:Number;  // last position of the mouse in stage coordiantes.
		private var savedStageY:Number;

		public function ReorderByZDepthExample()
		{
			for (var side:uint = 0; side < 6; side++) { // create 6 circles to use as sides.
				var s:MovieClip  = new MovieClip();
				s.graphics.beginFill(0x9ff << (side*4), 1); // vary the color
				s.graphics.drawCircle(256,256,256);
				boxSides[side] = s;
			}
			// note: we could use any DisplayObject for the sides.  Video, Vector graphics, arbitrary MovieClips, etc.
			//  Box3D assumes they all have the same dimensions and regpoint, however.
			box = new Box3D( boxSides[0], boxSides[1], boxSides[2], 
							 boxSides[3], boxSides[4], boxSides[5] );
			
			// place ourselves in the middle of the stage, back 500 in z.
			this.addChild(box);
			this.x = 300;
			this.y = 300;
			this.z = 500;
			
			// save reference to box's matrix3D for use later.
			boxMat3D = box.transform.matrix3D; // its a real reference, unlike ".transform.matrix", which is a value copy
			
			savedStageX = stage.mouseX;
			savedStageY = stage.mouseY;
			stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMoveH);
		}
		
		private function mouseMoveH(e:MouseEvent)
		{								    
			var diffY:Number = savedStageY - e.stageY;  // store stageX/stageY before modifying box
			var diffX:Number = savedStageX - e.stageX;  //  Its computed dynamically can can change (!)
			savedStageX = e.stageX;						//  after we rotate boxMat3D.
			savedStageY = e.stageY;

			// move in stage Y, then rotate about our parent's Xaxis so that movement matches mouse
			boxMat3D.appendRotation(-diffY, Vector3D.X_AXIS);
			// move in stage X, then rotate about parent's Yaxis.
			boxMat3D.appendRotation(diffX, Vector3D.Y_AXIS);
			// z ordering of faces may have changed.  Re-layer children to match z order.
			box.ReorderChildren();
		}
	}
}

