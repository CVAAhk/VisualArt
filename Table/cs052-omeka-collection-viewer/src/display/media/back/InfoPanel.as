package display.media.back 
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import data.ItemData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	/**
	 * Metadata content container
	 * @author Ideum
	 */
	public class InfoPanel extends Container
	{
		private var header:Header;
		private var body:Body
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if(!initialized){
				header = displayByTagName(Header) as Header;
				body = displayByTagName(Body) as Body;				
			}
			super.init();
			body.y = header.height;
			body.height = height - header.height; 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function displayByTagName(value:*):DisplayObject {
			return DisplayUtils.getAllChildrenByType(this, value, true)[0];
		}
		
		/**
		 * Generate thumbnail from provided bitmap
		 * @param	source
		 */
		public function set thumb(source:Bitmap):void {
			header.thumb = source; 
		}
		
		/**
		 * Update display with content data
		 */
		public function set content(value:ItemData):void {
			header.title = value.title;
			body.meta = value;
		}
	}

}