package display.load 
{
	import com.gestureworks.cml.elements.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Displays load progress and prevents premature interaction
	 * @author Ideum
	 */
	public class LoadScreen extends Sprite
	{
		private var text:Text;		//progress text
		
		/**
		 * Constructor
		 */
		public function LoadScreen() {					
			text = new Text();
			text.autosize = true; 
			text.textAlign = "center";
			text.font = "OpenSansBold";
			text.fontSize = 100;
			text.color = 0xFFFFFF;
			addChild(text);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		/**
		 * Update display
		 * @param	event
		 */
		private function onAdd(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			graphics.beginFill(0);
			graphics.drawRect(0, 0, 3840, 2160);
			text.x = width / 2 - text.displayWidth / 2;
			text.y = height / 2 - text.displayHeight / 2;
		}
		
		/**
		 * Update text with load progress
		 */
		public function set progress(value:int):void {
			text.str = value + "%";
		}
		
		/**
		 * Display URL request error
		 */
		public function set error(value:String):void {
			text.str = value; 
			text.width = width*.75;
			text.wordWrap = true; 
			text.x = 3840 / 2 - text.width / 2;			
		}
		
	}

}