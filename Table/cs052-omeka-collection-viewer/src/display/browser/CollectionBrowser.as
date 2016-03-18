package display.browser 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import data.OmekaClient;
	import display.abstract.SkinElement;
	import display.browser.result.ResultSetNavigator;
	import display.browser.tags.search.Tag;
	import display.browser.tags.TagSearch;
	import display.layout.Row;
	import flash.display.Bitmap;
	
	/**
	 * Contains browsing controls and result set display
	 * @author Ideum
	 */
	public class CollectionBrowser extends Container implements SkinElement
	{		
		private static var count:int; 
		private var primary:Boolean;					//dock the browser to the bottom when true and to the top otherwise
		private var tween:TweenLite; 		
		private var search:TagSearch;
		private var results:ResultSetNavigator; 
				
		private var _divider:Bitmap;
		private var _resultSetBkg:Bitmap;		
		private var _handle:Handle;		
		
		/**
		 * Reference to corresponding media layout row
		 */
		public var row:Row;
		
		/**
		 * Constructor
		 */
		public function CollectionBrowser() {
			width = 3840;
			height = 400;
			search = new TagSearch();
			results = new ResultSetNavigator();
			primary = !count; 
			count++;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			setHandle();			
			orient();	
			
			DisplayUtils.addChildren(this, [search, results]);		
			
			search.x = _handle.left.width;
			search.y = _handle.height;
			search.onSelect = tagSelect;
			search.onUnselect = tagUnselect; 			
			search.init();	
			
			results.x = search.x + search.displayWidth + 2;
			results.y = search.y; 	
			results.init();			
			
			updateSkin();	
			closed();
		}	
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {		
			if (_handle.open) {
				_handle.open = false; 
			}
			divider = Skin.instance.divider;
			divider.visible = _handle.open;
			resultSetBkg = Skin.instance.resultSetBackground;
		}
		
		/**
		 * Depending on primary flag, dock to botton or top of viewer. 
		 */
		private function orient():void {
			if (primary) { //dock to bottom
				y = parent.height - handle.top.height;
				tween = new TweenLite(this, .3, { y: parent.height - height, paused:true, ease:Expo.easeOut, onReverseComplete:closed } );
			}
			else { //dock to top
				y = height - handle.top.height;
				DisplayUtils.rotateAroundPoint(this, 180, displayWidth / 2, height / 2);
				tween = new TweenLite(this, .3, { y: height, paused:true, ease:Expo.easeOut, onReverseComplete:closed } );
			}
		}
		
		/**
		 * Search for CML handle and, if not provided, generate default
		 */
		private function setHandle():void {
			if (!handle)
				handle = displayByTagName(Handle);
			if (!handle) {
				handle = new Handle();
				addChild(handle);
				handle.init();
			}
			handle.onOpen = open; 
			handle.onClose = close; 
		}
		
		/**
		 * Divider graphic
		 */
		private function get divider():Bitmap { return _divider; }
		private function set divider(value:Bitmap):void {
			if (_divider) {
				_divider.bitmapData.dispose();
				removeChild(_divider);
				_divider = null;
			}
			_divider = value; 
			if (_divider) {
				_divider.x = search.x + search.displayWidth;	
				addChild(_divider);
			}
		}
		
		/**
		 * Result set background display
		 */
		private function get resultSetBkg():Bitmap { return _resultSetBkg; }
		private function set resultSetBkg(value:Bitmap):void {
			if (_resultSetBkg) {
				_resultSetBkg.bitmapData.dispose();
				removeChild(_resultSetBkg);
				_resultSetBkg = null;
			}
			_resultSetBkg = value; 
			if (_resultSetBkg) {
				_resultSetBkg.x = results.x;
				_resultSetBkg.y = results.y;
				addChildAt(_resultSetBkg, 0);
			}
		}
		
		/**
		 * Browser open and close display
		 */
		public function get handle():* { return _handle; }
		public function set handle(value:*):void {
			_handle = displayById(value) as Handle;
		}
		
		/**
		 * Expand browser to reveal controls
		 */
		private function open():void {
			divider.visible = true; 
			tween.play();
			results.displayResultCount();			
		}
		
		/**
		 * Collapse browser to conceal controls
		 */
		private function close():void {
			tween.reverse();
		}
		
		/**
		 * Invoked on close animation complete
		 */
		private function closed():void {
			_handle.hideSides = true; 
			divider.visible = false; 
		}
		
		/**
		 * Set collection tags
		 */
		public function set tags(value:Vector.<String>):void {
			row.reset();
			search.tags = value; 
			if (_handle.open) {
				_handle.open = false; 
			}				
		}
		
		/**
		 * Load tagged items
		 * @param	value
		 */
		public function tagSelect(value:Tag):void {
			results.loadResults(value.fullText, OmekaClient.instance.getTagItems(value.fullText));
		}
		
		/**
		 * Unload tagged items
		 * @param	value
		 */
		public function tagUnselect(value:Tag):void {
			results.unloadResults(value.fullText);
		}
		
		/**
		 * Indicates whether browser is primary(bottom) or secondary(top)
		 * @return
		 */
		public function get isPrimary():Boolean { return primary; }
		
		/**
		 * Number of items in omeka repository
		 */
		public function set totalItems(value:int):void {
			results.totalItems = value; 
		}
	}

}