package com.gestureworks.utils.collections {
	/**
	 * ...
	 * @author Ideum
	 */
	public class LinkedList {
		
		private var head:LLNode;
		private var tail:LLNode;
		
		private var _length:int;
		
		public function LinkedList() {
			head = new LLNode();
			tail = new LLNode();
			head.next = tail;
			tail.prev = head;
			_length = 0;
		}
		
		/**
		 * Adds an item to the end of the list
		 * @param	item
		 */
		public function push(item:*):void {
			_length++;
			new LLNode(item).addBefore(tail);
		}
		
		/**
		 * adds an existing node to the end of the list
		 * @param	node
		 */
		public function pushNode(node:LLNode):LLNode {
			_length++;
			node.addBefore(tail);
			return node;
		}
		
		/**
		 * removes an item from the end of the list
		 * @return
		 */
		public function pop():* {
			if (_length > 0) {
				_length--;
				return tail.prev.destroy();
			}
			return null;
		}
		
		/**
		 * removes a node from the end of the list
		 * @return
		 */
		public function popNode():LLNode {
			if (_length > 0) {
				_length--;
				return tail.next.remove();
			}
			return null;
		}
		
		/**
		 * removes an item from the front of the list
		 * @return
		 */
		public function shift():* {
			if (_length > 0) {
				_length--;
				return head.next.destroy();
			}
			return null;
		}
		
		/**
		 * removes a node from the front of the list
		 * @return
		 */
		public function shiftNode():LLNode {
			if (_length > 0) {
				_length--;
				return head.next.remove();
			}
			return null;
		}
		
		/**
		 * adds an item to the front of the list
		 * @param	item
		 */
		public function unshift(item:*):void {
			_length++;
			new LLNode(item).addAfter(head);
		}
		
		/**
		 * adds a node to the front of the list
		 * @param	node
		 */
		public function unshiftNode(node:LLNode):LLNode {
			_length++;
			node.addAfter(head);
			return node;
		}
		
		/**
		 * removes an item from the front of the list and adds it to the back
		 * @return
		 */
		public function cycle():* {
			var n:LLNode = cycleNode();
			return n? n.item : null;
			
		}
		
		/**
		 * removes a node from the front of the list and adds it to the back
		 * @return
		 */
		public function cycleNode():LLNode {
			if (_length > 0) {
				return pushNode(shiftNode());
			}
			return null;
		}
		
		public function shrinkBy(num:int):void {
			var node:LLNode = lastNode;
			while (_length > 0 && num > 0 && node) {
				num--;
				node.destroy();
				node = lastNode;
			}
		}
		
		/**
		 * the number of items in the list
		 */
		public function get length():int {
			return _length;
		}
		
		/**
		 * first node in the list
		 */
		public function get firstNode():LLNode {
			if (_length > 0) {
				return head.next;
			}
			return null;
		}
		
		/**
		 * last node in the list
		 */
		public function get lastNode():LLNode {
			if (_length > 0) {
				return tail.prev;
			}
			return null;
		}
	}
}