package display.attract 
{
	import com.gestureworks.cml.elements.Video;
	/**
	 * ...
	 * @author Ideum
	 */
	public class AttractVideo extends Video
	{
		
		public function AttractVideo() {
			super();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, 3840, 2160);
			graphics.endFill();
		}
		
	}

}