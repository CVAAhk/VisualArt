package display.browser.result 
{
	import assets.GUIAssets;
	import assets.Skin;
	import com.gestureworks.cml.base.media.MediaStatus;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import data.ItemData;
	import display.browser.CollectionBrowser;
	import display.layout.Row;
	import display.OmekaCollectionViewer;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	/**
	 * Media preview and content container
	 * @author Ideum
	 */
	public class Item extends Sprite 
	{		
		private var loader:ImageLoader;			//thumbnail loader
		private var primary:Boolean; 			//item is a member of the primary(bottom) or secondary(top) browser		
		private var title:Text;					//content title
		private var font:Object; 				//title font properties
		
		private var _onStage:Bitmap;				
		private var _content:ItemData;
		private var _selected:Boolean;
		private var _bitmap:Bitmap;		
		private var _row:Row;	
		
		/**
		 * Assigned to items in a selected state but not longer being tracked by result set mechanisms. The
		 * callback will be invoked when item is unselected(corresponding viewer closes) and returned to 
		 * result set tracking. 
		 */
		public var revive:Function; 	
		
		/**
		 * Constructor
		 */
		public function Item(browser:CollectionBrowser) {
			mouseChildren = false; 
			primary = browser.isPrimary;
			_row = browser.row; 
			title = new Text();
			updateSkin();
			cacheAsBitmap = true; 			
		}	
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			//on stage indicator
			onStage = Skin.instance.onStage;

			//title element			
			title.font = font["font"];
			title.fontSize = font["fontSize"];
			title.color = font["fontColor"];
			title.y = 200;
			addChild(title);						
		}
		
		/**
		 * Indicates item is already loaded to stage		
		 */
		private function get onStage():Bitmap { return _onStage; }
		private function set onStage(value:Bitmap):void {
			if (_onStage) {
				_onStage.bitmapData.dispose();
				removeChild(_onStage);
				_onStage = null; 
			}
			_onStage = value; 
			if (_onStage) {
				_onStage.visible = false; 
				font = _onStage.metaData; 
				addChild(_onStage);				
			}
		}
		
		/**
		 * Content data object
		 */
		public function get content():ItemData { return _content; }
		public function set content(value:ItemData):void {
			_content = value; 
			if (_content) {
				loadThumb();
			}
		}
		
		/**
		 * Selected state of item
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value; 
			if (_selected) {
				alpha = .7;
				onStage.visible = true; 
				content.setItem(this, isPrimary);
				OmekaCollectionViewer.instance.next.item = this; 
			}
			else {
				content.setItem(null, isPrimary);
				alpha = 1;
				onStage.visible = false; 
				
				//return to object pool
				if (revive != null) {
					revive.call(null, this);
					content = null; 
				}				
			}
		}
		
		/**
		 * Thumb display
		 */
		private function loadThumb():void {
			if(_content.thumb){
				loader = new ImageLoader(new URLRequest(_content.thumb), { allowMalformedURL:true, onComplete:loadComplete, onError:loadError, autoDispose:true } );
				loader.load();
			}
			else {
				loadComplete();
			}
		}
		
		/**
		 * Load content title
		 */
		private function loadTitle():void {
			title.width = bitmap.width;
			title.str = _content.title.toUpperCase();
			
			//truncate when text exceeds title width
			while (title.getLineMetrics(0).width > title.width) {
				title.str = title.str.substr(0, title.str.length - 4).concat("...");
			}
		}
		
		/**
		 * Load error output
		 * @param	event
		 */
		private function loadError(event:LoaderEvent):void {
			trace(event.text);
		}
		
		/**
		 * Update bitmap
		 * @param	event
		 */
		private function loadComplete(event:LoaderEvent = null):void {
			bitmap = loader ? loader.rawContent : GUIAssets.instance.placeholder; 
			loadTitle();
			dispatchEvent(new StateEvent(StateEvent.CHANGE, this, MediaStatus.LOADED, true)); 
			loader = null; 
		}
		
		/**
		 * Bitmap display
		 */
		public function get bitmap():Bitmap { return _bitmap; }
		public function set bitmap(value:Bitmap):void {
			if (_bitmap) {
				removeChild(_bitmap);
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			
			_bitmap = value;
			if (_bitmap) {
				var s:Number = 200 / _bitmap.height;
				_bitmap = DisplayUtils.resampledBitmap(_bitmap, s * _bitmap.width, s * bitmap.height);	
				onStage.x = _bitmap.width / 2 - onStage.width / 2;
				onStage.y = _bitmap.height / 2 - onStage.height / 2;
				addChildAt(_bitmap, 0);				
			}
		}
		
		/**
		 * Reference to layout-row corresponding to containing browser 
		 */
		public function get row():Row { return _row; }
		
		/**
		 * Returns membership to either primary(true) or secondary(false) browser
		 */
		public function get isPrimary():Boolean { return primary; }
	}

}