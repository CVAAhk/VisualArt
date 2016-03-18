package display 
{
	import assets.Skin;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.TweenLite;
	import data.OmekaClient;
	import display.abstract.SkinElement;
	import display.attract.AttractVideo;
	import display.browser.CollectionBrowser;
	import display.layout.Row;
	import display.load.LoadMenu;
	import display.load.LoadScreen;
	import display.media.OmekaMediaViewer;
	import display.media.ViewerQueue;
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.TouchEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Manages media display
	 * @author Ideum
	 */
	public class OmekaCollectionViewer extends Container implements SkinElement
	{				
		private static var _instance:OmekaCollectionViewer;
		private var resources:ViewerQueue;
		private var browsers:Array;
		private var client:OmekaClient;
		private var loadMenu:LoadMenu;
		private var loadScreen:LoadScreen; 
		private var urls:Vector.<String>;
		private var repo:String; 
		private var attract:AttractVideo;
		private var points:int; 
		
		private var skins:Vector.<String>;		
		private var isSwf:RegExp = /^.*\.(swf)$/i;	
		private var skinElements:Array; 
		private var skinLoader:SWFLoader;
		private var skinLoaderContext:LoaderContext;
		
		private var _theme:String = "DEFAULT";		
		private var _background:Bitmap;
		
		/**
		 * The qualifying tap time(ms) between touch_up and touch_down events
		 * @default 200
		 */
		public var tapDuration:Number = 200;
		
		/**
		 * The inactivity time(s) permitted before application enters attract mode
		 * @default 120
		 */
		public var attractTime:Number = 120;
		
		/**
		 * The current skin domain
		 */
		public var skinDomain:ApplicationDomain;
		
		/**
		 * Constructor
		 */
		public function OmekaCollectionViewer() {
			if (!_instance) {
				_instance = this; 
				width = 3840;
				height = 2160;
				resources = new ViewerQueue();	
				client = OmekaClient.instance as OmekaClient; 
				
				loadScreen = new LoadScreen();
				loadMenu = new LoadMenu();
				urls = new Vector.<String>();
				skins = new Vector.<String>();
			}
			else {
				throw new Error("OmekaCollectionViewer is a singleton, use 'instance' accessor instead of new.");
			}
		}
		
		/**
		 * Singleton instance
		 */
		public static function get instance():OmekaCollectionViewer {
			if (!_instance) {
				new OmekaCollectionViewer();
			}
			return _instance; 
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			
			//get skin elements to update on theme load
			CMLParser.addEventListener(CMLParser.COMPLETE, collectSkinElements);
			
			//track activity
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			addEventListener(TouchEvent.TOUCH_END, onTouch);
			
			//initialize display
			scale = stage.stageWidth / width; 
			browsers = getElementsByTagName(CollectionBrowser);			
			registerViewers();
			initRows();	
			updateSkin();
			super.init();	
			
			//add load screen at start
			addChild(loadScreen);
			
			//populate load menu options
			loadMenu.endpoints = urls;
			loadMenu.themes = skins; 
			addChild(loadMenu);			
			
			//prompt load menu at start and on ENTER key
			showMenu();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (loadScreen.visible) {
					return; 
				}
				if (e.keyCode == 13) {
					showMenu();
				}
			});
			
			//attract video loop
			attract = new AttractVideo();
			attract.visible = false; 
			attract.loop = true; 
			attract.src = "library/assets/attract.mp4";
			addChild(attract);
			attract.init();
			TweenLite.delayedCall(attractTime, attractMode);
		}
		
		/**
		 * Background graphic
		 */
		public function get background():Bitmap { return _background; }
		public function set background(value:Bitmap):void {			
			if (_background) {
				_background.bitmapData.dispose();
				removeChild(_background);
				_background = null;
			}
			_background = value; 
			if (_background) {
				addChildAt(_background, 0);
			}
		}		
				
		/**
		 * Register viewers with resource manager
		 */
		private function registerViewers():void {
			//prevent viewers from moving on top of browsers
			var top:int = getChildIndex(browsers[0]); 
			
			var viewers:Array = getElementsByTagName(OmekaMediaViewer);
			for each(var viewer:OmekaMediaViewer in viewers) {
				viewer.topIndex = top; 
				resources.add(viewer);
			}
		}
		
		/**
		 * Generate projection rows corresponding to browsers
		 */
		private function initRows():void {
			if (browsers.length < 1) {
				return; 
			}
			
			//assign row to each browser
			for each(var browser:CollectionBrowser in browsers) {
				browser.row = addChildAt(new Row(), 0) as Row;
				browser.row.x = width / 2 - browser.row.width / 2;				
			}
			
			//position rows depending on number of browsers
			if (browsers.length < 2) {
				browsers[0].row.y = (height - browsers[0].height) / 2 - browsers[0].row.height / 2;
			}
			else {
				browsers[0].row.y = height / 2 + 35;
				browsers[1].row.y = height / 2 - browsers[1].row.height - 35; 
				DisplayUtils.rotateAroundCenter(browsers[1].row, 180);
			}
		}
		
		/**
		 * Returns next viewer in resource queue
		 */
		public function get next():OmekaMediaViewer { return resources.resource(OmekaMediaViewer) as OmekaMediaViewer; }
		
		/**
		 * Activity tracking
		 * @param	event
		 */
		private function onTouch(event:TouchEvent):void {
			if (event.type == TouchEvent.TOUCH_BEGIN) {
				onBegin(event);
			}
			else if (event.type == TouchEvent.TOUCH_END) {
				onEnd(event);
			}
		}
		
		/**
		 * Exit attract mode and increment point count
		 * @param	event
		 */
		private function onBegin(event:TouchEvent):void {
			points++;
			attract.visible = false; 
			attract.stop();
			TweenLite.killDelayedCallsTo(attractMode);
		}
		
		/**
		 * Decrement point count and enter attract mode when point count is 0
		 * @param	event
		 */
		private function onEnd(event:TouchEvent):void {
			points--;
			if(!points){
				TweenLite.delayedCall(attractTime, attractMode);
			}
		}		
		
		/**
		 * Resume video
		 */
		private function attractMode():void {
			attract.visible = true; 
			attract.resume();			
		}
		
		/****************************THEME-AND-REPO-MANAGEMENT****************************/
		
		/**
		 * Collect endpoint and theme lists
		 */
		override public function parseCML(cml:XMLList):XMLList {
			if (cml.length() > 0) {
				var attributes:XMLList = cml[0].*;
				
				for (var i:int = attributes.length() - 1; i >= 0 ; i--) {					
					//omeka endpoint urls
					if (attributes[i].name() == "endpoint") {
						urls.unshift(attributes[i]);
						delete attributes[i];
					}
					
					//graphical themes
					if (attributes[i].name() == "theme") {
						skins.unshift(attributes[i]);
						delete attributes[i];
					}					
				}
				
				//include default theme
				skins.unshift(theme);
			}
			return super.parseCML(cml);
		}
		
		/**
		 * Display options
		 */
		private function showMenu():void {
			loadMenu.onLoad = loadOptions;
			loadMenu.visible = true; 
		}
		
		/**
		 * Load theme and repository options
		 * @param	theme
		 * @param	repo
		 */
		private function loadOptions(theme:String, repo:String):void {
			this.repo = repo;
			this.theme = theme; 
		}	
		
		/**
		 * Update ui skin package
		 */
		private function get theme():String { return _theme; }
		private function set theme(value:String):void {
			if (_theme == value) {
				loadRepo();
				return; 
			}
			_theme = value; 			
			loadSkinPackage(_theme);
		}	
		
		/**
		 * Store all skin elements for theme updates
		 * @param	event
		 */
		private function collectSkinElements(event:Event):void {
			CMLParser.removeEventListener(CMLParser.COMPLETE, collectSkinElements);
			skinElements = [this];
			skinElements = skinElements.concat(DisplayUtils.getAllChildrenByType(this, SkinElement, true));						
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			background = Skin.instance.background;
		}		
		
		/**
		 * Load skin swf
		 * @param	skin
		 */
		private function loadSkinPackage(skin:String):void {
			if (skinLoader) {	
				skinDomain = null; 
				skinLoader.unload();
				skinLoader.dispose(true);
				skinLoader = null; 
			}
			if (isSwf.test(skin)) {
				skinDomain = new ApplicationDomain;
				skinLoaderContext = new LoaderContext(false, skinDomain);
				skinLoaderContext.allowCodeImport = true; 				
				skinLoader = new SWFLoader(skin, { context:skinLoaderContext, onComplete:applySkin} );
				skinLoader.load();
			}
			else {
				applySkin();
			}
		}	
		
		/**
		 * Apply skin on load
		 * @param	event
		 */
		private function applySkin(event:LoaderEvent=null):void {
			Skin.instance.reload();			
			for each(var element:SkinElement in skinElements) {
				element.updateSkin();
			}
			loadRepo();
		}
		
		/**
		 * Load content data from omeka repository
		 * @param	event
		 */
		private function loadRepo():void {
			resources.reset();
			loadScreen.progress = 0;
			loadScreen.visible = true; 		
			client.addEventListener(Event.COMPLETE, loadComplete);
			client.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			client.addEventListener(ErrorEvent.ERROR, loadError);
			client.endPoint = repo;
			client.load();
		}
		
		/**
		 * Set browser tags on content load complete
		 * @param	event
		 */
		private function loadComplete(event:Event):void {
			loadScreen.visible = false; 
			client.removeEventListener(Event.COMPLETE, loadComplete);
			client.removeEventListener(ProgressEvent.PROGRESS, loadProgress);	
			client.removeEventListener(ErrorEvent.ERROR, loadError);
			for each(var browser:CollectionBrowser in browsers) {
				browser.totalItems = client.totalItems;
				browser.tags = client.tags; 
			}
		}
		
		/**
		 * Push progress updates to load screen
		 * @param	event
		 */
		private function loadProgress(event:ProgressEvent):void {
			loadScreen.progress = (event.bytesLoaded / event.bytesTotal) * 100;
		}
		
		/**
		 * Push url error to load screen
		 * @param	event
		 */
		private function loadError(event:ErrorEvent):void {
			loadScreen.error = event.text; 
		}		
	}
}