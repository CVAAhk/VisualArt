package display.browser 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Text;
	import com.greensock.TweenLite;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	/**
	 * Browser open and close controls
	 * @author Ideum
	 */
	public class Handle extends Container implements SkinElement
	{
		private const DEFAULT:String = "BROWSER";
		private var mainText:Text;
		private var tagText:Text;
		private var topFont:Object;
		private var sideFont:Object; 
		
		private var _open:Boolean; 
		private var _instructions:Bitmap;
		private var _top:Sprite; 
		private var _left:Sprite; 
		private var _right:Sprite; 
	
		/**
		 * Callback invoked on open state
		 */
		public var onOpen:Function; 
		
		/**
		 * Callback invoked on close state
		 */
		public var onClose:Function; 
		
		/**
		 * Constructor
		 */		
		public function Handle() {
			width = 3840;
			height = 60; 
			mainText = new Text();
			tagText = new Text();			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			updateSkin();
			addEventListener(TouchEvent.TOUCH_BEGIN, trigger);
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			
			top = new Sprite();	
			right = new Sprite();
			left = new Sprite();
			
			tagText.font = topFont["font"];
			tagText.fontSize = topFont["fontSize"];
			tagText.color = topFont["fontColor"];
			tagText.autosize = true; 
			tagText.str = "TAGS";	
			tagText.x = 517.5 - tagText.displayWidth / 2;			
			tagText.y = height / 2 - tagText.displayHeight / 2;	
			tagText.visible = false; 
			top.addChild(tagText);
			
			mainText.font = topFont["font"];
			mainText.fontSize = topFont["fontSize"];
			mainText.color = topFont["fontColor"];
			mainText.autosize = true; 
			top.addChild(mainText);
			
			setLabel(DEFAULT, width / 2);	

			instructions = Skin.instance.instruction;			
		}
		
		/**
		 * Brows instruction text display
		 */
		private function get instructions():Bitmap { return _instructions; }
		private function set instructions(value:Bitmap):void {
			if (_instructions) {
				_instructions.bitmapData.dispose();
				removeChild(_instructions);
				_instructions = null;
			}
			_instructions = value; 
			if (_instructions) {
				_instructions.x = width / 2 - _instructions.width / 2;
				_instructions.y = - _instructions.height - 15; 
				addChild(_instructions);
			}
		}
	
		/**
		 * Top handle 
		 */
		public function get top():Sprite { return _top; }
		public function set top(value:Sprite):void {
			if (_top) {
				removeChild(_top);
				_top = null; 
			}
			_top = value;
			if (_top) {
				var bkg:Bitmap = Skin.instance.handleTop;
				topFont = bkg.metaData; 
				_top.addChild(bkg);
				_top.mouseChildren = false; 				
				addChild(_top);
			}
		}
		
		/**
		 * Right side handle
		 */
		public function get right():Sprite { return _right; }
		public function set right(value:Sprite):void {
			if (_right) {
				removeChild(_right);
				_right = null;
			}
			_right = value; 
			if (_right) {
				
				var bkg:Bitmap = Skin.instance.handleSide;
				sideFont = bkg.metaData; 
				_right.addChild(bkg);
				
				var divider:Bitmap = Skin.instance.divider; 
				divider.x = -divider.width;
				_right.addChild(divider);
				
				_right.addChild(sideText);

				_right.mouseChildren = false; 				
				_right.x = parent.width - _right.width + divider.width; 
				_right.visible = open; 
				addChild(_right);
			}
		}
		
		/**
		 * Left side handle
		 */
		public function get left():Sprite { return _left; }
		public function set left(value:Sprite):void {
			if (_left) {
				removeChild(_left);
				_left = null;
			}
			_left = value; 
			if (_left) {		
				
				var bkg:Bitmap = Skin.instance.handleSide;
				sideFont = bkg.metaData; 
				_left.addChild(bkg);
				
				var divider:Bitmap = Skin.instance.divider; 
				divider.x = bkg.width; 
				_left.addChild(divider);
				
				_left.addChild(sideText);
				
				_left.mouseChildren = false; 
				_left.visible = open; 
				addChild(_left);
			}
		}
		
		/**
		 * Generate side handle text
		 */
		private function get sideText():Text {
			var text:Text = new Text();
			text.font = sideFont["font"];
			text.fontSize = sideFont["fontSize"];
			text.color = sideFont["fontColor"];
			text.autosize = true; 
			text.str = "CLOSE";
			text.rotation = -90;
			text.x = 10;
			text.y = text.displayHeight + 30;
			return text; 
		}
		
		/**
		 * Update open state on touch
		 * @param	event
		 */
		private function trigger(event:TouchEvent):void {
			if (event.target == top) {
				open = true; 
			}
			else if (event.target == left || event.target == right) {
				open = false; 
			}
		}
		
		/**
		 * Open state
		 */
		public function get open():Boolean { return _open; }
		public function set open(value:Boolean):void {
			if (value == _open) {
				return; 
			}
			_open = value; 
			if (_open && onOpen != null) {
				hideSides = false; 
				tagText.visible = true; 
				hideInstructions = true; 
				onOpen.call();
			}
			else if (!_open && onClose != null) {
				onClose.call();
				tagText.visible = false; 
				hideInstructions = false; 
				setLabel(DEFAULT, width / 2);				
			}
		}
		
		/**
		 * Hide instructions on close and display on open 
		 */
		private function set hideInstructions(value:Boolean):void {
			TweenLite.killTweensOf(instructions);
			if (value) {
				instructions.alpha = 0; 				
			}
			else{
				TweenLite.to(instructions, 1, { alpha:1, delay:.4 } );			
			}
		}
		
		/**
		 * Hide side handles
		 */
		public function set hideSides(value:Boolean):void {
			right.visible = left.visible = !value; 			
		}
		
		/**
		 * Alternate main text display between instruction and result info
		 * @param	value
		 * @param	xOffset
		 */
		public function setLabel(value:String, xOffset:Number, delay:Number=NaN):void {
			TweenLite.killTweensOf(mainText);
			mainText.str = value;
			mainText.y = height / 2 - mainText.displayHeight / 2;
			TweenLite.to(mainText, .2, { x:xOffset - mainText.displayWidth / 2, delay:delay } );
		}
	}

}