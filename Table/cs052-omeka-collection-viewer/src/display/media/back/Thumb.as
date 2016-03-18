package display.media.back 
{
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.DisplayUtils;
	import flash.display.Bitmap;
	
	/**
	 * Info panel thumbnail preview of front media content
	 * @author Ideum
	 */
	public class Thumb extends TouchContainer 
	{
		private var _bitmap:Bitmap; 	//display
		private var s:Number; 			//resample scale
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			super.init();
			if(width && height){
				resize();
				reposition();
			}
		}
		
		//prevent external positioning
		override public function set x(value:Number):void { }
		override public function set y(value:Number):void { }
		
		/**
		 * Omeka thumbnail display
		 */
		public function set source(value:Bitmap):void {
			bitmap = new Bitmap(value.bitmapData.clone());
		}
		
		/**
		 * Size bitmap relative to thumb dimensions
		 */
		private function resize():void {			
			if (!bitmap) {
				return; 
			}
			if (bitmap.height > height) {
				s = height / bitmap.height; 
				bitmap.width *= s; 
				bitmap.height *= s; 
			}
			if (bitmap.width > width) {
				s = width / bitmap.width; 
				bitmap.width *= s; 
				bitmap.height *= s; 
			}			
		}
		
		/**
		 * Set position to the right side of the header
		 */
		private function reposition():void {
			super.y = parent.height / 2 - bitmap.height / 2;
			super.x = parent.width - bitmap.width - super.y;
		}
		
		/**
		 * Bitmap display
		 */
		private function get bitmap():Bitmap { return _bitmap; }
		private function set bitmap(value:Bitmap):void {
			if (_bitmap) {
				removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null; 
			}
			_bitmap = value; 
			if (_bitmap) {
				addChild(_bitmap);				
			}
		}			
	}

}