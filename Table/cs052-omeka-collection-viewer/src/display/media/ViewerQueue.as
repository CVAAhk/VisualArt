package display.media 
{
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.managers.ResourceManager;
	/**
	 * ...
	 * @author Ideum
	 */
	public class ViewerQueue extends ResourceManager
	{
		/**
		 * Restore initial invisible state of resources
		 */
		public function reset():void {
			var res:Vector.<TouchContainer> = _resources[OmekaMediaViewer];
			for (var i:int = res.length - 1; i >= 0; i--) {
				if (res[i].visible) {
					res[i].removeEventListener(StateEvent.CHANGE, reorder);
					res[i].visible = false; 
					res[i].addEventListener(StateEvent.CHANGE, reorder);
				}
			}
		}
	}

}