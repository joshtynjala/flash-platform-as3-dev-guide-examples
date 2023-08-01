package com.example.programmingas3.socket {
    import flash.events.*;
    import flash.net.Socket;
    import flash.system.Security;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;
    
    import mx.controls.TextArea;
    import mx.core.UIComponent;

    public class Telnet extends UIComponent{
        private const CR:int = 13; // Carriage Return (CR)
        private const WILL:int = 0xFB; // 251 - WILL (option code)
        private const WONT:int = 0xFC; // 252 - WON'T (option code)
        private const DO:int   = 0xFD; // 253 - DO (option code)
        private const DONT:int = 0xFE; // 254 - DON'T (option code)
        private const IAC:int  = 0xFF; // 255 - Interpret as Command (IAC)

        private var serverURL:String;
        private var portNumber:int;
        private var socket:Socket;
        private var ta:TextArea;
        private var state:int = 0;
        
        public function Telnet(server:String, port:int, output:TextArea) {
            // set class variables to the values passed to the constructor.
            serverURL = server;
            portNumber = port;
            ta = output;
            
            // Create a new Socket object and assign event listeners.
            socket = new Socket();
            socket.addEventListener(Event.CONNECT, connectHandler);
            socket.addEventListener(Event.CLOSE, closeHandler);
            socket.addEventListener(ErrorEvent.ERROR, errorHandler);
            socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
            
            // Load policy file from remote server.
            Security.loadPolicyFile("http://" + serverURL + "/crossdomain.xml");
            // Attempt to connect to remote socket server.
            try {
                msg("Trying to connect to " + serverURL + ":" + portNumber + "\n");
                socket.connect(serverURL, portNumber);
            } catch (error:Error) {
                /*
                    Unable to connect to remote server, display error 
                    message and close connection.
                */
                msg(error.message + "\n");
                socket.close();
            }
        }
        
        /**
         * This method is called if the socket encounters an ioError event.
         */
        public function ioErrorHandler(event:IOErrorEvent):void {
            msg("Unable to connect: socket error.\n");
        }
        
        /**
         * This method is called by our application and is used to send data
         * to the server.
         */
        public function writeBytesToSocket(ba:ByteArray):void {
            socket.writeBytes(ba);
            socket.flush();
        }
        
        private function connectHandler(event:Event):void {
            if (socket.connected) {
                msg("connected...\n");
            } else {
                msg("unable to connect\n");
            }
        }
        
        /**
         * This method is called when the socket connection is closed by 
         * the server.
         */
        private function closeHandler(event:Event):void {
            msg("closed...\n");
        }
        
        /**
         * This method is called if the socket throws an error.
         */
        private function errorHandler(event:ErrorEvent):void {
            msg(event.text + "\n");
        }
        
        /**
         * This method is called when the socket receives data from the server.
         */
        private function dataHandler(event:ProgressEvent):void {
            var n:int = socket.bytesAvailable;
            // Loop through each available byte returned from the socket connection.
            while (--n >= 0) {
                // Read next available byte.
                var b:int = socket.readUnsignedByte();
                switch (state) {
                    case 0:
                        // If the current byte is the "Interpret as Command" code, set the state to 1.
                        if (b == IAC) {
                            state = 1;
                        // Else, if the byte is not a carriage return, display the character using the msg() method.
                        } else if (b != CR) {
                            msg(String.fromCharCode(b));
                        }
                        break;
                    case 1:
                        // If the current byte is the "DO" code, set the state to 2.
                        if (b == DO) {
                            state = 2;
                        } else {
                            state = 0;
                        }
                        break;
                    // Blindly reject the option.
                    case 2:
                        /*
                            Write the "Interpret as Command" code, "WONT" code, 
                            and current byte to the socket and send the contents 
                            to the server by calling the flush() method.
                        */
                        socket.writeByte(IAC);
                        socket.writeByte(WONT);
                        socket.writeByte(b);
                        socket.flush();
                        state = 0;
                        break;
                }
            }
        }
        
        /**
         * Append message to the TextArea component on the display list.
         * After appending text, call the setScroll() method which controls
         * the scrolling of the TextArea.
         */
        private function msg(value:String):void {
            ta.text += value;
            ta.dispatchEvent(new Event(Event.CHANGE));
            setTimeout(setScroll, 100);
        }

        /**
         * Scroll the TextArea component to its maximum vertical scroll 
         * position so that the TextArea always shows the last line returned
         * from the server.
         */
        public function setScroll():void {
            ta.verticalScrollPosition = ta.maxVerticalScrollPosition;
        }
    }
}
