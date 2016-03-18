package display.load 
{
	import assets.GUIAssets;
	import com.gestureworks.cml.elements.Text;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Option extends Sprite
	{		
		private var text:BoundedText; 
		private var defaultColor:uint; 
		private var selectedColor:uint;
		private var selectedState:Bitmap;
		private var selected:Boolean; 
		
		private var _height:Number = 0; 
		
		public function Option(value:String) {
			
			mouseChildren = false; 
			
			selectedState = addChild(GUIAssets.instance.optionSelect) as Bitmap;
			height = selectedState.height;
			
			text = addChild(new BoundedText()) as BoundedText;
			text.str = value; 
			text.x = 25; 
			text.y = height / 2 - text.getLineMetrics(0).height / 2;			
			
			defaultColor = 0xFFFFFF;
			selectedColor = text.color;			
			
			selectedState.visible = false;
			text.color = defaultColor;
		}
		
		override public function get height():Number { return _height;  }		
		override public function set height(value:Number):void {
			_height = value; 
		}
		
		public function toggle():void {
			selected = !selected; 
			selectedState.visible = selected;
			text.color = selected ? selectedColor : defaultColor;
		}
		
		public function get value():String { return text.fullText; }
	}

}