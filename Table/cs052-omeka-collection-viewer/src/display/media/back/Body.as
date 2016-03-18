package display.media.back 
{
	import assets.Skin;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.utils.DisplayUtils;
	import data.ItemData;
	import display.abstract.SkinElement;
	import flash.display.Sprite;
	
	/**
	 * Body section of back info panel
	 * @author Ideum
	 */
	public class Body extends Segment implements SkinElement
	{		
		private var _meta:MetaData;
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				mouseChildren = true; 				
				_meta = DisplayUtils.getAllChildrenByType(this, MetaData, true)[0] as MetaData;
				updateSkin();
			}
			super.init();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			var bkg:Object = Skin.instance.body;
			color = bkg["color"];			
			_meta.font = bkg.metaData;							
		}
		
		/**
		 * Assign meta data display
		 */
		public function set meta(value:ItemData):void {
			_meta.infoMetaData = value; 
		}
	}

}