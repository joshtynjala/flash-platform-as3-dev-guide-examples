package 
{ 
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat; 
	
	public class TLFNewsLayout extends Sprite 
	{ 
		private var hTextFlow:TextFlow; 
		private var headContainer:Sprite; 
		private var headlineController:ContainerController; 
		private var hContainerFormat:TextLayoutFormat; 
		
		private var bTextFlow:TextFlow; 
		private var bodyTextContainer:Sprite; 
		private var bodyController:ContainerController; 
		private var bodyTextContainerFormat:TextLayoutFormat; 
		
		private const headlineMarkup:String = "<flow:TextFlow xmlns:flow='http://ns.adobe.com/textLayout/2008'><flow:p textAlign='center'><flow:span fontFamily='Helvetica' fontSize='18'>TLF News Layout Example</flow:span><flow:br/><flow:span fontFamily='Helvetica' fontSize='14'>This example formats text like a newspaper page with a headline, a subtitle, and multiple columns</flow:span></flow:p></flow:TextFlow>"; 
		
		private const bodyMarkup:String = "<flow:TextFlow xmlns:flow='http://ns.adobe.com/textLayout/2008' fontSize='12' textIndent='10' marginBottom='15' paddingTop='4' paddingLeft='4'><flow:p marginBottom='inherit'><flow:span>There are many </flow:span><flow:span fontStyle='italic'>such</flow:span><flow:span> lime-kilns in that tract of country, for the purpose of burning the white marble which composes a large part of the substance of the hills. Some of them, built years ago, and long deserted, with weeds growing in the vacant round of the interior, which is open to the sky, and grass and wild-flowers rooting themselves into the chinks of the stones, look already like relics of antiquity, and may yet be overspread with the lichens of centuries to come. Others, where the lime-burner still feeds his daily and nightlong fire, afford points of interest to the wanderer among the hills, who seats himself on a log of wood or a fragment of marble, to hold a chat with the solitary man. It is a lonesome, and, when the character is inclined to thought, may be an intensely thoughtful occupation; as it proved in the case of Ethan Brand, who had mused to such strange purpose, in days gone by, while the fire in this very kiln was burning.</flow:span></flow:p><flow:p marginBottom='inherit'><flow:span>The man who now watched the fire was of a different order, and troubled himself with no thoughts save the very few that were requisite to his business. At frequent intervals, he flung back the clashing weight of the iron door, and, turning his face from the insufferable glare, thrust in huge logs of oak, or stirred the immense brands with a long pole. Within the furnace were seen the curling and riotous flames, and the burning marble, almost molten with the intensity of heat; while without, the reflection of the fire quivered on the dark intricacy of the surrounding forest, and showed in the foreground a bright and ruddy little picture of the hut, the spring beside its door, the athletic and coal-begrimed figure of the lime-burner, and the half-frightened child, shrinking into the protection of his father's shadow. And when again the iron door was closed, then reappeared the tender light of the half-full moon, which vainly strove to trace out the indistinct shapes of the neighboring mountains; and, in the upper sky, there was a flitting congregation of clouds, still faintly tinged with the rosy sunset, though thus far down into the valley the sunshine had vanished long and long ago.</flow:span></flow:p></flow:TextFlow>"; 
		
		public function TLFNewsLayout() 
		{ 	
			//wait for stage to exist
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		} 
		
		private function onAddedToStage(evtObj:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			// Headline text flow and flow composer 
			hTextFlow = TextConverter.importToFlow(headlineMarkup, TextConverter.TEXT_LAYOUT_FORMAT); 
			hTextFlow.flowComposer = new StandardFlowComposer(); 
			
			// initialize the headline container and controller objects 
			headContainer = new Sprite(); 
			headlineController = new ContainerController(headContainer); 
			headlineController.verticalScrollPolicy = ScrollPolicy.OFF; 
			hContainerFormat = new TextLayoutFormat(); 
			hContainerFormat.paddingTop = 4; 
			hContainerFormat.paddingRight = 4; 
			hContainerFormat.paddingBottom = 4; 
			hContainerFormat.paddingLeft = 4; 
			
			headlineController.format = hContainerFormat; 
			hTextFlow.flowComposer.addController(headlineController); 
			addChild(headContainer); 
			stage.addEventListener(flash.events.Event.RESIZE, resizeHandler); 
			
			// Body text TextFlow and flow composer 
			bTextFlow = TextConverter.importToFlow(bodyMarkup, TextConverter.TEXT_LAYOUT_FORMAT); 
			bTextFlow.flowComposer = new StandardFlowComposer(); 
			
			// The body text container is below, and has three columns 
			bodyTextContainer = new Sprite(); 
			bodyController = new ContainerController(bodyTextContainer); 
			bodyTextContainerFormat = new TextLayoutFormat(); 
			bodyTextContainerFormat.columnCount = 3; 
			bodyTextContainerFormat.columnGap = 30; 
			
			bodyController.format = bodyTextContainerFormat; 
			bTextFlow.flowComposer.addController(bodyController); 
			addChild(bodyTextContainer); 
			resizeHandler(null); 
		} 
		
		private function resizeHandler(event:Event):void 
		{ 
			const verticalGap:Number = 25; 
			const stagePadding:Number = 16; 
			var stageWidth:Number = stage.stageWidth - stagePadding; 
			var stageHeight:Number = stage.stageHeight - stagePadding; 
			var headlineWidth:Number = stageWidth; 
			var headlineContainerHeight:Number = stageHeight; 
			
			// Initial compose to get height of headline after resize 
			headlineController.setCompositionSize(headlineWidth, headlineContainerHeight); 
			hTextFlow.flowComposer.compose(); 
			var rect:Rectangle = headlineController.getContentBounds(); 
			headlineContainerHeight = rect.height; 
			
			// Resize and place headline text container 
			// Call setCompositionSize() again with updated headline height 
			headlineController.setCompositionSize(headlineWidth, headlineContainerHeight ); 
			headlineController.container.x = stagePadding / 2; 
			headlineController.container.y = stagePadding / 2; 
			hTextFlow.flowComposer.updateAllControllers(); 
			
			// Resize and place body text container 
			var bodyContainerHeight:Number = (stageHeight - verticalGap - headlineContainerHeight); 
			bodyController.format = bodyTextContainerFormat; 
			bodyController.setCompositionSize(stageWidth, bodyContainerHeight ); 
			bodyController.container.x = (stagePadding/2); 
			bodyController.container.y = (stagePadding/2) + headlineContainerHeight + verticalGap; 
			bTextFlow.flowComposer.updateAllControllers(); 
		} 
	} 
} 