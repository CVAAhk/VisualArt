package data 
{
	import com.gestureworks.cml.managers.FileManager;
	import data.ItemData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author Ideum
	 */
	public class OmekaClient extends EventDispatcher
	{			
		private static var _instance:OmekaClient;																//singleton instance
		public var supportedMedia:RegExp = /^.*\.(mp3|wav|png|gif|jpg|mpeg-4|mp4|m4v|3gpp|mov|flv|f4v)/i;		//supporte media regex	
		public var supportedImage:RegExp = /^.*\.(png|gif|jpg)/i;												//supported image extensions		

		private var requester:RestCall;																			//omeka rest api
		private var items:Vector.<Vector.<ItemData>>;															//items corresponding to tag	
		private var queue:Array;																				//item load queue
		private var itemsLoaded:int;																			//item load count
		
		private var _totalItems:int; 																			//number of items in omeka repo		
		private var _tags:Vector.<String>;																		//repository tags				
		
		/**
		 * Singleton constructor
		 * @param	enforcer	Singleton enforcer
		 */
		public function OmekaClient(enforcer:SingletonEnforcer) {
			requester = new RestCall();
			_tags = new Vector.<String>();
		}
		
		/**
		 * Returns the OmekaClient singleton instance
		 */
		public static function get instance():OmekaClient {
			if (!_instance) {
				_instance = new OmekaClient(new SingletonEnforcer());
			}
			return _instance; 
		}
		
		/**
		 * Omeka endpoint
		 */
		public function get endPoint():String { return requester.endPoint; }
		public function set endPoint(value:String):void {
			requester.endPoint = value+"/api/"; 
		}
		
		/**
		 * Endpoint api key
		 */
		public function get apiKey():String { return requester.apiKey; }
		public function set apiKey(value:String):void {
			requester.apiKey = value; 
		}
		
		/**
		 * Repository tags
		 */
		public function get tags():Vector.<String> { return _tags.concat(); }
		
		/**
		 * Total items in omeka repository
		 */
		public function get totalItems():int { return _totalItems; }
		
		/**
		 * Load content data
		 * @param	callback
		 */
		public function load():void {
			
			itemsLoaded = 0;
			_tags.length = 0; 
			items = new Vector.<Vector.<ItemData>>();	
			
			requester.addEventListener(ErrorEvent.ERROR, function notify(error:ErrorEvent):void {
				requester.removeEventListener(ErrorEvent.ERROR, notify);
				dispatchEvent(error);
			});
			requester.addEventListener(Event.COMPLETE, function process(event:Event):void {
				requester.removeEventListener(Event.COMPLETE, process);
				queue = requester.result as Array; 
				_totalItems = queue.length; 
				addItem();
			});
			
			requester.makeRequest("GET", "items");
		}
		
		/**
		 * Sequentially generates content data objects for each item
		 */
		private function addItem():void {
			
			itemsLoaded++;
			var item:Object = queue.shift();
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, itemsLoaded, _totalItems));
			
			//bypass items without media files
			if (item && item.files.count < 1) {		
				addItem();
			}
			//load item 
			else if (item) {
				var idata:ItemData = new ItemData(requester, item.tags);				
				idata.load(item, itemLoadComplete);
			}
			//items loaded
			else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Register tags and queue next item
		 * @param	item
		 */
		private function itemLoadComplete(item:ItemData):void {
			registerTags(item);
			addItem();
		}
		
		/**
		 * Generate tag-to-item mapping
		 * @param	tag
		 * @param	item
		 */
		private function registerTags(item:ItemData):void {
			
			//bypass unsupported media types
			if (!supportedMedia.test(item.media)) {
				return; 
			}
			
			//generate mapping
			for each(var tag:Object in item.tags) {		
				
				if (_tags.indexOf(tag.name) == -1) {
					_tags.push(tag.name);
					items.push(new Vector.<ItemData>());
				}
				
				//append tag mapping
				items[_tags.indexOf(tag.name)].push(item);
			}
		}
		
		/**
		 * Returns item data mapped to tag
		 * @param	tag
		 */
		public function getTagItems(tag:String):Vector.<ItemData> { 
			return items[_tags.indexOf(tag)];
		}
	}

}

class SingletonEnforcer{}