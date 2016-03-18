package display.media.menu 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Menu;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.google.maps.controls.ControlPosition;
	import display.abstract.SkinElement;
	import flash.events.TouchEvent;
	
	/**
	 * Cutom menu with optimized, light-weight control elements and dynamic layout capability
	 * @author Ideum
	 */
	public class ControlsMenu extends Menu implements SkinElement
	{		
		private var info:Control;
		private var play:Control;
		private var close:Control;
		private var stateEvent:StateEvent;
		
		public var autoplay:Boolean;
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				
				//register touch event handler
				stateEvent = new StateEvent(StateEvent.CHANGE, this, null, null, true, true);
				addEventListener(TouchEvent.TOUCH_BEGIN, onControl);
				
				//generate viewer controls
				info = new Control(Skin.instance.buttonInfo, "info", Skin.instance.buttonFlip, "info", 45, 10);
				play = new Control(Skin.instance.buttonPlay, "play", Skin.instance.buttonPause, "pause", 0, 10);
				close = new Control(Skin.instance.buttonClose, "close", null, null, -45, 10);
				DisplayUtils.addChildren(this, [info, play, close]);
				
			}
			super.init();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			info.front = Skin.instance.buttonInfo;
			info.back = Skin.instance.buttonFlip;
			play.front = Skin.instance.buttonPlay;
			play.back = Skin.instance.buttonPause;
			close.front = Skin.instance.buttonClose;
		}
		
		//prevent external margin setting
		override public function set margin(value:Number):void { }
		
		/**
		 * Maintain equal distance between controls
		 * @param	containerWidth
		 * @param	containerHeight
		 */
		override public function updateLayout(containerWidth:Number = NaN, containerHeight:Number = NaN):void {
			if (!initialized) {
				return; 
			}
			if (containerWidth) {				
				y = containerHeight;							
				info.x = 0;				
				play.x = containerWidth / 2;								
				close.x = containerWidth;
			}
		}
		
		/**
		 * Dispatch appropriate operation
		 * @param	event
		 */
		private function onControl(event:TouchEvent):void {
			if (event.target == info) {
				stateEvent.value = info.operation; 
				info.toggle();
				dispatchEvent(stateEvent);
			}
			else if (event.target == play) {
				stateEvent.value = play.operation; 
				play.toggle();
				dispatchEvent(stateEvent);
			}
			else if (event.target == close) {
				stateEvent.value = close.operation;
				dispatchEvent(stateEvent);
			}
		}
	
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			alpha = 0;
			if (autoplay && play.operation == "play") {
				play.toggle();
			}
		}
		
	}

}