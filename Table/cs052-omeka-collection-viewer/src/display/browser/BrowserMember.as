package display.browser 
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	
	/**
	 * Stores a reference to parent browser
	 * @author Ideum
	 */
	public class BrowserMember extends Container
	{
		public var browser:CollectionBrowser;
		
		override public function init():void {
			super.init();
			browser = DisplayUtils.getParentType(CollectionBrowser, this) as CollectionBrowser;
		}
	}

}