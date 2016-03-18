package display.browser.tags.index 
{
	/**
	 * A simple doubly linked list data structure for tracking @see AlphaNode positions
	 * @author Ideum
	 */
	public class DoublyLinkedList 
	{
		private var count:int; 				//size of list
		private var _head:AlphaNode;		//start of list
		private var _tail:AlphaNode; 		//end of list		
		
		/**
		 * Constructor
		 * @param	nodes Group of nodes to add
		 */
		public function DoublyLinkedList(nodes:Vector.<AlphaNode>):void {
			for each(var node:AlphaNode in nodes) {
				add(node);
			}			
		}

		/**
		 * Add new node to end of list and update links
		 * @param	node
		 * @return
		 */
		public function add(node:AlphaNode):AlphaNode {
			if (!head) {
				head = node;
			}
			else{
				var current:AlphaNode = head; 
				while (current.next) {
					current = current.next; 
				}
				current.next = node; 
				tail = node; 
			}
			count++;
			return node; 
		}
		
		/**
		 * Element at the beginning of the list
		 */
		public function get head():AlphaNode { return _head; }
		public function set head(value:AlphaNode):void {
			if (_head) {
				_head.onUppder = null; 				
			}
			
			_head = value; 
			if (_head) {
				_head.onUppder = headToTail; 
			}
		}
		
		/**
		 * Element at the end of the list
		 */
		public function get tail():AlphaNode { return _tail; }
		public function set tail(value:AlphaNode):void {
			if (_tail) {
				_tail.onLower = null; 				
			}
			
			_tail = value; 
			if (_tail) {
				_tail.onLower = tailToHead;  
			}
		}		
		
		/**
		 * Moves head of list to tail
		 */
		public function headToTail():void {
			tail.next = head; 
			tail = head; 			
			head = tail.next;
			tail.next = head.previous = null;
		}
		
		/**
		 * Moves tail of list to head
		 */
		public function tailToHead():void {	
			tail.next = head; 
			head = tail; 
			tail = tail.previous; 
			tail.next = head.previous = null;
			head.y = head.next.y - head.height;
		}
		
	}

}