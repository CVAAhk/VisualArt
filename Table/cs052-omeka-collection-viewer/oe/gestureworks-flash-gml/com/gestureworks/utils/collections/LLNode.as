package com.gestureworks.utils.collections {
	
	public class LLNode {
		
		public var next:LLNode;
		public var prev:LLNode;
		public var item:*;
		
		public function LLNode(item:*=null) {
			this.item = item;
		}
		
		public function addBefore(node:LLNode):LLNode {
			next = node;
			prev = node.prev;
			if (prev) {
				prev.next = this;
			}
			if (next) {
				next.prev = this;
			}
			return this;
		}
		
		public function addAfter(node:LLNode):void {
			prev = node;
			next = node.next;
			if (prev) {
				prev.next = this;
			}
			if (next) {
				next.prev = this;
			}
		}
		
		public function remove():LLNode {
			if (next && prev) {
				next.prev = prev;
				prev.next = next;
			}
			next = null;
			prev = null;
			return this;
		}
		
		public function destroy():* {
			remove();
			var t:* = item;
			item = null;
			return t;
		}
		
	}
}