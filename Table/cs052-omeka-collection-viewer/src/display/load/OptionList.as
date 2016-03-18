package display.load 
{
	import com.gestureworks.cml.elements.Container;
	/**
	 * ...
	 * @author Ideum
	 */
	public class OptionList extends Container
	{		
		/**
		 * Consume option values and list display
		 */
		public function set options(values:Vector.<String>):void {
			
			var option:Option;
			var yVal:Number = 0;
			
			for each(var value:String in values) {
				option = addChild(new Option(value)) as Option;
				option.y = yVal;
				yVal = option.y + option.height; 
			}
			
			graphics.clear();
			graphics.beginFill(0xa7a9ac);
			graphics.drawRect(0, 0, displayWidth, displayHeight);
			graphics.endFill();
		}
	}

}