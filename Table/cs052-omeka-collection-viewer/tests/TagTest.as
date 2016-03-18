package  
{
	import com.gestureworks.core.GestureWorks;
	import display.browser.tags.TagSearch;
	/**
	 * ...
	 * @author Ideum
	 */
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "60")]
	public class TagTest extends GestureWorks
	{
		
		public function TagTest() {
			super();
			fullscreen = true; 
			gml = "library/gml/gestures.gml";
		}
		
		override protected function gestureworksInit():void {
			
			var search:TagSearch = new TagSearch();
			search.x = stage.stageWidth / 2 - search.width / 2;
			search.y = stage.stageHeight / 2 - search.height / 2; 
			search.init();
			addChild(search);			
			
			var tags:Vector.<String> = new <String>["Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero", 
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero", 
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero",
			"Amber", "alskdfaskjdflajsd;kfjas;ldkj;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Amber", "alskdfaskjdflajsd;kfjas;ldkjfslkdjf;;ldkjfslkdjf;kfjas;ldkjfslkdjf;;ldkjfslkdjf;", "Shaun", "Lacey", "test", "Jeanette", "Abel", "Amber", "vero"];
			search.tags = tags; 
		}
		
	}

}