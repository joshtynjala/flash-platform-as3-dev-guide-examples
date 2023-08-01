package com.example.programmingas3.playlist
{
	import com.example.programmingas3.playlist.Song;
	import com.example.programmingas3.playlist.SortProperty;

	/**
	 * Provides functionality for managing a sortable list of songs.
	 */
	public class PlayList
	{
		// ------- Private variables -------
		
		private var _songs:Array;
		private var _currentSort:SortProperty = null;
		private var _needToSort:Boolean = false;


		// ------- Constructor -------
		
		public function PlayList()
		{
			this._songs = new Array();
			// set the initial sorting
			this.sortList(SortProperty.TITLE);
		}


		// ------- Public Properties -------
		
		/**
		 * Gets the list of songs
		 */
		public function get songList():Array
		{
			// Sort the songs, if needed.
			// For efficiency this is done here rather than, for instance, each time a song is added.
			// That way if multiple songs are added in a batch, the list won't be sorted each time.
			if (this._needToSort)
			{
				// record the current sorting method
				var oldSort:SortProperty = this._currentSort;
				// clear out the current sort so that it will re-sort
				this._currentSort = null;
				this.sortList(oldSort);
			}
			return this._songs;
		}
		

		// ------- Public Methods -------
		
		/**
		 * Adds a song to the playlist
		 */
		public function addSong(song:Song):void
		{
			this._songs.push(song);
			this._needToSort = true;
 		}


		/**
		 * Sorts the list of songs according to the specified property
		 */
		public function sortList(sortProperty:SortProperty):void
		{
			if (sortProperty == this._currentSort)
			{
				return;
			}

			var sortOptions:uint;
			switch (sortProperty)
			{
				case SortProperty.TITLE:
					sortOptions = Array.CASEINSENSITIVE;
					break;
				case SortProperty.ARTIST:
					sortOptions = Array.CASEINSENSITIVE;
					break;
				case SortProperty.YEAR:
					sortOptions = Array.NUMERIC;
					break;
			}
			
			// perform the actual sorting of the data
			this._songs.sortOn(sortProperty.propertyName, sortOptions);
			
			// save the current sort property
			this._currentSort = sortProperty;

			// record that the list is sorted
			this._needToSort = false;
		}
	}
}