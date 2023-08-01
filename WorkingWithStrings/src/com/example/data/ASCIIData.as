package com.example.data {
	import com.example.data.StringData;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.util.trace;
	import com.example.data.ASCIIRecord;

	public class ASCIIData extends StringData {
		private var accessors:Array;
		private var records:Array;
		private var strHelper:StringHelper;

		public function ASCIIData(request:URLRequest = null) {
			super(request);
			records = new Array();
			accessors = getRecordAccessors();
			strHelper = new StringHelper();
		}
		
		private function getRecordAccessors():Array {
			var names:Array = new Array();
			names.push("setFileName");
			names.push("setTitle");
			names.push("setWhiteThreshold");
			names.push("setBlackThreshold");
			return names;
		}
		
		public function getLength():uint {
			return records.length;
		}
		
		public function getRecord(index:Number):ASCIIRecord {
			return records[index];
		}
		
		public function getIterator():Iterable {
			return new ASCIIDataIterator(this);
		}
		
		protected override function completeHandler(event:Event):void {
			parse();
		}
		
		public function parse():void {
			var rows:Array = data.split("\n");
			var len:uint = rows.length;
			var row:String;
			for(var i:uint = 1; i < len; i++) {
				row = strHelper.trim(rows[i], " ");
				if(row.length > 0) {
					records.push(parseRecord(row));
				}
			}
		}
		
		private function parseRecord(row:String):Object {
			var properties:Array = row.split("\t");
			var record:ASCIIRecord = new ASCIIRecord();
			var len:uint = properties.length;
			for(var i:uint; i < len; i++) {
				record[accessors[i]](properties[i]);
			}
			return record;
		}
	}
	
}

import com.example.data.Iterable;
import com.example.data.ASCIIData;

class ASCIIDataIterator implements Iterable {
	private var context:ASCIIData;
	private var index:uint;
	
	public function ASCIIDataIterator(data:ASCIIData) {
		context = data;
		index = 0;
	}
	
	public function hasNext():Boolean {
		return (index < context.getLength());
	}
	
	public function next():Object {
		return context.getRecord(index++);
	}
}
