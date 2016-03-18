package display.browser.tags.search 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.utils.DisplayUtils;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author Ideum
	 */
	public class Tag extends Sprite implements SkinElement
	{
		private const ELLIPSIS:String = "...";			//string appended to truncated values
		private var isLetter:RegExp = /[A-Za-z]/;		//letter filter		
		protected var defaultFont:Object;				//text font properties on default state
		private var selectedFont:Object;				//text font properties on selected state
		
		private var _defaultState:Bitmap;				//display on default state
		private var _selectedState:Bitmap; 				//display on selected state		
		private var _selected:Boolean; 					//selected state		
		private var _fullText:String; 					//stores full text value 
		private var _next:Tag;							//next tag in list
		private var _previous:Tag;						//previous tag in list
		private var _alphaIndex:String;					//letter representation
		
		protected var text:Text;						//text element
				
		/**
		 * Lower width boundary
		 */
		public var minWidth:Number;
		
		/**
		 * Upper width boundary
		 */
		public var maxWidth:Number;
		
		/**
		 * Constructor
		 * @param	name
		 */
		public function Tag() {
			mouseChildren = false; 	
			text = addChild(new Text()) as Text;	
		}
		
		/**
		 * Update display
		 */
		protected function init():void {
			updateSkin();
			updateFont();
			minWidth = 220;
			maxWidth = 700;				
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			text.autosize = true; 
			selectedState = Skin.instance.tagSelect;			
			defaultState = Skin.instance.tagDefault;						
		}
		
		/**
		 * Set default state display
		 */
		private function set defaultState(value:Bitmap):void {
			if (_defaultState) {
				_defaultState.bitmapData.dispose();
				removeChild(_defaultState);
				_defaultState = null;
			}
			_defaultState = value; 
			if (_defaultState) {
				addChildAt(_defaultState, 0);
				defaultFont = _defaultState.metaData;
			}
		}		
		
		/**
		 * Set selected state display
		 */
		private function set selectedState(value:Bitmap):void {
			if (_selectedState) {
				_selectedState.bitmapData.dispose();
				removeChild(_selectedState);
				_selectedState = null;
			}
			_selectedState = value; 
			if (_selectedState) {
				addChildAt(_selectedState, 0);
				selectedFont = _selectedState.metaData;
				_selectedState.visible = false;				
			}
		}
		
		/**
		 * Reference to next tag in linked list
		 */
		public function get next():Tag { return _next; }
		public function set next(value:Tag):void {
			_next = value; 
		}
		
		/**
		 * Reference to previous tag in linked list
		 */
		public function get previous():Tag { return _previous; }
		public function set previous(value:Tag):void {
			_previous = value; 
		}
		
		/**
		 * Display text
		 */
		public function get label():String { return text.str; }
		public function set label(value:String):void {
			init();
			fullText = value; 
		}
		
		/**
		 * Stores the full text value independent of display and adjusts display
		 * text to meet the size boudaries. 
		 */
		public function get fullText():String { return _fullText; }
		public function set fullText(value:String):void {
			_fullText = value; 
			text.str = _fullText;
			//fix width to max and truncate display
			if (lineWidth > maxWidth) {
				text.autosize = false; 
				truncate();
			}
			//fix to min width
			else if(lineWidth < minWidth) {
				text.autosize = false; 
				text.width = minWidth;
			}
			//dynamically resize depending on text
			else {
				text.autosize = true; 
				text.width = text.displayWidth;
			}
			sizeDisplay();
		}
		
		/**
		 * Size and add backgroun display
		 */
		protected function sizeDisplay():void {
			if (_defaultState) {		
				
				//scale state display
				_defaultState.scaleX = (text.width + 5) / maxWidth;		
				_selectedState.scaleX = _defaultState.scaleX;
				
				//center text on display
				text.x = _defaultState.width / 2 - text.displayWidth / 2;			
				text.y = _defaultState.height / 2 - text.displayHeight / 2;										
				
				//tag hit area
				graphics.clear();
				graphics.beginFill(0, 0);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
				
				text.init();
			}			
		}
		
		/**
		 * Iteratively remove tail characters until the width is within max boundary 
		 * and append ellipses to indication truncation
		 */
		private function truncate():void {
			while (lineWidth > maxWidth - 5) {
				text.str = text.str.substr(0, text.str.length - 4).concat(ELLIPSIS);
			}			
			text.width = maxWidth; 			
		}
		
		/**
		 * Width of line metrics
		 */
		private function get lineWidth():Number { return text.getLineMetrics(0).width; }
		
		/**
		 * Starting text character
		 */
		public function get alphaIndex():String { 
			if (text) {
				var first:String = text.str.charAt(0);
				if (isLetter.test(first)) {
					_alphaIndex = first.toUpperCase();
				}
				else if (!(isNaN(Number(first)))) {
					_alphaIndex = "123";
				}
				else {
					_alphaIndex = "MISC.";
				}
			}
			return _alphaIndex;
		}
		
		/**
		 * Flag indicating the selected state of the tag
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value; 
			_selectedState.visible = value; 
			updateFont();
		}
		
		/**
		 * Set font properties
		 */
		protected function updateFont():void {
			text.font = _selected ? selectedFont["font"] : defaultFont["font"];
			text.fontSize = _selected ? selectedFont["fontSize"] : defaultFont["fontSize"];
			text.color = _selected ? selectedFont["fontColor"] : defaultFont["fontColor"];
		}
	}

}