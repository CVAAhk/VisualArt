package  
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWGestureEvent;
	import display.Scroller;
	/**
	 * ...
	 * @author Ideum
	 */
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "60")]
	public class ScrollTest extends GestureWorks
	{		
		public function ScrollTest() {
			super();
			fullscreen = true; 
			gml = "library/gml/gestures.gml";
		}
		
		override protected function gestureworksInit():void {
			
			var container:Container = new Container();
			container.graphics.beginFill(0);
			container.graphics.drawRect(0, 0, 500, 700);	
			container.gestureList = { "n-drag":true, "n-rotate":true };
			container.addEventListener(GWGestureEvent.ROTATE, function(e:GWGestureEvent):void {
				scroller.updateDragAngle();
			});
			addChild(container);
			
			var content:TouchContainer = new TouchContainer();
			content.graphics.beginFill(0x00FF00);
			content.graphics.drawRect(0, 0, 400, 4000);			
			
			var scroller:Scroller = new Scroller();
			scroller.width = 400;
			scroller.height = 600;
			scroller.x = container.displayWidth / 2 - scroller.width / 2;
			scroller.y = container.displayHeight / 2 - scroller.height / 2; 
			scroller.content = content; 
			scroller.init();
			container.addChild(scroller);
						
		}
	}

}