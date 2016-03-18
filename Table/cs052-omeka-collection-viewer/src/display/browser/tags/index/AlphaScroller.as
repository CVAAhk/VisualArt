package display.browser.tags.index 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.core.TouchSprite;
	import com.greensock.TweenLite;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * Controls naviagation to alphabetically sorted tag sections
	 * @author Ideum
	 */
	public class AlphaScroller extends Container implements SkinElement
	{		
		private var list:DoublyLinkedList;		//node data structure
		private var point:TouchEvent; 			//current interactive point event
		private var offset:Number = 0; 			//diff between scroller location and point registration		
		private var translator:TouchSprite;		//translation delta tracker
		private var nodes:Vector.<AlphaNode>;	//alpha node objects
		private var tapDuration:Number = 50; 	//qualifying tap time(ms) between up and down events
		private var tween:TweenLite;			//snap animation tween
		private var angle:Number = 0;			//concatenated rotation to incorporate in translations 
		
		private var _current:AlphaNode; 		//current node		
		private var _divider:Bitmap; 			//section divider graphic
		
		public var upperBoundary:Number; 		//upper translation limit before head to tail looping
		public var lowerBoundary:Number; 		//lower translation limit before tail to head looping	
		public var center:Sprite; 				//scroll center indicator
		public var onLetter:Function; 			//invoked on internal letter change		
		
		/**
		 * Constructor
		 */
		public function AlphaScroller() {
			nativeTransform = false; 			
			width = 160;
			height = 340; 
			graphics.beginFill(0x0, 0);
			graphics.drawRect(0, 0, width, height);		
			cacheAsBitmap = true; 
			scrollRect = new Rectangle(0, 0, width, height);
			
			translator = new TouchSprite();
			nodes = new Vector.<AlphaNode>();
			center = new Sprite();
			
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			addEventListener(TouchEvent.TOUCH_MOVE, onTouch);
			addEventListener(TouchEvent.TOUCH_END, onTouch);			
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouch);				
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {

			//create alpha nodes
			nodes.push(addChild(new AlphaNode("Misc.", this, true)));  //special characters
			nodes.push(addChild(new AlphaNode("123", this)));		   //numerical	
			for (var i:int = 0; i < 26; i++) {						   //alpha	
				nodes.push(addChild(new AlphaNode(String.fromCharCode(65+i), this)));
			}
								
			//translation limits
			upperBoundary = height / 2 - displayHeight / 2; 
			lowerBoundary = displayHeight + upperBoundary; 
			
			//link nodes
			list = new DoublyLinkedList(nodes);			
			
			//initial head position
			list.head.y = upperBoundary;  			
			
			//center line
			center.graphics.lineStyle(1, 0xFFFFFF, 0);			
			center.graphics.lineTo(width, 0);
			center.y = height / 2; 
			addChild(center);
			
			//skin
			updateSkin();
			
			//set drag angle
			angle = DisplayUtils.rotationFromMatrix(transform.concatenatedMatrix);
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			divider = Skin.instance.divider;			
		}
		
		/**
		 * Currently selected alpha node
		 */
		public function get current():AlphaNode { return _current; }
		public function set current(value:AlphaNode):void {
			if (_current == value) {
				return; 
			}
			if (_current) {
				_current.select = false; 
			}
			
			_current = value; 
			_current.select = true; 
			publish();
		}
		
		/**
		 * Divider graphic
		 */
		private function get divider():Bitmap { return _divider; }
		private function set divider(value:Bitmap):void {
			if (_divider) {
				_divider.bitmapData.dispose();
				removeChild(_divider);
				_divider = null;
			}
			_divider = value; 
			if (_divider) {
				_divider.x = width - _divider.width; 
				addChild(_divider);
			}
		}
		
		/**
		 * Evaluate touch type and call appropriate handler
		 * @param	event
		 */
		private function onTouch(event:TouchEvent):void {
			if (event.type == TouchEvent.TOUCH_BEGIN) {
				touchBegin(event);
			}
			else if (event.type == TouchEvent.TOUCH_MOVE) {
				touchMove(event);
			}
			else{
				touchEnd(event);
			}
		}
		
		/**
		 * Limit touch to one point
		 * @param	event
		 */
		private function touchBegin(event:TouchEvent):void {
			if (!point) {
				offset = event.stageY - (translator.y * Math.cos(angle));
				point = event;
				point.pressure = getTimer();
			}
		}
		
		/**
		 * Translate elements
		 * @param	event
		 */
		private function touchMove(event:TouchEvent):void {
			if (isPoint(event)) { 
				translator.y = (event.stageY - offset) * Math.cos(angle); 
				list.head.y += translator.dy; 				
			}
		}
		
		/**
		 * Evaluate tap target and snap to current
		 * @param	event
		 */
		private function touchEnd(event:TouchEvent):void {
			if (isPoint(event)) {
				
				//evaluate tap gesture
				if (event.target == point.target && getTimer() - point.pressure <= tapDuration) {
					snapToNode(event.target as AlphaNode, snapComplete);
				}
				else {
					snapToNode(current, snapComplete);
				}
			}
			//clear point
			point = null; 
		}	
		
		/**
		 * Returns true if event is triggered by the current point and false otherwise
		 * @param	event
		 * @return
		 */
		private function isPoint(event:TouchEvent):Boolean { return point && point.touchPointID == event.touchPointID; }
		
		/**
		 * Invoke subscribing callback on letter change
		 */
		private function publish():void {
			if (onLetter != null && !tween) {
				onLetter.call(null, _current.letter);
			}			
		}
		
		/**
		 * Snaps to specified letter. State publishing is bypassed since this is an external state change. 
		 * @param	letter
		 */
		public function snapToLetter(letter:String):void {
			var index:int; 
			if(letter.length == 1){
				index = letter.charCodeAt(0) - 63;
			}
			else if (letter == "123") {
				index = 1; 
			}
			snapToNode(nodes[index], clearTween);
		}
		
		/**
		 * Animate current node to snap position
		 * @param	node
		 */
		private function snapToNode(node:AlphaNode, onComplete:Function):void { 
			if (!node) {
				return; 
			}
			if (!tween) {
				translator.y = node.y + node.height/2;
				tween = TweenLite.to(translator, .4, { y:center.y, onUpdate:snap, onComplete:onComplete } );
			}
		}	
		
		/**
		 * Update position of nodes
		 */
		private function snap():void {
			list.head.y += translator.dy; 
		}
		
		/**
		 * Clear tween and publish state
		 */
		private function snapComplete():void {
			clearTween();
			publish();
		}
		
		/**
		 * Clear tween
		 */
		private function clearTween():void {
			tween = null; 
		}
	}

}