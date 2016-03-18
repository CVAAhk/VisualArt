package display.layout 
{
	import com.gestureworks.cml.elements.TouchContainer;
	import display.media.OmekaMediaViewer;
	import flash.display.Sprite;
	
	/**
	 * Primary viewer container that manages position projections
	 * @author Ideum
	 */
	public class Row extends Sprite
	{		
		private var index:int; 
		private var projections:Vector.<Projection>;
		private var viewer:TouchContainer;
		private var current:Projection; 		
		
		/**
		 * Constructor
		 */
		public function Row() {
			initProjections();	
			reset();
		}	
		
		/**
		 * Instantiate and layout projections
		 */
		private function initProjections():void {
			projections = new Vector.<Projection>();
			var ph:Projection;
			for (var i:int = 0; i < 5; i++) {
				ph = new Projection();
				ph.x = i * 763;
				projections.push(addChild(ph));
			}
		}
		
		/**
		 * Position viewer at the projected location 
		 * @param	viewer
		 */
		public function position(viewer:OmekaMediaViewer):void {
			
			var proj:Projection = current;
			if (proj) {
				proj.preload = true; 
				proj.toggle();
				viewer.projection = proj; 
				viewer.alpha = 1; 
				viewer.visible = true; 
			}
			
			//set next projected location
			index = index < projections.length - 1 ? index + 1 : 0;					
			current = projections[index]; 
			current.toggle();	
		}
		
		/**
		 * Scale viewer to projection width
		 * @param	viewer
		 */
		public function scale(viewer:OmekaMediaViewer):void {
			viewer.projection.preload = false; 
			viewer.minScale = (current.width * 0.85) / viewer.front.width; 
			viewer.maxScale = viewer.front.maxHeight / viewer.front.height; 			
			viewer.scale = current.width / viewer.front.width;
		}
		
		/**
		 * Restore initial state
		 */
		public function reset():void {			
			index = 0;
			current = projections[0];
			current.indicator.visible = true; 
			for (var i:int = 1; i < projections.length; i++) {
				projections[i].indicator.visible = false; 
			}
		}
	}

}