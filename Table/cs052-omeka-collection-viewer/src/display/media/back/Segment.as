package display.media.back 
{
	import com.gestureworks.cml.elements.TouchContainer;
	
	/**
	 * Separates back info panel content
	 * @author Ideum
	 */
	public class Segment extends TouchContainer
	{
		protected var color:uint; 
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void {
			super.width = value;
			draw();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void {
			super.height = value;
			draw();
		}				
		
		/**
		 * Update graphics
		 */
		private function draw():void {
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}

}