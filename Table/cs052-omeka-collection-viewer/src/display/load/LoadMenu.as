package display.load
{
	import assets.GUIAssets;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.text.Font;
	
	/**
	 * A menu to load omeka repositories and themes
	 * @author Ideum
	 */
	public class LoadMenu extends Sprite
	{	
		[Embed("../../../ui/fonts/Roboto-Light.ttf", 
			fontName = 'RobotoLight', 
			fontFamily = 'Roboto', 
			fontWeight = 'normal', 
			fontStyle = 'normal', 
			mimeType = 'application/x-font-truetype', 
			advancedAntiAliasing = 'true', 
			embedAsCFF = 'false',
			unicodeRange = 'U+0000-FFFD')]
		public static var RobotoLight:Class;
		Font.registerFont(RobotoLight);	
		
		/**
		 * Invoked on accept action
		 */
		public var onLoad:Function; 
		
		//ui
		private var cancel:Sprite;
		private var accept:Sprite; 
		private var repo:DropDown;
		private var theme:DropDown;
		
		private var _dd:DropDown;
		
		/**
		 * Constructor
		 */
		public function LoadMenu() {
			addChild(GUIAssets.instance.loadMenuBkg);
			
			cancel = new Sprite();
			cancel.x = 1566;
			cancel.y = 1538;
			cancel.addChild(GUIAssets.instance.cancelButton);
			cancel.visible = false; 
			addChild(cancel);
			
			accept = new Sprite();
			accept.x = 1760;
			accept.y = 1538;
			accept.addChild(GUIAssets.instance.acceptButton);
			addChild(accept);

			theme = new DropDown();
			theme.x = 1566;
			theme.y = 980;
			addChild(theme);
			
			repo = new DropDown();
			repo.x = 1566;
			repo.y = 770;
			addChild(repo);
			
			visible = visible;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set visible(value:Boolean):void {
			if(value){
				addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			}
			else {
				dropDown = null; 
				removeEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			}
			repo.enableTouch = value; 
			theme.enableTouch = value; 
			super.visible = value; 
		}
		
		/**
		 * Determine control target and execute appropriate action
		 * @param	event
		 */
		private function onTouch(event:TouchEvent):void {
			if (event.target == cancel) {
				visible = false; 
			}
			else if (event.target == accept) {
				visible = false; 
				onLoad.call(null, theme.value, repo.value);
				
				//adjust layout after initial load
				if (!cancel.visible) {
					cancel.visible = true; 
					accept.x = 1950;
				}				
			}
			else if (event.target is Trigger) {
				dropDown = event.target.parent;
			}
		}
		
		/**
		 * Current drop down list
		 */
		public function set dropDown(value:DropDown):void {
			if (_dd && _dd == value) {
				_dd.open = !_dd.open; 
			}
			else {
				if (_dd) {
					_dd.open = false; 
				}
				_dd = value;
				if (_dd) {
					_dd.open = true; 
				}
			}
		}
		
		/**
		 * Omeka endpoint options
		 */
		public function set endpoints(value:Vector.<String>):void {
			repo.options = value; 
		}
		
		/**
		 * Graphic theme options
		 */
		public function set themes(value:Vector.<String>):void {
			theme.options = value; 
		}
	}	
}