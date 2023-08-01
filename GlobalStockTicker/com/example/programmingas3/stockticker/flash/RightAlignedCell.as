package com.example.programmingas3.stockticker.flash
{
    import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    /**
     * The main class definition. Make sure the class is marked "public" and in the case
     * of our custom cell renderer, extends the CellRenderer class and implements the
     * ICellRenderer interface.
     */
    public class RightAlignedCell extends CellRenderer implements ICellRenderer 
	{
        // Create a new private variable to hold the custom text format.
        private var tf:TextFormat;
        /**
         * This method defines the TextFormat object and sets the align
         * property to "right".
         */
        public function RightAlignedCell() 
		{
            tf = new TextFormat();
            tf.align = TextFormatAlign.RIGHT;
        }
        /**
         * Override the inherited drawLayout() method from the CellRenderer class.
         * This method sets the text field's width to the width of the data grid column,
         * applies the new text format using the setTextFormat() method, and calls the
         * parent class's drawLayout() method. 
         */
        override protected function drawLayout():void {
            textField.width = this.width;
            textField.setTextFormat(tf);
            super.drawLayout();
        }
    }
}
