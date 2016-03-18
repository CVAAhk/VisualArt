package skins  
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ideum
	 */
	[Embed(source="../../assets/ui/on-stage.png")]
	public class OnStage extends Bitmap 
	{ 
		public function OnStage() {
			metaData = { "font":"JosefinSansSemiBold", "fontSize":20, "fontColor":0x000000 };
		}
	}

}