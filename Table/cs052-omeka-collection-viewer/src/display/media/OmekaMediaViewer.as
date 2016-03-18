package display.media 
{
	import com.gestureworks.cml.base.media.MediaStatus;
	import com.gestureworks.cml.components.MediaViewer;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.events.GWGestureEvent;
	import com.greensock.TweenLite;
	import data.ItemData;
	import display.browser.result.Item;
	import display.layout.Projection;
	import display.OmekaCollectionViewer;
	
	/**
	 * Media viewer object dynamically displays omeka content
	 * @author 
	 */
	public class OmekaMediaViewer extends MediaViewer
	{
		private var projectedX:Number; 				//projected x coordinate
		private var projectedY:Number; 				//projected y coordinate
		private var projectedRot:Number; 			//projected rotation
		private var projectedScale:Number; 			//projected scale 
		private var negators:Array;					//child elements to negate initial scale
		
		private var _item:Item;
		private var _activity:Boolean;
		private var _projection:Projection;
		private var _timeout:Number; 
		
		/**
		 * Max display stack index to move to on touch
		 */
		public var topIndex:int; 							
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				negators = DisplayUtils.getAllChildrenByType(this, Negator, true);
				registerGestureHandlers();				
				super.init();
			}
			else{
				super.updateLayout();
			}
		}
		
		/**
		 * Result item containing content data to load viewer with 
		 */
		public function get item():Item { return _item; }
		public function set item(value:Item):void {
			stopActivityTimer();
			super.visible = false; 			
			if (_item) {
				_item.selected = false; 
			}
			_item = value; 
			if (_item) {
				reset();
				_item.row.position(this);
				loadContent(_item.content);
			}
		}
		
		/**
		 * Load content data
		 * @param	content
		 */
		private function loadContent(content:ItemData):void {
			
			//clear dimensions
			width = height = 0; 
			
			//update back; 
			back.content = content; 
			back.thumb = item.bitmap;
			
			//update audio
			front.audio.background = content.display == null; 
			front.audio.backgroundSrc = content.display;
			
			//update front
			front.addEventListener(StateEvent.CHANGE, updateDisplay);
			front.src = content.media;
		}
		
		/**
		 * Update display on media change
		 * @param	event
		 */
		private function updateDisplay(event:StateEvent):void {
			if(event.property == MediaStatus.LOADED && event.value){
				front.removeEventListener(StateEvent.CHANGE, updateDisplay);
				
				//refresh viewer
				init();							
				
				//scale viewer to fit within projected space
				item.row.scale(this);
								
				//ensure specific nested elements have common initial sizes
				negateInternalScale();					
				
				//update active settings
				projectedScale = scale; 
				touchEnabled = true; 
				menu.alpha = 1; 				
				
				//track activity
				startActivityTimer();
				
			}
		}
		
		/**
		 * Initialize specific nested elements to be uniform in size by negating 
		 * viewer's scale
		 */
		private function negateInternalScale():void {
			for each(var negator:Negator in negators) {
				negator.negate();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			touchEnabled = false; 
			scale = 1; 
			for each(var negator:Negator in negators) {
				negator.reset();
			}
			if(menu){
				menu.reset();
			}			
		}
		
		/**
		 * Moves to top of media viewer stack but under browsers
		 */
		private function moveToTop():void {
			parent.addChildAt(this, topIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set visible(value:Boolean):void {
			if (value) { 
				moveToTop();
			}
			else if (item) { //release item
				front.close();
				item = null; 
			}
			super.visible = value;			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set totalPointCount(value:int):void {
			super.totalPointCount = value;
			activity = value != 0;
		}
		
		/**
		 * Track activity and manage reset timer
		 */
		public function get activity():Boolean { return _activity; }
		public function set activity(value:Boolean):void {
			if (_activity == value) {
				return; 
			}
			_activity = value; 
			if (_activity) {
				moveToTop();
				stopActivityTimer();
			}
			else {
				startActivityTimer();
			}
		}
		
		/**
		 * Store projected transform properties
		 */
		public function get projection():Projection { return _projection; }
		public function set projection(value:Projection):void {
			_projection = value; 
			if (_projection) {
				projectedRot = _projection.parent.rotation; 
				projectedX = projectedRot ? _projection.parent.x - _projection.x : _projection.parent.x + _projection.x;
				projectedY = _projection.parent.y + _projection.y;
				syncToProjection();
			}
		}
		
		/**
		 * Transform viewer to projection properties
		 * @param	tween
		 */
		private function syncToProjection(tween:Boolean = false):void {
			if (tween) {
				TweenLite.to(this, .4, { x:projectedX, y:projectedY, rotation:projectedRot, scale:projectedScale } );
			}
			else {
				x = projectedX;
				y = projectedY;
				rotation = projectedRot; 
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set timeout(value:Number):void {
			_timeout = value; 
		}
		
		/**
		 * Call fade out tween on inactivity threshold
		 */
		private function startActivityTimer():void {
			if(_timeout){
				TweenLite.delayedCall(_timeout, startFadeOut);
			}
		}
		
		/**
		 * Reset activity time/tweens on interaction
		 */
		private function stopActivityTimer():void {			
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(startFadeOut);
			alpha = 1; 
		}
		
		/**
		 * Invoke fade out tween
		 */
		private function startFadeOut():void {
			TweenLite.to(this, 5, {alpha:0, onComplete:fadeOutComplete})
		}
		
		/**
		 * Close on fade out
		 */
		private function fadeOutComplete():void {
			visible = false; 
		}
		
		/**
		 * Returns viewer to original position when translated off screen
		 * @param	event
		 */
		private function boundaryCheck(event:GWGestureEvent):void {
			if (!hitTestObject(OmekaCollectionViewer.instance.background)) {
				visible = false; 
			}			
		}
		
		/**
		 * Add gesture event handlers
		 */
		private function registerGestureHandlers():void {
			//nativeTransform = false; 
			addEventListener(GWGestureEvent.COMPLETE, boundaryCheck);
			//addEventListener(GWGestureEvent.DRAG, onGesture);
			//addEventListener(GWGestureEvent.ROTATE, onGesture);
			//addEventListener(GWGestureEvent.SCALE, onGesture);
		}
		
		/**
		 * Gesture event handler
		 * @param	event
		 */
		private function onGesture(event:GWGestureEvent):void {
			if (event.type == GWGestureEvent.DRAG) {
				x += event.value.drag_dx; 
				y += event.value.drag_dy; 
			}
			else if (event.type == GWGestureEvent.ROTATE) {
				rotation += event.value.rotate_dtheta;
			}
			else if (event.type == GWGestureEvent.SCALE) {
				scale += event.value.scale_dsx; 
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set menu(value:*):void {
			if (!initialized && value) {
				value.autoplay = front.autoplay; 
				value.init();
				negators = negators.concat(DisplayUtils.getAllChildrenByType(value, Negator));
			}
			super.menu = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function storeStreamControls():void {
			for (var i:int = 0; i < menu.numChildren; i++) {
				if (streamOps.test(menu.getChildAt(i).operation)) {
					streamControls.push(menu.getChildAt(i));
				}
			}
		}
	}

}