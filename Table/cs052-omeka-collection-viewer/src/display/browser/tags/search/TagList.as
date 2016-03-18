package display.browser.tags.search 
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * Tag container
	 * @author Ideum
	 */
	public class TagList extends Container
	{
		private var head:Tag;						//first element in list
		private var sections:Array;					//sorted array of registered alpha sections
		private var alphaSections:Dictionary;		//tracks locations of the first tag in each alphabetical section
		private var tags:Array;						//store tags for reuse
		private var index:int; 						//tag access index
		
		/**
		 * Spacing between tags
		 */
		public var margin:Number = 20; 
		
		/**
		 * Function invoked on layout complete
		 */
		public var layoutComplete:Function; 
		
		/**
		 * Constructor
		 */
		public function TagList() {
			visible = false; 
			width = 732;
			alphaSections = new Dictionary(true);
			sections = [];	
		}
		
		//prevent external child addition
		override public function addChild(child:DisplayObject):DisplayObject { return child; }	
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { return child; }
		
		/**
		 * Generates tags based on provided name array, and links each tag in the list
		 */
		public function set tagNames(values:Vector.<String>):void {
						
			//validity check
			if (!values || values.length == 0) {
				return; 
			}
			
			//reset list
			clearTags();
			
			values.sort(Array.CASEINSENSITIVE);
			var tag:Tag;
			var previous:Tag; 
			
			//generate and link tags
			for each(var value:String in values) {
				tag = getTag();
				tag.label = value; 
				if (!head) {
					head = tag; 
				}
				else {
					previous.next = tag; 
					tag.previous = previous; 
				}
				previous = tag; 
				super.addChild(tag);
			}
			
			//apply layout
			updateLayout();
		}
		
		/**
		 * Return next available tag
		 * @return
		 */
		private function getTag():Tag {
			var tag:Tag;
			if (index < tags.length) {
				tag = tags[index];
				tag.x = tag.y = 0;
				tag.next = tag.previous = null; 
				index++;
			}
			else {
				tag = new Tag();
			}
			return tag; 
		}
		
		/**
		 * Clear list and store generated tags for reuse
		 */
		private function clearTags():void {
			index = 0; 
			head = null; 
			alphaSections = new Dictionary();
			sections.length = 0; 
			tags = DisplayUtils.removeAllChildrenByType(this, [Tag]);
		}
		
		/**
		 * Apply tag layout
		 */
		private function updateLayout():void {
			var tag:Tag = head; 
			tag.y = margin;
			alphaSections[tag.alphaIndex] = tag.y - margin; 
			sections.push(tag.alphaIndex);
			
			//apply layout
			while (tag.next) {
				
				//horizontal spacing
				tag.next.x = tag.x + tag.width + margin; 
				tag.next.y = tag.y; 
				
				//tag wrap
				if (displayWidth > width) {
					wrap(tag);
				}
				
				//store alpha specific location
				if (tag.alphaIndex != tag.next.alphaIndex) {
					wrap(tag);
					alphaSections[tag.next.alphaIndex] = margin - tag.next.y; 
					sections.push(tag.next.alphaIndex);
				}
				
				//update tag
				tag = tag.next; 
			}
			
			//center bottom row
			centerRow(tag);
			
			//touch area
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width, displayHeight + margin * 2);				
			
			//display
			visible = true; 
			
			//invoke callback
			if (layoutComplete != null) {
				layoutComplete.call();
			}
		}
		
		/**
		 * When tags exceeed list boundary, go to next row
		 * @param	tag
		 */
		private function wrap(tag:Tag):void {
			centerRow(tag);
			tag.next.x = 0;
			tag.next.y = tag.y + tag.height + margin; 
		}
		
		/**
		 * Center tags in current row
		 * @param	tag  last tag in row
		 */
		private function centerRow(tag:Tag):void {
			
			var prior:Number = tag.y; 
			var w:Number = tag.width; 
			var row:Array = [tag];
			
			//collect row members
			while (tag.previous) {
				if (tag.previous.y == prior) { //identify row
					w += tag.previous.width + margin;
					row.push(tag.previous);
				}
				else {
					break;
				}
				tag = tag.previous; 
			}
			
			//center tags
			var xval:Number = width / 2 - w / 2;
			for each(var t:Tag in row) {
				t.x = xval;
				xval = t.x + t.width + margin; 
			}
		}
		
		/**
		 * Return position of alpha-specific section
		 * @param	letter
		 * @return
		 */
		public function alphaPosition(letter:String):Number {
			if (letter in alphaSections) {
				return alphaSections[letter]; 
			}
			return NaN;
		}
		
		/**
		 * Return current alpha section
		 */
		public function get section():String {		
			if (sections.length == 0) {
				return null; 
			}
			if(sections.length > 1) {
				for (var i:int = 1; i < sections.length; i++) {
					if (y > alphaSections[sections[i]] && y <= alphaSections[sections[i - 1]]) {
						return sections[i-1];
					}
				}
			}
			return sections[sections.length-1];
		}
	}

}