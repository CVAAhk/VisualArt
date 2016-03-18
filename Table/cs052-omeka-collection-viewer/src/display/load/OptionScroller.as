package display.load 
{
	import com.gestureworks.cml.utils.NumberUtils;
	import display.abstract.Scroller;
	import flash.display.Sprite;
	
	/**
	 * Scroll control on a list of options
	 * @author Ideum
	 */
	public class OptionScroller extends Scroller
	{
		public var list:OptionList;
		private var frame:Sprite; 
		
		/**
		 * Constructor
		 */
		public function OptionScroller() {
			super();
			width = 701;			
			height = 400;			
			list = new OptionList();
			frame = new Sprite();
		}
		
		/**
		 * Assign the options list
		 */
		public function set options(value:Vector.<String>):void {
			init();
			trackColor = 0xCCCCCC;
			barColor = 0x0d0f21;
			list.options = value; 			
			content = list; 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initControl():void {			
			track.graphics.clear();
			track.graphics.lineStyle(4, 0x939598);
			track.graphics.beginFill(trackColor);
			track.graphics.drawRect(0, 0, 40, height - 2);
			track.graphics.endFill();
			track.x = width - track.width;
			addChild(track);			
			
			var h:Number = NumberUtils.instance.map(content.displayHeight, height, height * 5, height, track.height * .5);			
			grabber.graphics.clear();
			grabber.graphics.beginFill(barColor);
			grabber.graphics.drawRect(3, 0, 34, h);
			grabber.graphics.endFill();
			grabber.minY = 0;
			grabber.maxY = track.height - grabber.height;
			track.addChild(grabber);	
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setNavigation():void {
			super.setNavigation();
			var h:Number = displayHeight > height ? height  : displayHeight; 
			frame.graphics.clear();
			frame.graphics.lineStyle(4, 0x939598);
			frame.graphics.drawRoundRectComplex(0, 0, displayWidth, h, 0, 0, 10, 10);
			frame.graphics.endFill();
			addChild(frame);			
		}
	}
}