package {
	
	import com.gestureworks.cml.core.CMLCore;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.Stats;
	import display.browser.CollectionBrowser;
	import display.browser.Handle;
	import display.browser.tags.index.AlphaScroller;
	import display.media.back.Body;
	import display.media.back.Header;
	import display.media.back.InfoPanel;
	import display.media.back.MetaData;
	import display.media.back.TextScroller;
	import display.media.back.Thumb;
	import display.media.back.Title;
	import display.media.menu.ControlsMenu;
	import display.media.OmekaMediaViewer;
	import display.OmekaCollectionViewer;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ideum
	 */
	
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "30")]
	//[SWF(width = "3840", height = "2160", backgroundColor = "0xCCCCCC", frameRate = "60")]
	
	public class Main extends GestureWorks {
		
		public function Main():void {
			super();
			
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			
			// load custom cml package and classes
			CMLCore.packages = CMLCore.packages.concat(["display", "display.browser", "display.media", "display.media.back", "display.media.menu", "display.browser.tags.index"]);
			CMLCore.classes = CMLCore.classes.concat([OmekaCollectionViewer, OmekaMediaViewer, CollectionBrowser, Handle, AlphaScroller, TextScroller, ControlsMenu, InfoPanel, 
							  Title, MetaData, Thumb, Header, Body]);				
			
			fullscreen = true;
			gml = "library/gml/gestures.gml";
			cml = "library/cml/main.cml";
		}
		
		/**
		 * CML parsing complete event handler
		 * @param	e
		 */
		private function cmlInit(e:Event):void {			
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);		
			
			if(CONFIG::debug){
				addChild(new Stats());
			}
		}
	}
	
}