package data 
{
	import display.browser.result.Item;
	import flash.events.Event;
	
	/**
	 * Omeka item data object
	 * @author Ideum
	 */
	public class ItemData 
	{
		private var requester:RestCall;			//requester instance
		private var loadComplete:Function;		//load callback
		private var fileLoad:Boolean;			//flag indicating files are set
		private var textLoad:Boolean; 			//flag indicateing text is set
		
		public var id:int; 
		public var thumb:String; 				//media preview reference
		public var media:String; 				//primary media reference
		public var display:String;			    //display media for non-visual(audio) media types 
		
		public var title:String; 				//a name given to the resource
		public var subject:String;				//a topic of the resource		
		public var description:String; 			//an account of the resource
		public var creator:String;				//an entity primarily responsible for making the resource
		public var source:String;				//a related resource from which the described resource is delivered		
		public var publisher:String;			//an entity responsible for making the resource available
		public var date:String;					//a point or period of time associated with an event in the lifecylce of the resource
		public var contributor:String; 			//an entity responsible for making contributions to the resource
		public var rights:String; 				//information about rights held in and over the resource
		public var relation:String; 			//a related resource
		public var format:String; 				//the file format, physical medium, or dimensions of the resource
		public var language:String; 			//a language of the resource
		public var type:String; 				//the nature or genre of the resource
		public var identifier:String; 			//an unambiguous reference to the resource within a given context
		public var coverage:String; 			//the spatial or temporal topic of the resource, the spactial applicability of the resource, or the jurisdiction under which the resource is relevant
		
		public var tags:Array; 					//tags registered to item
		public var primary:Item;				//current primary browser item
		public var secondary:Item;				//current secondary browser item
		
		/**
		 * Constructor
		 * @param	requester
		 */
		public function ItemData(requester:RestCall, tags:Array) {
			this.requester = requester; 
			this.tags = tags; 
			title = description = "";
		}
		
		/**
		 * Loads content data of specific item
		 * @param	id	item id
		 * @param	callback  function invoked on load complete
		 */
		public function load(item:Object, callback:Function):void {
			this.loadComplete = callback; 
			id = item.id; 
			setMetaData(item);
			requester.addEventListener(Event.COMPLETE, setFilePaths);
			requester.makeRequest("GET", "files", { item:item.id } );		
		}
		
		/**
		 * Set text properties
		 * @param	item
		 */
		private function setMetaData(item:Object):void {
			var name:String; 
			for each(var text:Object in item.element_texts) {				
				name = String(text.element.name).toLowerCase();
				if (name in this) {
					this[name] = text.text; 
				}
			}			
		}
		
		/**
		 * Set media file paths
		 * @param	event
		 */
		private function setFilePaths(event:Event):void {
			requester.removeEventListener(Event.COMPLETE, setFilePaths);	
			
			//parse files
			for each(var result:Object in requester.result) {
				if (!result.file_urls) {
					continue;
				}
				
				//set thumb
				thumb = thumb ? thumb : result.file_urls.thumbnail; 
				
				//set media
				if (!media) {
					media = result.file_urls.original; 
				}
				
				//set secondary display media (audio only)
				else if(OmekaClient.instance.supportedImage.test(result.file_urls.original)){
					display = result.file_urls.original;
				}
			}
			
			//invoke complete callback
			if (loadComplete != null) {
				loadComplete.call(null, this);
				requester = null; 
				loadComplete = null; 
			}
		}
		
		/**
		 * Track currently selected item
		 * @param	item  Item to track
		 * @param	primary  Determines if item is a member of the primary or secondary browser
		 */
		public function setItem(item:Item, primary:Boolean):void {
			if (primary) {
				this.primary = item; 
			}
			else {
				this.secondary = item; 
			}
		}
		
		/**
		 * Converts object to string
		 * @return
		 */
		public function toString():String {
			return "\nMedia: "+media+"\nThumb: "+thumb+"\nTitle: "+title+"\nDescription: "+description;
		}
	}

}