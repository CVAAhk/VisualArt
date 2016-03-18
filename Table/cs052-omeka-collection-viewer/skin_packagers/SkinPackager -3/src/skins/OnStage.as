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
			metaData = { "font":"DroidSerifBold", "fontSize":24, "fontColor":0xb3b3b3 };
		}
	}

}