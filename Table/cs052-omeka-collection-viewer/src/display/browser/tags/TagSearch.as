package display.browser.tags 
{
	import com.gestureworks.cml.elements.Container;
	import display.browser.tags.index.AlphaScroller;
	import display.browser.tags.query.QueryController;
	import display.browser.tags.search.Tag;
	import display.browser.tags.search.TagScroller;
	import display.OmekaCollectionViewer;
	import flash.events.TouchEvent;
	import flash.utils.getTimer;
	
	/**
	 * Tag search control
	 * @author Ideum
	 */
	public class TagSearch extends Container
	{
		private var alphaScroller:AlphaScroller;		//alpha index control
		private var tagScroller:TagScroller; 			//tag navigator
		private var query:QueryController;				//displays and submits queries to database
		private var point:TouchEvent;					//potential selection event
		private var tapDuration:Number; 				//qualifying tap time(ms) between up and down events
		
		public var onSelect:Function;					//funciton invoked on tag selection
		public var onUnselect:Function;					//function invoked on tag unselection
		
		/**
		 * Constructor
		 */
		public function TagSearch() {
			width = 915; 
			height = 340; 
			
			alphaScroller = new AlphaScroller();
			tagScroller = new TagScroller();
			query = new QueryController();
			
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			addEventListener(TouchEvent.TOUCH_END, onTouch);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			
			if(!initialized){
				tapDuration = OmekaCollectionViewer.instance.tapDuration; 
				
				addChild(alphaScroller);
				alphaScroller.onLetter = scrollToLetter; 
				alphaScroller.init();
				
				addChild(query);
				query.x = alphaScroller.width; 
				query.onRemove = onUnselect; 
				query.init();
				
				addChild(tagScroller);
				tagScroller.x = alphaScroller.width;
				tagScroller.y = height - tagScroller.height; 
				tagScroller.onSection = snapToLetter; 
				tagScroller.init();
			}
			
			super.init();			
		}
		
		/**
		 * Array of tag values
		 */
		public function set tags(value:Vector.<String>):void {
			query.clear();
			tagScroller.tags = value; 
		}
		
		/**
		 * Navigates to specified letter section in tag list
		 * @param	letter
		 */
		private function scrollToLetter(letter:String):void {
			tagScroller.scrollToLetter(letter);
		}
		
		/**
		 * Snaps to specified letter in alpha scroller
		 * @param	letter
		 */
		private function snapToLetter(letter:String):void {
			alphaScroller.snapToLetter(letter);
		}
		
		/**
		 * Evanluate touch event type
		 * @param	event
		 */
		private function onTouch(event:TouchEvent):void {
			if (event.type == TouchEvent.TOUCH_BEGIN) {
				onDown(event);
			}
			else {
				onUp(event);
			}
		}
		
		/**
		 * Determine potential tag selection
		 * @param	event
		 */
		private function onDown(event:TouchEvent):void {
			if (point != null) {
				return; 
			}
			if (event.target is Tag) {				
				event.pressure = getTimer();
				point = event; 
			}			
		}
		
		/**
		 * Determine if up event meets tap criteria
		 * @param	event
		 */
		private function onUp(event:TouchEvent):void {
			if (query.occupied) {
				return; 
			}
			if (isPoint(event)) {
				if (point.target == event.target && getTimer() - point.pressure <= tapDuration) {
					if (!event.target.selected) {						
						event.target.selected = true; 
						query.addTag(event.target as Tag);						
						if (onSelect != null) {
							onSelect.call(null, event.target as Tag);
						}
					}
				}
			}
			point = null; 
		}
		
		/**
		 * Checks to see if up corresponds to registered down point
		 * @param	event
		 * @return
		 */
		private function isPoint(event:TouchEvent):Boolean { return point && point.touchPointID == event.touchPointID; }
	}

}