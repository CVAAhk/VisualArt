package display.media.back 
{
	import com.gestureworks.cml.elements.Text;
	import display.media.Negator;
	
	/**
	 * Media title container
	 * @author Ideum
	 */
	public class Title extends Negator 
	{		
		private var text:Text;	//text element
		
		/**
		 * Constructor
		 */
		public function Title() {
			text = new Text();
		}						
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				text.autosize = true; 
				text.color = 0xFFFFFF;
				addChild(text);
			}
			super.init();
		}
		
		/**
		 * Text value
		 */
		public function set str(value:String):void {
			text.str = value; 
		}
		
		/**
		 * Update font properties
		 */
		public function set font(value:Object):void {
			text.font = value["font"];
			text.fontSize = value["fontSize"];
			text.color = value["fontColor"];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function negate():void {
			resize();
			reposition();
			super.negate();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			text.wordWrap = false; 
			text.width = 0;
			super.reset();
		}
		
		/**
		 * Restrict display dimensions to title boundaries
		 */
		private function resize():void {
			var w:Number = width * viewer.scale; 
 			if (text.displayWidth > w + 5) {
				text.wordWrap = true; 
				text.width = w; 
			}
			truncate();
		}
		
		/**
		 * Iteratively decrease string until the text height is within bounds
		 */
		private function truncate():void {
			var h:Number = height * viewer.scale;
			while (text.displayHeight > h) {
				text.str = text.str.substr(0, text.str.length - 4).concat("...");
			}
		}
		
		/**
		 * Center the text within the title area
		 */
		private function reposition():void {
			text.x = (width * viewer.scale) / 2 - text.displayWidth / 2;	
			text.y = (height * viewer.scale) / 2 - text.displayHeight / 2; 			
		}
	}

}