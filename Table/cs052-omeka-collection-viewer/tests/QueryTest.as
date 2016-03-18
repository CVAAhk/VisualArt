package  
{
	import com.gestureworks.core.GestureWorks;
	import data.ItemData;
	import data.OmekaClient;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Ideum
	 */
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "60")]
	public class QueryTest extends GestureWorks
	{
		private var tags:Vector.<String>;
		private var index:int; 
		private var text:TextField;
		private var client:OmekaClient;
		
		public function QueryTest() {
			super();
			fullscreen = true; 
			gml = "library/gml/gestures.gml";
		}
		
		override protected function gestureworksInit():void {
			client = OmekaClient.instance; 
			client.endPoint = "http://omeka-everywhere.digitalmediauconn.org";
			client.addEventListener(Event.COMPLETE, printTags);
			client.load();
			var items:Vector.<ItemData>;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == 13) {
					text.text = "LOADING..."
					items = client.getTagItems(tags[index]);
					trace(items);
					index = index == tags.length - 1 ? 0 : index + 1; 
				}
			});
			
			text = new TextField();
			text.scaleX = text.scaleY = 3; 
			text.text = "LOADING...";
			addChild(text);
		}
		
		private function printTags(event:Event):void {
			tags = client.tags; 
			text.text = "LOAD COMPLETE";
		}
	}

}