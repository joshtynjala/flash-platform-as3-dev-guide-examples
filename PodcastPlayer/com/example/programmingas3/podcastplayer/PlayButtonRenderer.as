package com.example.programmingas3.podcastplayer
{
	import fl.controls.LabelButton;
    import fl.controls.listClasses.CellRenderer;
    import fl.controls.listClasses.ICellRenderer;
    import fl.controls.listClasses.ListData;
	import fl.events.DataGridEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
    public class PlayButtonRenderer extends LabelButton implements ICellRenderer 
	{
        private var _listData:ListData;
        private var _data:Object;

        public function PlayButtonRenderer():void
		{
			//addEventListener(MouseEvent.CLICK, onPlayButtonClick);
        }
		
        public function set data(d:Object):void {
            _data = d;
            this.label = "Play";
			this.setStyle("icon", playIcon);
        }
        public function get data():Object {
            return _data;
        }
        public function set listData(ld:ListData):void {
            _listData = ld;
        }
        public function get listData():ListData {
            return _listData;
        }
        public override function set selected(s:Boolean):void {
            _selected = s;
        }
        public override function get selected():Boolean {
            return _selected;
        }

		public function onPlayButtonClick():void
		{
			var evt:DataGridEvent = new DataGridEvent("cellButtonClick", false, false, this.listData.column, this.listData.row, this);
			this.listData.owner.dispatchEvent(evt);
		}
    }
}


