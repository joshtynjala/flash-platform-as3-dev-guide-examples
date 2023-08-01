package com.example.programmingas3.filterWorkbench
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.ConvolutionFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class ConvolutionFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:ConvolutionFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function ConvolutionFactory(matrixX:Number = 3, 
											 matrixY:Number = 3, 
											 matrix:Array = null, 
											 divisor:Number = 1.0, 
											 bias:Number = 0.0, 
											 preserveAlpha:Boolean = true, 
											 clamp:Boolean = true, 
											 color:uint = 0, 
											 alpha:Number = 0.0)
		{
			if (matrix == null)
			{
				matrix = makeDefaultMatrix(matrixX, matrixY);
			}
			_filter = new ConvolutionFilter(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
			_paramString = buildParamString(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			var result:String = "";
			result += "import flash.filters.ConvolutionFilter;\n";
			result += "\n";
			result += "var convolution:ConvolutionFilter;\n";
			result += "convolution = new ConvolutionFilter(" + _paramString + ");\n";
			result += "\n";
			result += "myDisplayObject.filters = [convolution];";
			return result;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(matrixX:Number = 3, 
									   matrixY:Number = 3, 
									   matrix:Array = null, 
									   divisor:Number = 1.0, 
									   bias:Number = 0.0, 
									   preserveAlpha:Boolean = true, 
									   clamp:Boolean = true, 
									   color:uint = 0, 
									   alpha:Number = 0.0):void
		{
			if (matrix == null)
			{
				matrix = makeDefaultMatrix(matrixX, matrixY);
			}
			_filter = new ConvolutionFilter(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
			_paramString = buildParamString(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function makeDefaultMatrix(matrixX:Number, matrixY:Number):Array
		{
			var numFields:Number = matrixX * matrixY;
			var centerIndex:Number = Math.floor(numFields / 2);
			var result:Array = new Array(numFields);
			for (var i:int = 0; i < numFields; i++)
			{
				result[i] = (i == centerIndex) ? 1 : 0;
			}
			
			return result;
		}
		
		
		private function buildParamString(matrixX:Number, matrixY:Number, matrix:Array, divisor:Number, bias:Number, preserveAlpha:Boolean, clamp:Boolean, color:uint, alpha:Number):String
		{
			var result:String = "\n\t\t\t" + matrixX.toString() + ",\n\t\t\t" + matrixY.toString() + ",\n\t\t\t";
			
			result += "[";
			for (var i:Number = 0, numElements:Number = matrix.length; i < numElements; i++)
			{
				if (i > 0)
				{
					result += ", ";
				}
				if (i != 0 && i % matrixX == 0)
				{
					result += "\n\t\t\t ";
				}
				result += matrix[i].toString();
			}
			result += "],\n\t\t\t";
			
			result += divisor.toString() + ",\n\t\t\t" + bias.toString() + ",\n\t\t\t";
			result += preserveAlpha.toString() + ",\n\t\t\t" + clamp.toString() + ",\n\t\t\t";
			result += ColorStringFormatter.formatColorHex24(color) + ",\n\t\t\t" + alpha.toString();
			
			return result;
		}
	}
}