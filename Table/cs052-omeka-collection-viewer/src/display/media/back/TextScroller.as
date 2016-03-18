package display.media.back 
{
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.events.GWGestureEvent;
	import display.abstract.Scroller;
	import display.media.OmekaMediaViewer;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	/**
	 * Scrolls info panel text element
	 * @author Ideum
	 */
	public class TextScroller extends Scroller 
	{			
		private var hit:Sprite; 
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				viewer = DisplayUtils.getParentType(OmekaMediaViewer, this);
				viewer.addEventListener(GWGestureEvent.ROTATE, validateTransform);
				hit = new Sprite();
			}
			content = displayByTagName(MetaData) as MetaData; 
			super.init();	
		}		
		
		/**
		 * @inheritDoc
		 */
		override protected function touchTarget(event:TouchEvent):void {
			if (event.target == grabber) {
				viewer.clusterBubbling = false; 
			}
			super.touchTarget(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function scroll(event:GWGestureEvent):void {
			if (target == grabber) {
				super.scroll(event);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set totalPointCount(value:int):void {
			super.totalPointCount = value;
			if (!value) {
				viewer.clusterBubbling = true; 
			}
		}
		
		/**
		 * Update drag angle on viewer rotation
		 * @param	event
		 */
		private function validateTransform(event:GWGestureEvent):void {
			updateDragAngle();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initControl():void {
			
			//scroll track
			track.graphics.clear();
			track.graphics.beginFill(trackColor);
			track.graphics.drawRect(0, 0, 20, height);
			track.graphics.endFill();
			track.x = width - 20;
			addChild(track);			
			
			//scroll control
			var h:Number = NumberUtils.instance.map(content.displayHeight, height, height * 5, height, track.height * .5);			
			grabber.graphics.clear();
			grabber.graphics.beginFill(barColor);
			grabber.graphics.drawRoundRect(5, 0, 10, h, 10, 10);
			grabber.graphics.endFill();
			grabber.minY = 0;
			grabber.maxY = track.height - grabber.height;
			track.addChild(grabber);
			
			//grabber invisible hit area
			hit.graphics.clear();
			hit.graphics.beginFill(0, 0);			
			hit.graphics.drawRect( -20, 0, 40, h);
			hit.graphics.endFill();
			grabber.addChild(hit);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function negate():void {			
			super.negate();
			
			//scroller dimensions
			width = viewer.width * viewer.scale;
			height = parent.height * viewer.scale; 
			
			//decrease render height to prevent menu overlap
			renderHeight -= 55;
			
			//adjust content width to fit within scroller boundaries
			content.width = width * .95;
			
			//update navigation
			setNavigation();			
		}	
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			renderWidth = renderHeight = NaN;
			super.reset();
		}
	}

}