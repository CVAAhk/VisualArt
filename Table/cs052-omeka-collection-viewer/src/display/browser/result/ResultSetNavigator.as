package display.browser.result 
{
	import assets.GUIAssets;
	import assets.Skin;
	import com.gestureworks.cml.base.media.MediaStatus;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.layouts.Layout;
	import com.gestureworks.cml.layouts.ListLayout;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.managers.TouchManager;
	import com.greensock.easing.Power0;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import data.ItemData;
	import display.abstract.SkinElement;
	import display.browser.BrowserMember;
	import display.browser.Handle;
	import display.OmekaCollectionViewer;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Ideum
	 */
	public class ResultSetNavigator extends BrowserMember implements SkinElement
	{	 		
		private var _anchorX:Number = 0; 			//the x location to revert to when album is offset by tension translations
		private var _tensionDistance:Number = 30; 	//the horizontal offset premitted when items reaches boundary limits
		private var _alphaMasking:Boolean;			//enables alpha masking for browsers with elements outside of the render area
		private var _snapping:Boolean; 				//enables position snapping on release
				
		private var dragDelta:Number; 				//album's current drag gesture delta
		private var snapLeft:Boolean;				//flag indicating direction to move in to restore x location when offset by tension
		private var rightFade:Bitmap;				//right fade graphic
		private var leftFade:Bitmap;				//left fade graphic
		private var rightMinX:Number;				//initial x coordinate of right fade graphic used in scrolling algorithm
		private var leftMinX:Number; 				//initial x coordinate of right fade graphic used in scrolling algorithm
		private var alphaMask:Sprite				//fade graphic container 
		private var snapLine:Sprite;				//center line used to detect closest snap position 
		private var snapPoints:Array;				//indexed snap position of each element
		private var angle:Number = 0; 				//concatenated rotation factored into drag direction
		private var points:Dictionary;				//registered touch points
		private var itemPool:Vector.<Item>;			//stores items to be recylced as result sets adjust
		private var tags:Dictionary;				//tag to item mapping
		private var results:Dictionary;				//tracks result occurrences
		private var loadCount:int;					//tracks item loading
		private var handle:Handle;					//reference to browser handle to push result count updates to
		private var tapDuration:Number;				//qualifying tap time(ms) between up an down events
		
		private var _prompt:Bitmap;					//query instructions displayed when result set is empty		
		
		protected const LEFT:int = 0;				//indicates left drag direction
		protected const RIGHT:int = 1;				//indicates right drag direction
		protected var direction:int; 				//the horizontal direction the album is being dragged
		protected var belt:Container;				//draggable item container
		protected var regulator:Container;			//belt container for drag tension and snapping effects		
		
		/**
		 * Renders background display
		 * @default false
		 */		
		public var background:Boolean;

		/**
		 * Color of background display when @see #background is enabled
		 * @default 0x000000
		 */		
		public var backgroundColor:uint; 
		
		/**
		 * Alpha of background display when @see #background is enabled
		 * @default 1
		 */
		public var backgroundAlpha:Number = 1; 
		
		/**
		 * Space bwetween child items
		 * @default 0
		 */
		public var margin:Number = 75; 
 
		/**
		 * Threshold triggering position snapping when inertia delta falls below
		 */
		public var snapDelta:Number = 5;	
		
		
		/**
		 * Total number of items in omeka repository
		 */
		public var totalItems:int; 				
						
		
		/**
		 * Constructor
		 */
		public function ResultSetNavigator() {	
			
			width = 2805; 
			height = 340; 
			graphics.beginFill(0, 0);			
			graphics.drawRect(0, 0, width, height);
			
			alphaMask = new Sprite();
			rightFade = GUIAssets.instance.rightFade;
			leftFade = GUIAssets.instance.leftFade;	
			alphaMask.addChild(rightFade);
			alphaMask.addChild(leftFade);
						
			belt = new Container();						
			regulator = new Container();			
			gestureList = { "n-drag-inertia":true }; 						
			releaseInertia = true; 
			nativeTransform = false; 
			
			points = new Dictionary(true);		
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			addEventListener(TouchEvent.TOUCH_END, onTouch);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouch); 
			
			tags = new Dictionary(true);
			results = new Dictionary(true);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {						
			if (!initialized) {						
				regulator.addChild(belt);
				super.addChild(regulator);	
				
				tapDuration = OmekaCollectionViewer.instance.tapDuration; 
				
				snapLine = new Sprite();
				snapLine.graphics.lineStyle(1);
				snapLine.graphics.moveTo(0, 0);
				snapLine.graphics.lineTo(0, height);
				snapLine.visible = false; 
				super.addChild(snapLine);	
				
				snapPoints = [];
				angle = DisplayUtils.rotationFromMatrix(transform.concatenatedMatrix);
				
				updateSkin();
			}
			super.init();
			handle = browser.handle;
			initPool();			
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			prompt = Skin.instance.prompt;	
			for each(var item:Item in itemPool) {
				item.updateSkin();
			}
		}
		
		/**
		 * Query instructions displayed when result set is empty		
		 */
		private function get prompt():Bitmap { return _prompt; }
		private function set prompt(value:Bitmap):void {
			if (_prompt) {
				_prompt.bitmapData.dispose();
				removeChild(_prompt);
				_prompt = null;
			}
			_prompt = value; 
			if (_prompt) {
				_prompt.smoothing = true; 
				addChildAt(_prompt, 0);
			}
		}
		
		/****************************ITEM TRACKING****************************/		
		
		/**
		 * Initialize object pool for result containers
		 * @param	size
		 */
		private function initPool(size:int = 50):void {
			itemPool = new Vector.<Item>();
			for (var i:int = 0; i < size; i++) {
				itemPool.push(new Item(browser));
			}
		}
		
		/**
		 * If data references a selected item, return that item. If not, return the next object in the item pool.
		 * If the pool is empty, return a new Item instance to be later incorporated in the pool. 
		 */
		private function nextItem(result:ItemData):Item {
			if (browser.isPrimary && result.primary) {
				result.primary.revive = null;
				return result.primary;
			}
			if (!browser.isPrimary && result.secondary) {
				result.secondary.revive = null; 
				return result.secondary;
			}
			if (itemPool.length != 0) {
				return itemPool.shift();
			}
			return new Item(browser);
		}
		
		/**
		 * Return unselected items to object pool and register callback with selected items
		 * to be returned to pool on selected state change. 
		 * @param	item
		 */
		private function recycle(item:Item):void {
			if (item.selected) {
				item.revive = recycle;
			}
			else {	
				item.revive = null; 
				itemPool.push(item);
			}			
		}
		
		/**
		 * Map item to tag
		 * @param	tag  name of tag
		 * @param	item  item to map
		 */
		private function addTag(tag:String, item:Item):void {
			if (!(tag in tags)) {
				tags[tag] = new Vector.<Item>();
			}
			if(tags[tag].indexOf(item) == -1){
				tags[tag].push(item);
			}
		}
		
		/**
		 * Delete tag mapping
		 * @param	tag
		 */
		private function removeTag(tag:String):void {
			
			//purge results
			for each(var resultTags:Vector.<String> in results) {
				if (resultTags.indexOf(tag) != -1) {
					resultTags.splice(resultTags.indexOf(tag), 1);
				}
			}
			
			delete tags[tag];
		}
		
		/**
		 * Map tags to result to track shared items
		 * @param	tag  tag name
		 * @param	result  item data
		 */
		private function addResult(tag:String, result:ItemData):void {
			if (!(result in results)) {
				results[result] = new Vector.<String>;
			}
			results[result].push(tag);
		}
		
		/**
		 * Remove tag to result mapping. If an existing tag shares a result instance, remap
		 * the corresponding item to the existing tag.
		 * @param	tag
		 * @param	item
		 * @return  true if all result tags are removed, false otherwise
		 */
		private function removeResult(tag:String, item:Item):Boolean {
			
			//remove current result
			var result:ItemData = item.content; 			
			results[result].splice(results[result].indexOf(tag), 1);
			
			//remap item to next result instance
			if (results[result].length) {
				addTag(results[result][0], item);
				return false; 
			}
			//delete results
			else {
				delete results[result];
				return true; 
			}
		}
		
		/**
		 * Identifies whether the result is referenced by an existing tag
		 * @param	result
		 * @return
		 */
		public function duplicateResult(result:ItemData):Boolean { return result in results && results[result].length > 1; }
		
		/****************************DATA****************************/
		
		/**
		 * Load omeka result set
		 * @param	tag  Search tag
		 * @param	results  Corresponding omeka data
		 */
		public function loadResults(tag:String, results:Vector.<ItemData>):void {
			
			loadCount += results.length; 
			
			var item:Item;
			for each(var result:ItemData in results) {
				
				//register result
				addResult(tag, result);
				
				//prevent duplicate items
				if (duplicateResult(result)) {
					loadCount--;
					continue; 
				}
				
				//retrieve available item
				item = nextItem(result);
				
				//load item with result 
				item.addEventListener(StateEvent.CHANGE, loadItem);				
				item.content = result;								
				
				//map item to tags
				addTag(tag, item);
				
				//display item
				belt.addChild(item);
			}
		}
		
		/**
		 * Unload results corresponding to tag
		 * @param	tag
		 */
		public function unloadResults(tag:String):void {
			if (loadCount == 0) {
				
				for each(var item:Item in tags[tag]) {	
					if(removeResult(tag, item)){
						belt.removeChild(item);					
						recycle(item);
					}
				}
				
				removeTag(tag);
				setLayout();
			}
		}		
				
		/****************************DISPLAY****************************/
		
		/**
		 * Update result count display
		 */
		public function displayResultCount():void {
			if(handle.open){
				handle.setLabel("RESULTS  " + belt.numChildren + "  OF  " + totalItems, x + width / 2, .2);
			}
		}
		
		/**
		 * Fades either end of browser indicating the existence of items outside of the render area
		 * accessible by dragging the browser
		 */
		private function get alphaMasking():Boolean { return _alphaMasking; }
		private function set alphaMasking(value:Boolean):void {
			if (value == _alphaMasking) {
				return; 
			}
			_alphaMasking = value; 
			if (_alphaMasking) {
				cacheAsBitmap = alphaMask.cacheAsBitmap = true; 
				rightFade.scaleX = leftFade.scaleX = width / 880;
				rightFade.x = rightMinX = width - rightFade.width;
				leftFade.x = leftMinX = leftFade.width - width;
				
				mask = alphaMask;
				super.addChild(alphaMask);
			}
			else {
				cacheAsBitmap = false; 
				mask = null;
				if (getChildIndex(alphaMask) != -1) {
					removeChild(alphaMask);
				}
			}
		}				
		
		/**
		 * Apply layout after media items are loaded
		 * @param	event
		 */
		protected function loadItem(event:StateEvent):void {
			if (event.property == MediaStatus.LOADED && event.value) {
				event.target.removeEventListener(StateEvent.CHANGE, loadItem);
				loadCount--;
				if (!loadCount) {
					setLayout();
				}
			}
		}		
		
		/**
		 * Internally generate and apply horizontal list layout
		 */
		protected function setLayout():void {
			if(!belt.layout){
				var layout:ListLayout = new ListLayout();
				layout.useMargins = true; 
				layout.marginX = margin; 
				layout.originX = margin / 2; 
				layout.originY = height / 2 - 100;
				layout.onComplete = updateDisplay;	
				belt.layout = layout;  
			}
			if (belt.x) {
				belt.x = 0;
			}
			belt.applyLayout();
			prompt.visible = belt.numChildren == 0; 
			displayResultCount();
		}
		
		/**
		 * Update display settings 
		 */
		protected function updateDisplay():void {						
			
			//dimensions
			width = width ? width : belt.displayWidth;
			height = height ? height : belt.displayHeight;
			
			//limit rendered area
			scrollRect = new Rectangle(0, 0, width, height); 
			
			//translation boundaries
			belt.minX = width - belt.displayWidth - margin;
			belt.maxX = 0; 
			
			//snap destination
			snapLine.x = width / 2;
			
			//drag gesture
			if (belt.maxX > belt.minX) {
				addEventListener(GWGestureEvent.DRAG, scroll); 
				addEventListener(GWGestureEvent.RELEASE, release); 
				alphaMasking = true; 
				snapping = true; 
			}
			else {
				removeEventListener(GWGestureEvent.DRAG, scroll); 
				removeEventListener(GWGestureEvent.RELEASE, release); 				
				alphaMasking = false; 				
				snapping = false; 
			}					
		}
		
		/**
		 * Enables position snapping on release
		 */
		private function get snapping():Boolean { return _snapping; }
		private function set snapping(value:Boolean):void {
			_snapping = value; 
			if (_snapping) {							
				
				//snap positions
				snapPoints.length = 0;
				var item:DisplayObject;
				for (var i:int = 0; i < belt.numChildren; i++) {
					item = belt.getChildAt(i); 
					snapPoints[i] = snapLine.x - item.width / 2 - item.x;
				}		
			}
			else {
				snapPoints.length = 0; 
			}
		}
		
		/**
		 * Layout is generated and applied internally
		 */
		override public function set layout(value:*):void { }
		
		/**
		 * Layout is generated and applied internally
		 */
		override public function applyLayout(value:Layout = null):void { }
		
		/**
		 * Returns true if there is a subsequent category
		 */
		public function next():Boolean { return false; }
		
		/****************************DRAG INTERACTION****************************/		
		
		/**
		 * Prevents x from exceeding or decreasing the anchor value depending on translation direction
		 */
		private function get anchorX():Number { return _anchorX; }
		private function set anchorX(value:Number):void {
			
			//determine snap direction
			if (regulator.x == _anchorX) {
				snapLeft = _anchorX > value;
			}			
			
			//snap left on right drag
			if(snapLeft) {
				regulator.x = _anchorX > value ? value : _anchorX; 
			}			
			//snap right on left drag
			else {
				regulator.x = _anchorX < value ? value :_anchorX; 
			}
		}
		
		/**
		 * Pixel distance to the right or left of the original x the album is permitted to move when boundary
		 * collisions are detected
		 * @default 30
		 */
		public function get tensionDistance():Number { return _tensionDistance; }
		public function set tensionDistance(value:Number):void {
			_tensionDistance = value; 
		}
		
		/**
		 * Tension value based on distance from anchor
		 */
		private function get tension():Number { 
			if (direction == RIGHT) {
				return NumberUtils.instance.map(regulator.x, anchorX, anchorX+tensionDistance, 5, 0); 
			}
			return NumberUtils.instance.map(regulator.x, anchorX-tensionDistance, anchorX, 0, 5); 			
		}	
		
		/**
		 * Translate album items according to drag deltas
		 * @param	event
		 */
		protected function scroll(event:GWGestureEvent):void {

			//calculate drag
			dragDelta = event.value.drag_dy * Math.sin(angle) + event.value.drag_dx * Math.cos(angle);
			
			//bypass 0 deltas
			if (!dragDelta) {
				return; 
			}	
			
			//interrupt tweens
			TweenLite.killTweensOf(belt);
			
			//update current drag direction
			direction = dragDelta > -1 ? RIGHT : LEFT; 
			
			//apply bounded translations to belt
			if (regulator.x == anchorX) {
				belt.x += dragDelta;	
				updateFades();
			}
			
			//boundary collision
			if (!belt.dx) {		
				if (totalPointCount) {  //apply tension to drag
					anchorX = direction == RIGHT ? regulator.x + tension : regulator.x - tension; 
				}
				else {  //if inertia collision, run bounce tween
					stopInertia();
					TweenMax.to(regulator, .1, { x: direction==RIGHT ? anchorX + tensionDistance : anchorX - tensionDistance, yoyo:true, repeat:1 } );
				}
			}
		}
		
		/**
		 * Shift alpha masks relative to belt position
		 */
		private function updateFades():void {
			if (alphaMasking) {
				rightFade.x = NumberUtils.instance.map(belt.x, belt.minX, belt.minX+rightMinX, rightMinX*2, rightMinX);	
				leftFade.x = NumberUtils.instance.map(belt.x, leftMinX, 0, 0, leftMinX);
			}			
		}
		
		/**
		 * Perform hit tests against items to identify which one intersects with the snap line and
		 * returns the child index.
		 */
		private function get snapIndex():int {
			for (var i:int = 0; i < belt.numChildren; i++) {
				if (snapLine.hitTestObject(belt.getChildAt(i))){
					return i; 
				}
			}
			return 0;
		}
		
		/**
		 * Snap to positiont of element at index
		 * @param	value
		 */
		protected function snapToIndex(value:int, tween:Boolean = true):void {
			if (snapping) {
				stopInertia();
				if(tween){
					TweenLite.to(belt, .3, { x:snapPoints[value], ease:Power0.easeNone, onUpdate:updateFades } );
				}
				else {
					belt.x = snapPoints[value];
					updateFades();
				}
			}
		}
		
		/**
		 * Resets the x position to the initial value when album is translated by boundary tension
		 * @param	event
		 */
		protected function release(event:GWGestureEvent):void {
			if (regulator.x != anchorX) {
				stopInertia();
				TweenLite.to(regulator, .2, { x:anchorX } );
			}
		}
		
		/**
		 * Touch event evaluation
		 * @param	event
		 */
		private function onTouch(event:TouchEvent):void {
			if (event.target != this && event.type == TouchEvent.TOUCH_BEGIN) {
				onDown(event);
			}
			else if (event.target != this && event.type == TouchEvent.TOUCH_END) {				
				onUp(event);
			}
			else {
				onOut(event);
			}
		}
		
		/**
		 * Register touch point
		 * @param	event
		 */
		private function onDown(event:TouchEvent):void {
			event.pressure = getTimer();
			points[event.touchPointID] = event; 			
		}
		
		/**
		 * Evaluate tap event and clear touch point
		 * @param	event
		 */
		private function onUp(event:TouchEvent):void {
			if (event.touchPointID in points) {
				if (getTimer() - points[event.touchPointID].pressure <= tapDuration && !event.target.selected) {	//tap event
					event.target.selected = true; 
				}
				delete points[event.touchPointID]; 
			}						
		}
		
		/**
		 * Removes touch point
		 * @param	event
		 */
		protected function onOut(event:TouchEvent):void {
			TouchManager.forceRelease(this);
		}
		
		/****************************SELECTION MANAGEMENT****************************/		
		
		/**
		 * Update bitmap cache
		 */
		protected function recache():void {
			if(alphaMasking){
				cacheAsBitmap = false; 
				cacheAsBitmap = true; 
			}
		}		
	}

}