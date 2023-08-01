package com.example.programmingas3.errors 
{
    public class ApplicationError extends Error 
    {
        internal static const WARNING:int = 0;
        internal static const FATAL:int = 1;
        public var id:int;
        public var severity:int;
        private static var messages:XML;
        
        public function ApplicationError() {
            messages = <errors>
                    <error code="9000"><![CDATA[Employee must be assigned to a cost center.]]></error>
                    <error code="9001"><![CDATA[Employee must be assigned to only one cost center.]]></error>
                    <error code="9002"><![CDATA[Employee must have one and only one SSN.]]></error>
                    <error code="9999"><![CDATA[The application has been stopped.]]></error>
                </errors>;
        }
        
        public function getMessageText(id:int):String {
            var message:XMLList = messages.error.(@code == id);
            return message[0].text();
        }
        
        public function getTitle():String {
            return "Error #" + id;
        }
        
        public function toString():String {
            return "[APPLICATION ERROR #" + id + "] " + message;
        }
    }
}
