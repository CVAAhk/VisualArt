package display.browser.tags.index 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Text;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Continuous scrolling elements of @see AlphaScroller
	 * @author Ideum
	 */
	public class AlphaNode extends Sprite implements SkinElement
	{
		private static var count:int; 				//instance count
		
		private var index:int; 						//index in list
		private var dy:Number = 0;					//translation delta
		private var scroller:AlphaScroller; 		//parent scroller
		
		private var text:Text;						//letter display
		private var defaultFont:Object;				//font propeties of default display
		private var selectedFont:Object;			//font propeties of selected display
			
		private var _defaultState:Sprite;			//state displayed when unselected
		private var _selectedState:Sprite; 			//state displayed when selected		
		private var _previous:AlphaNode; 			//previously linked node
		private var _next:AlphaNode;				//next linked node
		private var _letter:String; 				//letter display
		private var _isSelected:Boolean; 			//flag indicating the node is selected
			
		public var onUppder:Function;				//invoked on upper boundary collision
		public var onLower:Function; 				//invoked on lower boundary collision				
		
		/**
		 * Constructor
		 * @param letter  Character display representing the alpha index
		 * @param scroller  Reference to the parent scroller
		 * @param reset  Resets the counter
		 */
		public function AlphaNode(letter:String, scroller:AlphaScroller, reset:Boolean = false) {				
			this.scroller = scroller; 
			_letter = letter.toUpperCase();	
			mouseChildren = false; 			
			
			if (reset) {
				count = 0; 
			}
			
			index = count;
			text = new Text();
			updateSkin();	
			
			y = index * height; 
			count++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			selectedState = new Sprite();			
			defaultState = new Sprite();								
			initText();			
		}
		
		/**
		 * Default display
		 */
		private function get defaultState():Sprite { return _defaultState; }
		private function set defaultState(value:Sprite):void {
			if (_defaultState) {
				removeChild(_defaultState);
				_defaultState = null; 
			}
			_defaultState = value;
			if (_defaultState) {
				var bm:Bitmap = index % 2 == 0 ? Skin.instance.jumpPrimary : Skin.instance.jumpSecondary;
				defaultFont = bm.metaData;				
				_defaultState.addChild(bm);
				addChildAt(_defaultState, 0);
			}
		}
		
		/**
		 * Selected display
		 */
		private function get selectedState():Sprite { return _selectedState; }
		private function set selectedState(value:Sprite):void {
			if (_selectedState) {
				removeChild(_selectedState);
				_selectedState = null; 
			}
			_selectedState = value;
			if (_selectedState) {
				var bm:Bitmap = Skin.instance.jumpSelect;
				selectedFont = bm.metaData;				
				_selectedState.addChild(bm);
				_selectedState.visible = false; 
				addChildAt(_selectedState, 0);
			}
		}
		
		/**
		 * Configure text display
		 */
		private function initText():void {
			
			text.str = _letter; 
			text.font = defaultFont["font"];
			text.fontSize = defaultFont["fontSize"];
			text.color = defaultFont["fontColor"];
			text.autosize = true; 
			addChild(text);	
			
			text.x = width / 2 - text.displayWidth / 2;
			text.y = height / 2 - text.displayHeight / 2;			
		}
		
		/**
		 * Sets the y coordinate of the node. Also provides the primary vertical translation
		 * and looping mechanism for the alpha scroller. 
		 */
		override public function set y(value:Number):void {
			dy = value - super.y; 
			super.y = value;
			
			//set current node
			isSelected = hitTestObject(scroller.center); 
			
			//propagate translation to next node
			if (next) {
				next.y = value + height; 
			}			
			
			//upper boundary check
			if (onUppder != null && upperBounds()) {
				onUppder.call();
			}			 
			
			//lower boundary check
			else if (onLower != null && lowerBounds()) {
				onLower.call();
			}			
		}
		
		/**
		 * Selected state
		 */
		private function get isSelected():Boolean { return _isSelected; }
		private function set isSelected(value:Boolean):void {
			if (_isSelected == value) {
				return; 
			}
			_isSelected = value;
			if (_isSelected) {
				scroller.current = this; 
			}
		}
		
		/**
		 * Set selected state
		 */
		public function set select(value:Boolean):void {
			_isSelected = value;
			selectedState.visible = _isSelected; 
			if (_isSelected) {
				text.font = selectedFont["font"];
				text.fontSize = selectedFont["fontSize"];
				text.color = selectedFont["fontColor"];
			}
			else {
				text.font = defaultFont["font"];
				text.fontSize = defaultFont["fontSize"];
				text.color = defaultFont["fontColor"];				
			}
		}
		
		/**
		 * Linked node
		 */
		public function get next():AlphaNode { return _next; }
		public function set next(value:AlphaNode):void {
			_next = value; 
			if(_next){
				_next.previous = this; 
			}
		}
		
		/**
		 * Node linking to this node
		 */
		public function get previous():AlphaNode { return _previous; }
		public function set previous(value:AlphaNode):void {
			_previous = value; 
		}
		
		/**
		 * Determines if upper boundary limit is exceeded
		 * @return
		 */
		private function upperBounds():Boolean { return dy < 0 && y < scroller.upperBoundary; }
		
		/**
		 * Determines if lower boundary limit is exceeded
		 * @return
		 */
		private function lowerBounds():Boolean { return dy > 0 && y > scroller.lowerBoundary; }
		
		/**
		 * Letter index
		 */
		public function get letter():String { return _letter; }		
	}

}