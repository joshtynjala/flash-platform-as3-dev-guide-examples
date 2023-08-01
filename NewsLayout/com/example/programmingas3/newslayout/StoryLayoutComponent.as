package com.example.programmingas3.newslayout
{
    import mx.core.UIComponent;
    import com.example.programmingas3.newslayout.StoryLayout;
	                
    public class StoryLayoutComponent extends UIComponent
    {
        public var story:StoryLayout;
        
        public var preferredWidth:Number = 400;
        public var preferredHeight:Number = 300;
        public var numColumns:int = 3;
        public var padding:int = 10;
        
        public function StoryLayoutComponent():void
        {
            super();
        }
        
        public function initStory():void
        {    
            this.story = new StoryLayout(this.preferredWidth, 
                                          this.preferredHeight, 
                                          this.numColumns, 
                                          this.padding);
            
            this.addChild(story);
        }
        
    }
}