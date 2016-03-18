package skins  
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ideum
	 */
	[Embed(source="../../assets/ui/tag-selected.png")]
	public class TagSelected extends Bitmap
	{		
		public function TagSelected() {
			metaData = { "font":"DroidSerifBold", "fontSize":24, "fontColor":0xFFFFFF };
		}		
	}

}