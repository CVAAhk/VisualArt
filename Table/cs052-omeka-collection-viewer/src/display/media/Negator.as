package display.media
{
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	/**
	 * Negator elements will negate the scale transformation of their parent MediaViewer. Since 
	 * the content of media viewers can differ in size and are scaled down to be within a uniform
	 * initial dimension, the scale of child elements will inherently vary and sometimes be too
	 * small or too big. The intended purpose of this base class is to negate the intial scale 
	 * transform and ensure all sub-classing elements initialize at the same size. 
	 * @author Ideum
	 */
	public class Negator extends TouchContainer
	{
		protected var viewer:OmekaMediaViewer;		//parent viewer
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				viewer = DisplayUtils.getParentType(OmekaMediaViewer, this);
			}
			super.init();
		}
		
		/**
		 * Negates concatenated scale transform
		 */
		public function negate():void {
			scale = 1 / viewer.scale; 
		}
		
		/**
		 * Restore original state
		 */
		public function reset():void {
			scale = 1; 
		}
	}

}