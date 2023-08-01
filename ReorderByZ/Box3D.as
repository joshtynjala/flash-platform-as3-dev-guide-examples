
package {
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import ThreeDSortElement;
   
   public class Box3D extends Sprite {
		public var faces:Array = new Array(6);

		public function Box3D(backSrc:DisplayObject, bottomSrc:DisplayObject, frontSrc:DisplayObject, leftSrc:DisplayObject, rightSrc:DisplayObject, topSrc:DisplayObject)
		{
			// initialize faces vector
			for (var ind:uint = 0; ind < 6; ind++)
				faces[ind] = new ThreeDSortElement(0,new Sprite());
				
			faces[0].child.addChild(backSrc);
			faces[1].child.addChild(bottomSrc);
			faces[2].child.addChild(frontSrc);
			faces[3].child.addChild(leftSrc);
			faces[4].child.addChild(rightSrc);
			faces[5].child.addChild(topSrc);
	
			// sorting usually works best when the position (or regPoint) is a point in the center of the face.  
			//  Offset child x/y to make that so.
			var localRect:Rectangle  = backSrc.getBounds(backSrc); // assumes all faces are the same size
			var centerOffsetX:Number = localRect.x + localRect.width/2;
			var centerOffsetY:Number = localRect.y + localRect.height/2;
			for (ind = 0; ind < 6; ind++) {
				var offsetChild:DisplayObject = faces[ind].child.getChildAt(0);
				offsetChild.x = -centerOffsetX;
				offsetChild.y = -centerOffsetY;
				
				// while we're here, add each face as a child.
				this.addChild(faces[ind].child);
			}
            // left face
			faces[3].child.rotationY = 90;
			faces[3].child.x = -centerOffsetX;
            // right face
			faces[4].child.rotationY = -90;
			faces[4].child.x = centerOffsetX;
            // back face
			faces[0].child.z = centerOffsetX;
			faces[0].child.rotationY = 180;
            // front face
			faces[2].child.z = -centerOffsetX;
	        // bottom face
			faces[1].child.rotationX = 90;
			faces[1].child.y = centerOffsetY;
            // top face
			faces[5].child.rotationX = -90;
			faces[5].child.y = -centerOffsetY;
			
			this.z = 0; // make "this" 3d as well
		}
		
		//  Remove all children, sort them by global z distance, then add them back in sorted order.
		public function ReorderChildren()
		{
			// Reorder all the children based on Z.
			for(var ind:uint = 0; ind < 6; ind++) {
				// getRelativeMatrix3D gets a Matrix3D reprsenting the pos/rot/scale of one DisplayObject
				//   relative to another.  Get the Matrix3D relative to the root to get the global position.
				faces[ind].z = faces[ind].child.transform.getRelativeMatrix3D(root).position.z;
				
				this.removeChild(faces[ind].child);
			}
            // sort them on z and add them back (in reverse order).
            faces.sortOn("z", Array.NUMERIC | Array.DESCENDING);
            for (ind = 0; ind < 6; ind++) {
           	   this.addChild(faces[ind].child);
            }
		}		
	}
}