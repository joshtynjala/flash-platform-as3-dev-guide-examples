package flexapp
{
	import com.example.programmingas3.filterWorkbench.FilterWorkbenchController;
	import com.example.programmingas3.filterWorkbench.IFilterPanel;
	import com.example.programmingas3.filterWorkbench.ImageType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import flexapp.filterPanels.BevelPanel;
	import flexapp.filterPanels.BlurPanel;
	import flexapp.filterPanels.ColorMatrixPanel;
	import flexapp.filterPanels.ConvolutionPanel;
	import flexapp.filterPanels.DropShadowPanel;
	import flexapp.filterPanels.GlowPanel;
	import flexapp.filterPanels.GradientBevelPanel;
	import flexapp.filterPanels.GradientGlowPanel;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class FilterWorkbench extends Application
	{
		// ------- Constants -------
		// --- Filter types ---
		private static const BEVEL:String = "bevel";
		private static const BLUR:String = "blur";
		private static const COLOR_MATRIX:String = "colorMatrix";
		private static const CONVOLUTION:String = "convolution";
		private static const DROP_SHADOW:String = "dropShadow";
		private static const GLOW:String = "glow";
		private static const GRADIENT_BEVEL:String = "gradientBevel";
		private static const GRADIENT_GLOW:String = "gradientGlow";
		
		private static const INSTRUCTIONS_TEXT:String = "Select a filter and the corresponding\nActionScript code will appear here.\n\nClick \"Apply filter and add another\"\nto see the effect of multiple filters\napplied in combination.";
		
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.mxml
		public var filterPicker:ComboBox;
		public var filterTargetPicker:ComboBox;
		public var applyFilterBtn:Button;
		public var imageContainer:ImageContainer;
		public var codeDisplay:TextArea;
		public var filterFormContainer:Canvas;
		
		// Filter panels
		private var _bevelPanel:BevelPanel;
		private var _blurPanel:BlurPanel;
		private var _colorMatrixPanel:ColorMatrixPanel;
		private var _convolutionPanel:ConvolutionPanel;
		private var _dropShadowPanel:DropShadowPanel;
		private var _glowPanel:GlowPanel;
		private var _gradientBevelPanel:GradientBevelPanel;
		private var _gradientGlowPanel:GradientGlowPanel;
		
		// Controller
		private var _controller:FilterWorkbenchController;

		
		// ------- Constructor -------
		public function FilterWorkbench()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
		}
	
	
		// ------- Event handling -------
		private function setupChildren(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
			
			// instantiate the filter panels
			_bevelPanel = new BevelPanel();
			_blurPanel = new BlurPanel();
			_colorMatrixPanel = new ColorMatrixPanel();
			_convolutionPanel = new ConvolutionPanel();
			_dropShadowPanel = new DropShadowPanel();
			_glowPanel  = new GlowPanel();
			_gradientBevelPanel = new GradientBevelPanel();
			_gradientGlowPanel = new GradientGlowPanel();
			
			// set up data and events for the controls
			var filterList:ArrayCollection = new ArrayCollection();
			filterList.addItem({label:"< None >", data:null});
			filterList.addItem({label:"Bevel", data:BEVEL});
			filterList.addItem({label:"Blur", data:BLUR});
			filterList.addItem({label:"Color matrix", data:COLOR_MATRIX});
			filterList.addItem({label:"Convolution", data:CONVOLUTION});
			filterList.addItem({label:"Drop shadow", data:DROP_SHADOW});
			filterList.addItem({label:"Glow", data:GLOW});
			filterList.addItem({label:"Gradient bevel", data:GRADIENT_BEVEL});
			filterList.addItem({label:"Gradient glow", data:GRADIENT_GLOW});
			filterPicker.dataProvider = filterList;
			filterPicker.rowCount = 9;
			
			filterPicker.addEventListener(ListEvent.CHANGE, setFilter);
			
			var imageList:ArrayCollection = new ArrayCollection(ImageType.getImageTypes());
			filterTargetPicker.labelField = "name";
			filterTargetPicker.dataProvider = imageList;
			filterTargetPicker.selectedIndex = 0;
			
			filterTargetPicker.addEventListener(ListEvent.CHANGE, setImage);
			
			applyFilterBtn.enabled = false;
			applyFilterBtn.addEventListener(FlexEvent.BUTTON_DOWN, applyFilter);
			
			codeDisplay.text = INSTRUCTIONS_TEXT;
			
			// create the controller for the app
			_controller = new FilterWorkbenchController();
			_controller.addEventListener(ProgressEvent.PROGRESS, imageLoadProgress);
			_controller.addEventListener(Event.COMPLETE, imageLoadComplete);
			_controller.addEventListener(Event.CHANGE, updateCode);
			
			// load the first image
			_controller.setFilterTarget(filterTargetPicker.selectedItem as ImageType);
		}
		
		
		private function setFilter(event:ListEvent):void
		{
			setupSelectedFilter();
		}
		
		
		private function setImage(event:ListEvent):void
		{
			var imageType:ImageType = filterTargetPicker.selectedItem as ImageType;
			
			if (imageType == null) { return; }
			
			// remove the previous image
			if (imageContainer.numChildren > 0)
			{
				while (imageContainer.hasImage)
				{
					imageContainer.removeImage();
				}
			}
			
			// Show a progress indicator
			//CursorManager.setBusyCursor();
			
			_controller.setFilterTarget(imageType);
			
			resetForm();
		}
		
		
		private function applyFilter(event:FlexEvent):void
		{
			if (filterPicker.selectedIndex > 0)
			{
				_controller.applyFilter();
				resetForm();
			}
		}
		
		
		private function updateCode(event:Event):void
		{
			codeDisplay.text = _controller.getCode();
		}
		
		
		private function imageLoadProgress(event:ProgressEvent):void
		{
			// update the progress bar
		}
		
		
		private function imageLoadComplete(event:Event):void
		{
			// clear away the progress bar and display the image
			//CursorManager.removeBusyCursor();
			
			var image:DisplayObject = _controller.getFilterTarget();
			imageContainer.addImage(image);
		}
		
		
		// ------- Private methods -------
		private function resetForm():void
		{
			filterPicker.selectedIndex = 0;
			hideFilterForm();
			applyFilterBtn.enabled = false;
		}
		
		
		private function hideFilterForm():void
		{
			if (filterFormContainer.numChildren > 0)
			{
				filterFormContainer.removeChildAt(0);
			}
		}
		
		
		private function setupSelectedFilter():void
		{
			hideFilterForm();
			
			if (filterPicker.selectedIndex <= 0)
			{
				applyFilterBtn.enabled = false;
				_controller.setFilter(null);
				return;
			}
			
			applyFilterBtn.enabled = true;
			
			var filterPanel:IFilterPanel;
			
			switch (filterPicker.selectedItem.data)
			{
				case BEVEL:
					filterPanel = _bevelPanel;
					break;
				case BLUR:
					filterPanel = _blurPanel;
					break;
				case COLOR_MATRIX:
					filterPanel = _colorMatrixPanel;
					break;
				case CONVOLUTION:
					filterPanel = _convolutionPanel;
					break;
				case DROP_SHADOW:
					filterPanel = _dropShadowPanel;
					break;
				case GLOW:
					filterPanel = _glowPanel;
					break;
				case GRADIENT_BEVEL:
					filterPanel = _gradientBevelPanel;
					break;
				case GRADIENT_GLOW:
					filterPanel = _gradientGlowPanel;
					break;
			}
			
			var panelDO:DisplayObject;
			if ((panelDO = filterPanel as DisplayObject) != null)
			{
				filterFormContainer.addChild(panelDO);
			}
			filterPanel.resetForm();
			_controller.setFilter(filterPanel.filterFactory);
		}
	}
}