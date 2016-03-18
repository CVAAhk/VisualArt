package display.media.back 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.TouchContainer;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Header section of back info panel
	 * @author Ideum
	 */
	public class Header extends Segment implements SkinElement
	{	
		private var _title:Title;
		private var _thumb:Thumb;
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				mouseChildren = false; 
				_thumb = getElementsByTagName(Thumb)[0] as Thumb;
				_title = getElementsByTagName(Title)[0] as Title;  
				updateSkin();
			}
			super.init();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			var bkg:Object = Skin.instance.header; 
			color = bkg["color"];
			_title.font = bkg.metaData; 
		}
		
		/**
		 * Assign thumb source
		 */
		public function set thumb(value:Bitmap):void {
			_thumb.source = value; 
		}
		
		/**
		 * Assign title display
		 */
		public function set title(value:String):void {
			_title.str = value; 
		}
	}

}