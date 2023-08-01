package com.example.data {
	
	public class ASCIIRecord {
		private var fileName:String;
		private var title:String;
		private var whiteThreshold:Number;
		private var blackThreshold:Number;
		private static var lowerCaseWords:Object;

		public function ASCIIRecord() {
		}
		
		public function setFileName(str:String):void {
			var fileHalves:Array = str.split(".");
			fileName = fileHalves[0] + "." + fileHalves[1].toLowerCase();
		}
		
		public function setTitle(str:String):void {
			title = normalizeTitle(str);
		}
		
		public function setWhiteThreshold(str:String):void {
			whiteThreshold = parseInt(str, 16);
		}
		
		public function setBlackThreshold(str:String):void {
			blackThreshold = parseInt(str, 16);
		}
		
		private function normalizeTitle(str:String):String {
			var words:Array = str.split(" ");
			var len:uint = words.length;

			for(var i:uint; i < len; i++) {
				words[i] = capitalizeFirstLetter(words[i]);
			}
			
			return words.join(" ");
		}
		
		private function capitalizeFirstLetter(word:String):String {
			if(!isLowerCase(word)) {
				word = word.charAt(0).toUpperCase() + word.substr(1);
			}
			return word;
		}
		
		private static function isLowerCase(word:String):Boolean {
			if(lowerCaseWords == null) {
				lowerCaseWords = new Object();
				lowerCaseWords["and"] = true;
				lowerCaseWords["the"] = true;
				lowerCaseWords["in"] = true;
				lowerCaseWords["an"] = true;
				lowerCaseWords["or"] = true;
				lowerCaseWords["at"] = true;
				lowerCaseWords["of"] = true;
				lowerCaseWords["a"] = true;
			}
			
			return (lowerCaseWords[word] == true);
		}
		
		public function getFileName():String {
			return fileName;
		}
		
		public function getTitle():String {
			return title;
		}
		
		public function getWhiteThreshold():Number {
			return whiteThreshold;
		}
		
		public function getBlackThreshold():Number {
			return blackThreshold;
		}
		
		public function toString():String {
			var out:String = "[object ASCIIRecord";
			out += " fileName:'" + getFileName() + "'";
			out += " title:'" + getTitle() + "'";
			out += " whiteThreshold:'" + getWhiteThreshold() + "'";
			out += " blackThreshold:'" + getBlackThreshold() + "'";
			out += "]";
			return out;
		}
	}
}
