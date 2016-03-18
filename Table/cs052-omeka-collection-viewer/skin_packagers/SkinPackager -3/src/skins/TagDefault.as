package skins  
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ideum
	 */
	[Embed(source="../../assets/ui/tag-default.png")]
	public class TagDefault extends Bitmap
	{		
		public function TagDefault() {
			metaData = { "font":"DroidSerifBold", "fontSize":24, "fontColor":0x404040 };
		}		
	}

}