package com.example.programmingas3.wordProcessor
{
	public class TextFinder
	{
		/**
		 * Searches for the next occurance of a String in another String, starting at the specified
		 * start index.
		 * @param findIn			The String to search in.
		 * @param toFind			The String to search for.
		 * @param startIndex		The index within "findIn" at which to start the search. The default is 0, the start of the String.
		 * @param caseSensitive		Whether the search should be case sensitive (true) or case should be ignored (false). The default is false.
		 * @param wrapSearch		Whether to "wrap" the search if the searched-for text isn't found between startIndex and the end of the text. The default is true.
		 * @return 		The index in the "findIn" String where "toFind" was found, or -1 if it wasn't found.
		 */
		public function find(findIn:String, toFind:String = "", startIndex:Number = 0, caseSensitive:Boolean = false, wrapSearch:Boolean = true):Number
		{
			if (!caseSensitive)
			{
				// Make both strings (the one being searched and the one being searched for)
				// lower-case, so that case differences don't matter.
				findIn = findIn.toLowerCase();
				toFind = toFind.toLowerCase();
			}
			
			// search for the "toFind" text between startIndex and the end of the string
			var result:Number = findIn.indexOf(toFind, startIndex);
			// if it wasn't found, and the search should wrap, search for the "toFind" text starting
			// at the beginning.
			if (result == -1 && wrapSearch)
			{
				result = findIn.indexOf(toFind, 0);
			}
			return result;
		}
		
		
		/**
		 * Replaces the segment of text between startIndex and endIndex in a String with a different String.
		 * @param replaceIn		The text in which the replacement should be made.
		 * @param newText		The text to substitute in.
		 * @param startIndex	The starting index of the text to be replaced.
		 * @param endIndex		The ending index of the text to be replaced.
		 * @return 		The text after the replacement operation.
		 */
		public function replace(replaceIn:String, newText:String, startIndex:Number, endIndex:Number):String
		{
			// divide the main string into two pieces:
			// 	- the part before the part to be replaced
			//	- the part after the part to be replaced
			var startBlock:String = replaceIn.substring(0, startIndex);
			var endBlock:String = replaceIn.substr(endIndex);
			
			// join the pieces back with the replacement text in the middle
			var result:String = startBlock + newText + endBlock;
			return result;
		}
	}
}