package assets 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ideum
	 */
	public class GUIAssets 
	{	

		private static var _instance:GUIAssets;

		[Embed(source="../../ui/fade-right.png")]
		private var RightFade:Class;
		public function get rightFade():Bitmap { return new RightFade(); }
		
		[Embed(source="../../ui/fade-left.png")]
		private var LeftFade:Class;
		public function get leftFade():Bitmap { return new LeftFade(); }	
		
		[Embed(source="../../ui/placeholder.png")]
		private var Placeholder:Class;
		public function get placeholder():Bitmap { return new Placeholder(); }		
		
		[Embed(source="../../ui/menu-bg.png")]
		private var LoadMenuBkg:Class; 
		public function get loadMenuBkg():Bitmap { return new LoadMenuBkg(); }
		
		[Embed(source="../../ui/menu-dropdown-init-bg.png")]
		private var DropDownText:Class; 
		public function get dropDown():Bitmap { return new DropDownText(); }
		
		[Embed(source="../../ui/menu-dropdown-init-button.png")]
		private var DropDownButton:Class; 
		public function get dropDownButton():Bitmap { return new DropDownButton(); }
		
		[Embed(source="../../ui/option-select.png")]
		private var OptionSelect:Class; 
		public function get optionSelect():Bitmap { return new OptionSelect(); }
		
		[Embed(source="../../ui/menu-button-accept.png")]
		private var AcceptButton:Class; 
		public function get acceptButton():Bitmap { return new AcceptButton(); }
		
		[Embed(source="../../ui/menu-button-cancel.png")]
		private var CancelButton:Class; 
		public function get cancelButton():Bitmap { return new CancelButton(); }
		
		/******************DEFAULT SKIN******************/
		
		public function get body():Object{ return { "color":0xFFFFFF, "metaData":{ "font":"OpenSansBoldTLF", "fontSize":24, "fontColor":"0x000000", "font2":"OpenSansBoldTLF", "fontSize2":20, "fontColor2":"0xCCCCCC" } }; }		
		
		[Embed(source="../../ui/skin/button-close.png")]
		private var ButtonClose:Class; 
		public function get buttonClose():Bitmap { return new ButtonClose(); }

		[Embed(source="../../ui/skin/button-flip.png")]
		private var ButtonFlip:Class;
		public function get buttonFlip():Bitmap { return new ButtonFlip(); }

		[Embed(source="../../ui/skin/button-info.png")]
		private var ButtonInfo:Class;
		public function get buttonInfo():Bitmap { return new ButtonInfo(); }
		
		[Embed(source="../../ui/skin/button-pause.png")]
		private var ButtonPause:Class;
		public function get buttonPause():Bitmap { return new ButtonPause(); }
		
		[Embed(source="../../ui/skin/button-play.png")]
		private var ButtonPlay:Class;
		public function get buttonPlay():Bitmap { return new ButtonPlay(); }
		
		[Embed(source="../../ui/skin/divider.png")]
		private var Divider:Class;
		public function get divider():Bitmap { return new Divider(); }
		
		[Embed(source="../../ui/skin/handle-side.png")]
		private var HandleSide:Class;
		public function get handleSide():Bitmap {
			var b:Bitmap = new HandleSide();
			b.metaData = { "font":"OpenSansBold", "fontSize":24, "fontColor":0xFFFFFF };
			return b; 
		}
		
		[Embed(source="../../ui/skin/handle-top.png")]
		private var HandleTop:Class;
		public function get handleTop():Bitmap { 
			var b:Bitmap = new HandleTop();
			b.metaData = { "font":"OpenSansBold", "fontSize":30, "fontColor":0xFFFFFF };
			return b; 			
		}
		
		public function get header():Object { return { "color":0x000000, "metaData":{ "font":"OpenSansBold", "fontSize":30, "fontColor":0xFFFFFF } }; }		
		
		[Embed(source="../../ui/skin/instruction.png")]
		private var Instruction:Class; 
		public function get instruction():Bitmap { return new Instruction(); }
		
		[Embed(source="../../ui/skin/jump-primary.png")]
		private var JumpPrimary:Class;
		public function get jumpPrimary():Bitmap { 
			var b:Bitmap = new JumpPrimary();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0xFFFFFF };
			return b; 						
		}
		
		[Embed(source="../../ui/skin/jump-secondary.png")]
		private var JumpSecondary:Class;
		public function get jumpSecondary():Bitmap {
			var b:Bitmap = new JumpSecondary();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0x000000 };
			return b; 						
		}
		
		[Embed(source="../../ui/skin/jump-select.png")]
		private var JumpSelect:Class;
		public function get jumpSelect():Bitmap {
			var b:Bitmap = new JumpSelect();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0x000000 };
			return b; 						
		}
		
		[Embed(source="../../ui/skin/on-stage.png")]
		private var OnStage:Class;
		public function get onStage():Bitmap { 
			var b:Bitmap = new OnStage();
			b.metaData = { "font":"OpenSansBold", "fontSize":24, "fontColor":0x000000 };
			return b; 									
		}
		
		[Embed(source="../../ui/skin/position.png")]
		private var Position:Class;
		public function get position():Bitmap { return new Position(); }
		
		[Embed(source="../../ui/skin/position-next.png")]
		private var PositionNext:Class;
		public function get positionNext():Bitmap { return new PositionNext(); }
		
		[Embed(source="../../ui/skin/preloader.png")]
		private var Preloader:Class; 
		public function get preloader():Bitmap { return new Preloader(); }
		
		[Embed(source="../../ui/skin/prompt.png")]
		private var Prompt:Class; 
		public function get prompt():Bitmap { return new Prompt(); }
		
		[Embed(source="../../ui/skin/query-anchor.png")]
		private var QueryAnchor:Class; 
		public function get queryAnchor():Bitmap {
			var b:Bitmap = new QueryAnchor();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0xFFFFFF };
			return b; 			
		}
		
		[Embed(source="../../ui/skin/query-background.png")]
		private var QueryBackground:Class; 
		public function get queryBackground():Bitmap { return new QueryBackground(); }
		
		[Embed(source="../../ui/skin/query-close.png")]
		private var QueryClose:Class;
		public function get queryClose():Bitmap { return new QueryClose(); }
		
		[Embed(source="../../ui/skin/results-background.png")]
		private var ResultSetBackground:Class; 
		public function get resultSetBackground():Bitmap { return new ResultSetBackground(); }
		
		public function get scrollTrack():Object { return { "color":0x798585 }; }
		
		public function get scrollBar():Object { return { "color":0xFFFFFF }; }
		
		[Embed(source="../../ui/skin/tag-background.png")]
		private var TagBackground:Class; 
		public function get tagBackground():Bitmap { return new TagBackground(); }
		
		[Embed(source="../../ui/skin/tag-default.png")]
		private var TagDefault:Class; 
		public function get tagDefault():Bitmap { 
			var b:Bitmap = new TagDefault();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0xFFFFFF };
			return b; 				
		}
		
		[Embed(source="../../ui/skin/tag-selected.png")]
		private var TagSelected:Class;
		public function get tagSelect():Bitmap { 
			var b:Bitmap = new TagSelected();
			b.metaData = { "font":"OpenSansRegular", "fontSize":24, "fontColor":0x000000 };
			return b; 							
		}
		
		[Embed(source="../../ui/skin/background.png")]
		private var ViewerBackground:Class; 
		public function get background():Bitmap { return new ViewerBackground(); }		
		
		/**
		 * Constructor
		 * @param	enforcer
		 */
		public function GUIAssets(enforcer:SingletonEnforcer) {}				
		
		/**
		 * Singleton instance
		 */
		public static function get instance():GUIAssets {
			if (!_instance) {
				_instance = new GUIAssets(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private function smooth(bitmap:Bitmap):Bitmap {
			bitmap.smoothing = true; 
			return bitmap; 
		}
	}
}

class SingletonEnforcer{}
