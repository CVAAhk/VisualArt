package display.abstract 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import display.media.Negator;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Scroller extends Negator implements SkinElement
	{
		private var COS:Number; 				//cosine of drag angle
		private var SIN:Number; 				//sine of drag angle
		private var delta:Number; 				//translation delta	
		
		private var _content:TouchContainer;	//scrollable content
		private var _renderWidth:Number;		//width of render area
		private var _renderHeight:Number; 		//height of render area
		
		protected var trackColor:uint; 			//color of the track element
		protected var barColor:uint; 			//color of bar element
		protected var renderArea:TouchSprite; 	//content render area		
		protected var track:TouchSprite;		//scroll bar track
		protected var grabber:TouchSprite;		//scroll controller
		protected var target:Object; 			//current scroll target			
		
		/**
		 * Constructor
		 */
		public function Scroller() {
			
			mouseChildren = true; 
			renderArea = new TouchSprite();
			renderArea.mouseChildren = true; 
			
			//scroll controller
			track = new TouchSprite();			
			track.mouseChildren = true; 
			grabber = new TouchSprite();
			
			//touch targeting
			addEventListener(TouchEvent.TOUCH_BEGIN, touchTarget);				
			
			//scroll gesture settings
			nativeTransform = false; 
			affineTransform = false; 
			gestureList = { "n-drag-inertia":true };
			releaseInertia = true; 			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				updateSkin();
				addChild(renderArea);
			}
			super.init();
			updateDragAngle();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			trackColor = Skin.instance.scrollTrack["color"];
			barColor = Skin.instance.scrollBar["color"];
		}
		
		/**
		 * Scrollable content container
		 */
		public function get content():TouchContainer { return _content; }
		public function set content(value:TouchContainer):void {
			_content = value; 
			if (_content.parent != renderArea) {
				renderArea.addChild(_content);
			}
			setNavigation();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void {
			super.width = value;
			if (!renderWidth) {
				renderWidth = value; 
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void {
			super.height = value;
			if (!renderHeight) {
				renderHeight = value; 
			}
		}
		
		/**
		 * Width of content's viewable area
		 */
		public function get renderWidth():Number { return _renderWidth; }
		public function set renderWidth(value:Number):void {
			_renderWidth = value; 
			renderArea.scrollRect = new Rectangle(0, 0, _renderWidth, _renderHeight);
		}
		
		/**
		 * Height of content's viewable area
		 */
		public function get renderHeight():Number { return _renderHeight; }
		public function set renderHeight(value:Number):void {
			_renderHeight = value; 
			renderArea.scrollRect = new Rectangle(0, 0, _renderWidth, _renderHeight);
		}
		
		/**
		 * Initialize scroll bar elements
		 */
		protected function initControl():void {
			
			track.graphics.clear();
			track.graphics.beginFill(trackColor);
			track.graphics.drawRect(0, 0, 20, height);
			track.graphics.endFill();
			track.x = width - track.width;
			addChild(track);			
			
			var h:Number = NumberUtils.instance.map(content.displayHeight, height, height * 5, height, track.height * .5);			
			grabber.graphics.clear();
			grabber.graphics.beginFill(barColor);
			grabber.graphics.drawRoundRect(5, 0, 10, h, 10, 10);
			grabber.graphics.endFill();
			grabber.minY = 0;
			grabber.maxY = track.height - grabber.height;
			track.addChild(grabber);						
		}	
		
		/**
		 * Updates angle applied in drag translations based on current rotation
		 */
		public function updateDragAngle():void {
			var angle:Number = DisplayUtils.rotationFromMatrix(transform.concatenatedMatrix);
			COS = Math.cos(angle);
			SIN = Math.sin(angle);			
		}
		
		/**
		 * Determines the scroll control target
		 * @param	event
		 */
		protected function touchTarget(event:TouchEvent):void {
			target = event.target;
		}		
		
		/**
		 * Vertically translate content based on drag gesture deltas
		 * @param	event
		 */		
		protected function scroll(event:GWGestureEvent):void {
			delta = event.value.drag_dy * COS - event.value.drag_dx * SIN;			
			if (target == grabber) {
				grabber.y += delta; 
				syncContentWithGrabber();
			}
			else {
				target = content; 
				content.y += delta; 
				syncGrabberWithContent();
			}
		}
		
		/**
		 * Updates content position relative to grabber position
		 */
		protected function syncContentWithGrabber():void {
			content.y = NumberUtils.instance.map(grabber.y, grabber.minY, grabber.maxY, content.maxY, content.minY);				
		}
		
		/**
		 * Updates grabber position relative to content position
		 */
		protected function syncGrabberWithContent():void {
			grabber.y  = NumberUtils.instance.map(content.y, content.minY, content.maxY, grabber.maxY, grabber.minY);
		}	
		
		/**
		 * Set navigation settings based on content dimensions
		 */
		protected function setNavigation():void {			
			if (content.displayHeight > height) {
				
				//translation boundaries
				content.minY = height-content.displayHeight;
				content.maxY = 0;
				
				//update sroll bar control
				initControl();
				
				//enable drag
				track.visible = true; 				
				addEventListener(GWGestureEvent.DRAG, scroll);
			}
			else {				
				//disable drag
				track.visible = false; 				
				removeEventListener(GWGestureEvent.DRAG, scroll);
			}			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			if(grabber){
				grabber.y = 0;
			}
			if(content){
				content.y = 0; 
			}
			super.reset();
		}
	}

}