package display.load 
{
	import assets.GUIAssets;
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import display.OmekaCollectionViewer;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * Provides a drop down list of options
	 * @author Ideum
	 */
	public class DropDown extends Sprite
	{
		private var background:Bitmap;
		private var text:BoundedText;
		private var button:Trigger;
		private var loadMenu:LoadMenu;
		private var scroller:OptionScroller;
		private var point:TouchEvent;
		private var openTween:TweenLite;
		private var tapDuration:Number; 
		
		private var _option:Option;
		private var _open:Boolean;
		
		/**
		 * Constructor
		 * @param	defaultText - text prior to selection
		 */
		public function DropDown() {
			
			//background graphic
			background = addChild(GUIAssets.instance.dropDown) as Bitmap;
						
			//option list
			scroller = new OptionScroller();
			scroller.x = 2; 
			scroller.y = -scroller.height;
			addChildAt(scroller, 0);
			
			//text display
			text = new BoundedText();
			text.str = " ";
			text.x = 25;			
			text.y = height / 2 - text.getLineMetrics(0).height / 2;						
			addChild(text);			
			
			//open/close button
			button = new Trigger();
			button.x = width - button.width;
			addChild(button);
			
			//display masking
			scrollRect = new Rectangle(0, 0, background.width, background.height + scroller.height);
			cacheAsBitmap = true; 
			
			//animation
			openTween = TweenLite.to(scroller, .2, { y:background.height - 4, ease:Circ.easeOut, paused:true } );			
			
			//store reference to load menu parent
			addEventListener(Event.ADDED, function onAdd(e:Event):void {
				removeEventListener(Event.ADDED, onAdd);
				loadMenu = LoadMenu(parent);
			});
		}
		
		/**
		 * Add/remove touch events
		 */
		public function set enableTouch(value:Boolean):void {
			if (value) {
				addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
				addEventListener(TouchEvent.TOUCH_END, onTouch);
				tapDuration = OmekaCollectionViewer.instance.tapDuration;
			}
			else {
				removeEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
				removeEventListener(TouchEvent.TOUCH_END, onTouch);				
			}
		}
		
		/**
		 * Touch handler
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
		 * Track down point
		 * @param	event
		 */
		private function onDown(event:TouchEvent):void {
			if (point != null) {
				return; 
			}
			if (event.target is Option) {
				event.pressure = getTimer();
				point = event; 
			}
		}
		
		/**
		 * Evaluate target and tap time
		 * @param	event
		 */
		private function onUp(event:TouchEvent):void {
			if (point && point.touchPointID == event.touchPointID) {
				if(event.target == point.target && getTimer() - point.pressure <= tapDuration){
					option = point.target as Option; 
					text.text = _option.value;
				}
			}
			point = null; 
		}
		
		/**
		 * Open state
		 */
		public function get open():Boolean { return _open; }
		public function set open(value:Boolean):void {
			if (openTween._active) {
				openTween.kill();
			}
			_open = value; 
			if (_open) {
				openTween.play();
			}
			else {
				openTween.reverse();
			}
		}
		
		/**
		 * The current value
		 */
		public function get value():String { return text.fullText; }
		
		/**
		 * Assign options to scroller
		 */
		public function set options(value:Vector.<String>):void {
			if (value.length > 0) {
				text.str = value[0];
			}
			scroller.options = value; 
			option = scroller.list.getChildAt(0) as Option;
			scroller.init();			
		}
		
		/**
		 * Selected option
		 */
		public function set option(value:Option):void {
			if (_option) {
				_option.toggle();
			}
			_option = value; 
			if (_option) {
				_option.toggle();
			}
			loadMenu.dropDown = null; 
		}
	}

}