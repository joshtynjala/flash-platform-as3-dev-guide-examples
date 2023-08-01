package com.example.programmingas3.errors
{
	public class Validator
	{

		public static function validateEmployeeXML(employee:XML):void 
		{
			// checks for the integrity of items in the XML
			if (employee.costCenter.length() < 1) {
				throw new FatalError(9000);
			}
			
			if (employee.costCenter.length() > 1) {
				throw new WarningError(9001);
			}
			
			if (employee.ssn.length() != 1) {
				throw new FatalError(9002);
			}
		}
	}
}