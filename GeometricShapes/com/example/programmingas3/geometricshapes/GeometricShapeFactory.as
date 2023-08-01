package com.example.programmingas3.geometricshapes 
{
	public class GeometricShapeFactory 
	{
	    public static function createShape(shapeName:String, len:Number):IGeometricShape
	    {
	        switch (shapeName)
	        {       
                case "Triangle":
                    return new EquilateralTriangle(len);
                    
                case "Square":
                    return new Square(len);
                    
	            case "Circle":
	                return new Circle(len);
            }
            return null;
	    }
	}
}