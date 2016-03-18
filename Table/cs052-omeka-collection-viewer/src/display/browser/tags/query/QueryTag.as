package display.browser.tags.query 
{
	import assets.Skin;
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import display.browser.tags.search.Tag;
	import flash.display.Bitmap;
	
	/**
	 * Displays tag query submissions
	 * @author Ideum
	 */
	public class QueryTag extends Tag
	{					
		private var margin:Number; 	//space between tags
		
		private var _background:Bitmap;		
		private var _removeButton:Bitmap;		
		private var _tag:Tag;
		private var _next:QueryTag;		
		
		/**
		 * Constructor
		 * @param	margin  space between tags in list
		 */
		public function QueryTag(margin:Number = 0):void {
			super();
			this.margin = margin; 
			text.height = 50;
			text.x = 5; 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function init():void {
			super.init();
			updateSkin();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function sizeDisplay():void { }
		
		/**
		 * @inheritDoc
		 */
		override public function updateSkin():void {
			background = Skin.instance.queryAnchor;
			removeButton = Skin.instance.queryClose;
			maxWidth = minWidth =  _background.width - _removeButton.width - 15;			
		}
		
		/**
		 * Background display
		 */
		private function get background():Bitmap { return _background; }
		private function set background(value:Bitmap):void {
			if (_background) {
				_background.bitmapData.dispose();
				removeChild(_background);
				_background = null; 
			}
			_background = value; 
			if (_background) {
				defaultFont = _background.metaData;
				addChildAt(_background, 0);
			}
		}
		
		/**
		 * Update removal button display
		 */
		private function set removeButton(value:Bitmap):void {
			if (_removeButton) {
				_removeButton.bitmapData.dispose();
				removeChild(_removeButton);
				_removeButton = null;
			}
			_removeButton = value; 
			if (_removeButton) {
				_removeButton.x = width - _removeButton.width - 10;
				_removeButton.y = height / 2 - _removeButton.height / 2;
				addChild(_removeButton);
			}
		}
		
		/**
		 * Corresponding search tag
		 */
		public function get tag():Tag { return _tag; }
		public function set tag(value:Tag):void {
			_tag = value; 
			if(_tag){
				label = _tag.label;
				text.y = height / 2 - text.displayHeight / 2;
			}
		}
		
		/**
		 * Reference to next query tag in list
		 */
		override public function set next(value:Tag):void {
			super.next = value;
			x = x; 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void {
			super.x = value;
			if (next) {
				TweenLite.to(next, .4, { x:x + width + margin, ease:Circ.easeOut } );
			}
		}
		
	}

}