package  
{
	import com.gestureworks.cml.elements.TLF;
	import com.gestureworks.core.GestureWorks;
	import display.browser.tags.TagSearch;
	import flash.events.KeyboardEvent;
	import flash.text.Font;
	/**
	 * ...
	 * @author Ideum
	 */
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "60")]
	public class InlineText extends GestureWorks
	{
		private var list:XMLList; 
				
		//[Embed(source = "JosefinSans-Bold.ttf",
			//fontName = 'JosefinSansBold',
			//fontStyle = 'true',
			//mimeType = 'application/x-font-truetype',
			//advancedAntiAliasing = 'true',
			//embedAsCFF = 'true')]
        //public static var JosefinSansBold:Class;
        //Font.registerFont(JosefinSansBold);		
		
		public function InlineText() {
			super();
			fullscreen = true; 
			gml = "library/gml/gestures.gml";
		}
		
		override protected function gestureworksInit():void {
			var tlf:TLF = new TLF();
			tlf.font = "JosefinSansBold";
			tlf.width = 500;
			first();
			tlf.input(list);
			addChild(tlf);
						
			trace(tlf.displayHeight);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == 13) {
					second();
					tlf.input(list);
					trace(tlf.displayHeight);
				}
			});
		}
		
		private function first():void {			
			list = XMLList(<TextFlow xmlns='http://ns.adobe.com/textLayout/2008' color='0xFF2233' fontSize="30" paragraphSpaceAfter="40">
		 			<p>
						<span fontSize="24" color="#FFFFFF">Description</span><br/>
						The roadrunner, also known as a chaparral bird and a chaparral cock, is a fast-running ground cuckoo that has a long tail and a crest. It is found in the southwestern United States and Mexico, usually in the desert. Some have been clocked at speeds of 20 miles per hour.
					</p>
					<p>
						<span fontSize="24" color="#FFFFFF">Creator</span><br/>
						Tyler the Creator
					</p>						
		 	</TextFlow>);			
		}
		
		private function second():void {
			list = XMLList(<TextFlow xmlns='http://ns.adobe.com/textLayout/2008' color='0xFF2233' fontSize="30" paragraphSpaceAfter="40">
		 			<p>
						<span fontSize="24" color="#FFFFFF">Description</span><br/>
						Second Description
					</p>
					<p>
						<span fontSize="24" color="#FFFFFF">Creator</span><br/>
						Another Creator
					</p>						
		 	</TextFlow>);						
		}
		
	}

}