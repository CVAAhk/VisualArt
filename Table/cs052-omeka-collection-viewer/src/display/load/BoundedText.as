package display.load 
{
	import com.gestureworks.cml.elements.Text;
	/**
	 * ...
	 * @author Ideum
	 */
	public class BoundedText extends Text
	{		
		private var _fullText:String; 
		
		/**
		 * Constructor
		 */
		public function BoundedText() {
			mouseChildren = false; 
			width = 580;
			font = "RobotoLight";
			fontSize = 36;
			color = 0x6d6e71;
			autosize = true; 
			multiline = wordWrap = false;
		}
		
		//prevent external assignment of required settings
		override public function set multiline(value:Boolean):void { }
		override public function set wordWrap(value:Boolean):void { }		
		override public function set autosize(value:Boolean):void { }
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void {
			fullText = value; 
		}
		
		/**
		 * Store full text and bound display width
		 */
		public function get fullText():String { return _fullText; }
		public function set fullText(value:String):void {
			_fullText = value; 
			super.text = _fullText; 
			truncate();
		}	
		
		/**
		 * Iteratively reduce string until it is within bounds
		 */
		private function truncate():void {
			while (lineWidth > width) {
				super.text = text.substr(0, text.length - 4).concat("...");
			}
		}
		
		/**
		 * Line width
		 */
		private function get lineWidth():Number { return getLineMetrics(0).width };
	}
}