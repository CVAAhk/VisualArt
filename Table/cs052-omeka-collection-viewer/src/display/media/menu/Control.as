package display.media.menu 
{
	import display.media.Negator;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Control extends Negator 
	{
		private var frontOp:String; 
		private var backOp:String; 		
		private var offsetX:Number; 
		private var offsetY:Number; 		
		
		private var _front:Bitmap;
		private var _back:Bitmap;		
		private var _operation:String; 
		
		/**
		 * Media control element mapping operations with display states
		 * @param	front
		 * @param	frontOp
		 * @param	back
		 * @param	backOp
		 */
		public function Control(front:Bitmap, frontOp:String, back:Bitmap = null, backOp:String = null, offsetX:Number = 0, offsetY:Number = 0 ) {
			this.front = front; 
			this.frontOp = frontOp; 
			this.back = back; 
			this.backOp = backOp;
			this.offsetX = offsetX; 
			this.offsetY = offsetY; 
			
			_operation = frontOp; 
			
			addEventListener(Event.ADDED_TO_STAGE, function onAdd(event:Event):void {
				removeEventListener(Event.ADDED_TO_STAGE, onAdd);
				init();
			});
		}
		
		/**
		 * Front display
		 */
		public function get front():Bitmap { return _front; }
		public function set front(value:Bitmap):void {
			if (_front) {
				_front.bitmapData.dispose();
				removeChild(_front);
				_front = null; 
			}
			_front = value; 
			if (_front) {
				_front.smoothing = true; 
				_front.x = -_front.width / 2;
				_front.y = -_front.height / 2;
				addChild(_front);
			}
		}
		
		/**
		 * Back display
		 */
		public function get back():Bitmap { return _back; }
		public function set back(value:Bitmap):void {
			if (_back) {
				_back.bitmapData.dispose();
				removeChild(_back);
				_back = null; 
			}
			_back = value; 
			if (_back) {
				_back.smoothing = true; 
				_back.x = -_back.width / 2;
				_back.y = -_back.height / 2;
				_back.visible = false; 
				addChild(_back);
			}
		}
		
		/**
		 * The media viewer operation corresponding to the current side
		 */
		public function get operation():String { return _operation; }
		
		/**
		 * Toggle between front and back displays/operations
		 */
		public function toggle():void {
			if(back){
				front.visible = !front.visible;
				back.visible = !front.visible; 
				_operation = front.visible ? frontOp : backOp;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function negate():void {
			super.negate();
			x += (offsetX * scale);
			y = -displayHeight / 2 - (offsetY * scale);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void {
			super.reset();
			if (back) {
				front.visible = false; 
				toggle();
			}			
		}
		
	}

}