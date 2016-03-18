package display.browser.tags.query 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Container;
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import display.abstract.SkinElement;
	import display.browser.tags.search.Tag;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	
	/**
	 * Manages tag selection and corresponding submissions
	 * @author Ideum
	 */
	public class QueryController extends Container implements SkinElement
	{
		private var tags:Vector.<QueryTag>; 	 //query tag pool
		private var current:QueryTag;			 //reference to current tag
		private var head:QueryTag;				 //head of tag list
		
		private var _background:Bitmap;
		
		public var margin:Number = 20;			 //space between tags in list
		public var onRemove:Function; 			 //invoked on tag remove
		
		/**
		 * Constructor
		 */
		public function QueryController() {
			width = 752; 
			height = 90; 
			
			updateSkin();
			
			tags = new Vector.<QueryTag>();
			for (var i:int = 0; i < 3; i++) {
				tags.push(new QueryTag(margin));
				tags[i].y = height / 2 - tags[i].height / 2; 
			}
			
			addEventListener(TouchEvent.TOUCH_BEGIN, removeCurrent);
		}
		
		//prevent external addition of children
		override public function addChild(child:DisplayObject):DisplayObject { return child; }
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { return child; }
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			background = Skin.instance.queryBackground;
		}
		
		/**
		 * Background display
		 */
		private function get background():Bitmap { return _background; }
		private function set background(value:Bitmap):void {
			if (_background) {
				_background.bitmapData.dispose();
				super.removeChild(_background);
				_background = null; 
			}
			_background = value; 
			if (_background) {
				super.addChildAt(_background, 0);
			}
		}
		
		/**
		 * Add a tag to query list
		 * @param	tag
		 */
		public function addTag(tag:Tag):void {
			if (occupied) {
				return; 
			}
			
			current = tags.shift();
			current.tag = tag; 	
			
			if (!head) {
				head = current;
				head.x = margin; 
			}
			else {
				appendNode(current);
			}
			
			super.addChild(current);			
		}
		
		/**
		 * Remove tag from query list
		 * @param	value
		 */
		private function removeTag(value:QueryTag):void {
			super.removeChild(value);
			tags.push(value);
			removeNode(value);
			value.tag.selected = false; 
			if (onRemove != null) {
				onRemove.call(null, current.tag);
			}
			current.tag = null;				
		}
		
		/**
		 * Remove selected tag from query list
		 * @param	event
		 */
		private function removeCurrent(event:TouchEvent):void {
			if (!(event.target is QueryTag)) {
				return; 
			}
			current = event.target as QueryTag;
			removeTag(current);  					
		}
		
		/**
		 * Add new node and assign links to sibling queries
		 * @param	tag
		 */
		private function appendNode(tag:QueryTag):void {
			var node:QueryTag = head; 
			while (node.next) {
				node = node.next as QueryTag; 
			}
			node.next = tag; 			
		}
		
		/**
		 * Remove node from linked list
		 * @param	tag
		 */
		private function removeNode(tag:QueryTag):void {
			if (tag == head) {
				if (head.next) {
					TweenLite.to(head.next, .4, { x:head.x, ease:Circ.easeOut } );
				}
				head = head.next as QueryTag; 
				tag.next = null; 
			}
			else {
				var node:QueryTag = head; 
				while (node.next) {
					if (node.next == tag) {
						node.next = node.next.next; 
						node.x = node.x; 
						tag.next = null; 
						return; 
					}
					node = node.next as QueryTag; 
				}
			}			
		}
		
		/**
		 * Flag indicating the query list is full
		 */
		public function get occupied():Boolean { return numChildren > 3; }
		
		/**
		 * Remove all tags
		 */
		public function clear():void {
			for (var i:int = numChildren-1; i > 0; i--) {
				current = getChildAt(i) as QueryTag; 
				removeTag(current);
			}
			current = null; 
		}
		
	}

}