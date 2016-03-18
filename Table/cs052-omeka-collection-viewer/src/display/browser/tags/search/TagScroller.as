package display.browser.tags.search 
{
	import assets.Skin;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.managers.TouchManager;
	import com.greensock.TweenLite;
	import display.abstract.Scroller;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	/**
	 * Manages tag list navigation
	 * @author Ideum
	 */
	public class TagScroller extends Scroller
	{
		private var list:TagList; 				//tag list				
		
		private var _background:Bitmap; 
		
		public var onSection:Function; 			//invoked on alpha section change				
		
		/**
		 * Constructor
		 */
		public function TagScroller() {						
			width = 752;
			height = 250; 
			list = new TagList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {			
			list.init();
			list.layoutComplete = function():void { 
				content = list; 
				if (onSection != null) {
					onSection.call(null, list.section);
				}
			};
			super.init();			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateSkin():void {
			super.updateSkin();
			background = Skin.instance.tagBackground;
		}
		
		/**
		 * Background display
		 */
		private function get background():Bitmap { return _background; }
		private function set background(value:Bitmap):void {
			if (_background) {
				_background.bitmapData.dispose();
				removeChild(_background);
				_background = null;
			}
			_background = value; 
			if (_background) {
				addChildAt(_background, 0);
			}
		}
		
		/**
		 * @inheritDoc
		 * @param	event
		 */
		override protected function scroll(event:GWGestureEvent):void {
			super.scroll(event);
			publish();			
		}
		
		/**
		 * Scrolls list to beginning of the specified letter section
		 * @param	letter
		 */
		public function scrollToLetter(letter:String):void {
			var pos:Number = list.alphaPosition(letter);
			if (!isNaN(pos)) {
				stopInertia();
				TweenLite.killTweensOf(content);
				TweenLite.to(content, 0.5, { y: pos, onUpdate:syncGrabberWithContent } );
			}
		}
		
		/**
		 * Array of tag values
		 */
		public function set tags(value:Vector.<String>):void {
			reset();
			list.tagNames = value; 
		}				
		
		/**
		 * @inheritDoc
		 */
		override public function set totalPointCount(value:int):void {
			super.totalPointCount = value;
			publish();
		}
		
		/**
		 * Publish current alpha section to subscribing callback
		 */
		private function publish():void {	
			if (totalPointCount == 0 && Math.abs(target.dy) <= 1) {
				stopInertia();
				if (onSection != null) {
					onSection.call(null, list.section);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 * @param	event
		 */
		override protected function touchTarget(event:TouchEvent):void {
			super.touchTarget(event);
			listenOut = true; 
		}
		
		/**
		 * Listen for roll out event
		 */
		private function set listenOut(value:Boolean):void {
			if (value) {
				addEventListener(TouchEvent.TOUCH_ROLL_OUT, onOut);
			}
			else {
				removeEventListener(TouchEvent.TOUCH_ROLL_OUT, onOut);
			}
		}
		
		/**
		 * Prevent touch points that move outside of scroller from controlling the element
		 * @param	event
		 */
		private function onOut(event:TouchEvent):void {
			listenOut = false; 
			TouchManager.removePoints(this, pointArray);
		}
	}

}