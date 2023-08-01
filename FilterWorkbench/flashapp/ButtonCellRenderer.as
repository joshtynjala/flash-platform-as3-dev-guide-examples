package flashapp
{
	import fl.controls.Button;
	import fl.core.UIComponent;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import fl.managers.IFocusManagerComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	// ------- Styles -------
	[Style(name="background", type="Class")]
	[Style(name="disabledSkin", type="Class")]
	[Style(name="downSkin", type="Class")]
	[Style(name="emphasizedSkin", type="Class")]
	[Style(name="overSkin", type="Class")]
	[Style(name="upSkin", type="Class")]
	[Style(name="selectedDisabledSkin", type="Class")]
	[Style(name="selectedDownSkin", type="Class")]
	[Style(name="selectedOverSkin", type="Class")]
	[Style(name="selectedUpSkin", type="Class")]
	[Style(name="cellPadding", type="Number", format="Length")]
	
	
	public class ButtonCellRenderer extends UIComponent implements ICellRenderer
	{
		// ------- Private vars -------
		private var _data:Object;
		private var _listData:ListData;
		
		
		// ------- Child controls -------
		private var _background:DisplayObject;
		private var _button:Button;
		
		
		// ------- Constructor -------
		public function ButtonCellRenderer()
		{
			super();
		}
		
		
		// ------- Styles -------
		private static const defaultStyles:Object = 
												{
												background:"CellRenderer_upSkin",
												disabledSkin:"Button_disabledSkin",
												downSkin:"Button_downSkin",
												emphasizedSkin:"Button_emphasizedSkin",
												overSkin:"Button_overSkin",
												upSkin:"Button_upSkin",
												selectedDisabledSkin:"Button_selectedDisabledSkin",
												selectedDownSkin:"Button_selectedDownSkin",
												selectedOverSkin:"Button_selectedOverSkin",
												selectedUpSkin:"Button_selectedUpSkin",
												cellPadding:4
												};
		
		private static const BUTTON_STYLES:Object =
											{
											disabledSkin:"disabledSkin",
											downSkin:"downSkin",
											emphasizedSkin:"emphasizedSkin",
											overSkin:"overSkin",
											upSkin:"upSkin",
											selectedDisabledSkin:"selectedDisabledSkin",
											selectedDownSkin:"selectedDownSkin",
											selectedOverSkin:"selectedOverSkin",
											selectedUpSkin:"selectedUpSkin"
											};
		
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
		
		// ------- ICellRenderer implementation -------
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		public function get listData():ListData
		{
			return _listData;
		}
		public function set listData(value:ListData):void
		{
			_listData = value;
			_button.label = _listData.label;
			_button.setStyle("icon", _listData.icon);
		}
		
		
		public function get selected():Boolean
		{
			return _button.selected;
		}
		public function set selected(value:Boolean):void
		{
			_button.selected = value;
		}
		
		
		public function setMouseState(state:String):void
		{
			// do nothing
		}
		
		
		public override function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
		}
		
		
		// ------- Undocumented but required by ICellRenderer -------
		public override function set x(value:Number):void
		{
			super.x = value;
		}
		
		
		public override function set y(value:Number):void
		{
			super.y = value;
		}
		
		
		// ------- IFocusManagerComponent implementation -------
		// all inherited
		
		
		// ------- Additional UIComponent overrides -------
		protected override function draw():void
		{
			if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
			{
				copyStylesToChild(_button, BUTTON_STYLES);
				invalidate(InvalidationType.SIZE, false);
			}
			
			if (isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			
			validate();
		}
		
		
		protected override function configUI():void
		{
			super.configUI();
			
			_background = getDisplayObjectInstance(getStyleValue("background"));
			addChild(_background);
			
			_button = new Button();
			copyStylesToChild(_button, BUTTON_STYLES);
			_button.autoRepeat = false;
			addChild(_button);
			
			_button.addEventListener(MouseEvent.CLICK, buttonClick);
		}
		
		
		// ------- Event Handling -------
		private function buttonClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		
		// ------- Private methods -------
		// --- Layout/Styles ---
		private function drawLayout():void
		{
			_background.width = width;
			_background.height = height;
			
			var pad:Number = Number(getStyleValue("cellPadding"));
			_button.setSize(width - pad, Math.min(_button.height, height - pad));
			var newX:Number = (width / 2) - (_button.width / 2);
			var newY:Number = (height / 2) - (_button.height / 2);
			_button.move(newX, newY);
			_button.drawNow();
		}
	}
}