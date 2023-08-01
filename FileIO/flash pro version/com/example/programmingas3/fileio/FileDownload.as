package com.example.programmingas3.fileio {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    
    import fl.controls.Button;
    import fl.controls.ProgressBar;

    public class FileDownload {
        // Hard-code the URL of file to download to user's computer.
        private const DOWNLOAD_URL:String = "http://www.yourdomain.com/file_to_download.zip";
        private var fr:FileReference;
        // Define reference to the download ProgressBar component.
        private var pb:ProgressBar;
        // Define reference to the "Cancel" button which will immediately stop the download in progress.
        private var btn:Button;

        public function FileDownload() {
        }

        /**
         * Set references to the components, and add listeners for the OPEN, 
         * PROGRESS, and COMPLETE events.
         */
        public function init(pb:ProgressBar, btn:Button):void {
            // Set up the references to the progress bar and cancel button, which are passed from the calling script.
            this.pb = pb;
            this.btn = btn;

            fr = new FileReference();
            fr.addEventListener(Event.OPEN, openHandler);
            fr.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            fr.addEventListener(Event.COMPLETE, completeHandler);
        }

        /**
         * Immediately cancel the download in progress and disable the cancel button.
         */
        public function cancelDownload(e:MouseEvent):void {
            fr.cancel();
//            pb.label = "DOWNLOAD CANCELLED";
            btn.enabled = false;
        }

        /**
         * Begin downloading the file specified in the DOWNLOAD_URL constant.
         */
        public function startDownload(e:MouseEvent):void {
            var request:URLRequest = new URLRequest();
            request.url = DOWNLOAD_URL;
            fr.download(request);
        }

        /**
         * When the OPEN event has dispatched, change the progress bar's label 
         * and enable the "Cancel" button, which allows the user to abort the 
         * download operation.
         */
        private function openHandler(event:Event):void {
//            pb.label = "DOWNLOADING %3%%";
            btn.enabled = true;
        }
        
        /**
         * While the file is downloading, update the progress bar's status and label.
         */
        private function progressHandler(event:ProgressEvent):void {
            pb.setProgress(event.bytesLoaded, event.bytesTotal);
        }

        /**
         * Once the download has completed, change the progress bar's label and 
         * disable the "Cancel" button since the download is already completed.
         */
        private function completeHandler(event:Event):void {
//            pb.label = "DOWNLOAD COMPLETE";
            pb.setProgress(0, 100);
            btn.enabled = false;
        }
    }
}