package assets 
{
	import display.OmekaCollectionViewer;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	
	/**
	 * GUI skin pack manager
	 * @author Ideum
	 */
	public class Skin 
	{
		private static var _instance:Skin;		
		private var ViewerBackground:Class;
		private var BodyPanel:Class; 
		private var ButtonClose:Class;
		private var ButtonFlip:Class;
		private var ButtonInfo:Class;
		private var ButtonPause:Class;
		private var ButtonPlay:Class;
		private var Divider:Class;
		private var HandleSide:Class;
		private var HandleTop:Class;
		private var HeaderPanel:Class; 
		private var Instruction:Class; 
		private var JumpPrimary:Class;
		private var JumpSecondary:Class;
		private var JumpSelect:Class;
		private var OnStage:Class;
		private var Position:Class;
		private var PositionNext:Class;
		private var Preloader:Class; 
		private var Prompt:Class; 
		private var QueryAnchor:Class;
		private var QueryBackground:Class;
		private var QueryClose:Class;
		private var ResultSetBackground:Class; 
		private var ScrollTrack:Class; 
		private var ScrollBar:Class; 
		private var TagBackground:Class;
		private var TagDefault:Class;
		private var TagSelected:Class;
		
		/**
		 * Singleton constructor
		 * @param	enforcer
		 */
		public function Skin(enforcer:SingletonEnforcer) {
			reload();
		}
		
		/**
		 * Skin instance
		 */
		public static function get instance():Skin {
			if (!_instance) {
				_instance = new Skin(new SingletonEnforcer());
			}
			return _instance; 
		}
		
		/**
		 * Reload library skins
		 */
		public function reload():void {
			loadFonts();
			loadSkins();			
		}
		
		/**
		 * Register fonts
		 */
		private function loadFonts():void {
			var bold:Class = ref("fonts.Bold");			
			var semiBold:Class = ref("fonts.SemiBold");
			var boldTLF:Class = ref("fonts.BoldTLF");
			registerFonts([bold, semiBold, boldTLF]);			
		}
		
		/**
		 * Register skins
		 */
		private function loadSkins():void {
			ViewerBackground = ref("skins.Background");
			BodyPanel = ref("skins.Body");
			ButtonClose = ref("skins.ButtonClose");
			ButtonFlip = ref("skins.ButtonFlip");
			ButtonInfo = ref("skins.ButtonInfo");
			ButtonPause = ref("skins.ButtonPause");
			ButtonPlay = ref("skins.ButtonPlay");
			Divider = ref("skins.Divider");
			HeaderPanel = ref("skins.Header");
			HandleSide = ref("skins.HandleSide");
			HandleTop = ref("skins.HandleTop");
			Instruction = ref("skins.Instruction");
			JumpPrimary = ref("skins.JumpPrimary");
			JumpSecondary = ref("skins.JumpSecondary");
			JumpSelect = ref("skins.JumpSelect");
			OnStage = ref("skins.OnStage");
			Position = ref("skins.Position");
			PositionNext = ref("skins.PositionNext");
			Preloader = ref("skins.Preloader");
			Prompt = ref("skins.Prompt");
			QueryAnchor = ref("skins.QueryAnchor");
			QueryBackground = ref("skins.QueryBackground");
			QueryClose = ref("skins.QueryClose");
			ResultSetBackground = ref("skins.ResultSetBackground");
			ScrollTrack = ref("skins.ScrollTrack");
			ScrollBar = ref("skins.ScrollBar");
			TagBackground = ref("skins.TagBackground");
			TagDefault = ref("skins.TagDefault");
			TagSelected = ref("skins.TagSelected");	
		}
		
		/**
		 * Returns class by package name
		 * @param	className
		 * @return
		 */
		private function ref(className:String):Class { 
			try {
				return OmekaCollectionViewer.instance.skinDomain.getDefinition(className) as Class; 
			}
			catch (error:Error) { }
			return null; 
		}
		
		/**
		 * Registers array of fonts
		 * @param	fonts
		 */
		private function registerFonts(fonts:Array):void {
			for each(var font:Class in fonts) {
				if(font){
					Font.registerFont(font);
				}
			}
		}
		
		/**
		 * Media viewer body background
		 */
		public function get body():Object { return BodyPanel ? new BodyPanel() : GUIAssets.instance.body; }
		
		/**
		 * Media viewer close control
		 */
		public function get buttonClose():Bitmap { return ButtonClose ? new ButtonClose() : GUIAssets.instance.buttonClose; }

		/**
		 * Media viewer back-to-front control
		 */		
		public function get buttonFlip():Bitmap { return ButtonFlip ? new ButtonFlip() : GUIAssets.instance.buttonFlip; }
		
		/**
		 * Media viewer front-to-back control
		 */		
		public function get buttonInfo():Bitmap { return ButtonInfo ? new ButtonInfo() : GUIAssets.instance.buttonInfo; }
		
		/**
		 * Media viewer pause streaming media control
		 */		
		public function get buttonPause():Bitmap { return ButtonPause ? new ButtonPause() : GUIAssets.instance.buttonPause; }
		
		/**
		 * Media viewer play streaming media control
		 */
		public function get buttonPlay():Bitmap { return ButtonPlay ? new ButtonPlay() : GUIAssets.instance.buttonPlay; }
		
		/**
		 * Browser section boundary
		 */
		public function get divider():Bitmap { return Divider ? new Divider() : GUIAssets.instance.divider; }
		
		/**
		 * Browser side(close) handle
		 */
		public function get handleSide():Bitmap { return HandleSide ? new HandleSide() : GUIAssets.instance.handleSide; }
		
		/**
		 * Browser top(open) handle
		 */
		public function get handleTop():Bitmap { return HandleTop ? new HandleTop() : GUIAssets.instance.handleTop; }
		
		/**
		 * Media viewer header background 
		 */
		public function get header():Object { return HeaderPanel ? new HeaderPanel() : GUIAssets.instance.header; }
		
		/**
		 * Browser instruction label
		 */
		public function get instruction():Bitmap { return Instruction ? new Instruction() : GUIAssets.instance.instruction; }
		
		/**
		 * Alpha scroller item default
		 */
		public function get jumpPrimary():Bitmap { return JumpPrimary ? new JumpPrimary() : GUIAssets.instance.jumpPrimary; }
		
		/**
		 * Alpha scroller item alternative
		 */
		public function get jumpSecondary():Bitmap { return JumpSecondary ? new JumpSecondary() : GUIAssets.instance.jumpSecondary; }
		
		/**
		 * Alpha scroller item select
		 */
		public function get jumpSelect():Bitmap { return JumpSelect ? new JumpSelect() : GUIAssets.instance.jumpSelect; }
		
		/**
		 * Result item selected state indicator
		 */
		public function get onStage():Bitmap { return OnStage ? new OnStage() : GUIAssets.instance.onStage; }
		
		/**
		 * Media viewer stage positions
		 */
		public function get position():Bitmap { return Position ? new Position() : GUIAssets.instance.position; }
		
		/**
		 * Projected position of next loaded media viewer
		 */
		public function get positionNext():Bitmap { return PositionNext ? new PositionNext() : GUIAssets.instance.positionNext; }
		
		/**
		 * Load progress indicator
		 */
		public function get preloader():Bitmap { return Preloader ? new Preloader() : GUIAssets.instance.preloader; }
		
		/**
		 * Instructional text displayed when result set is empty
		 */
		public function get prompt():Bitmap { return Prompt ? new Prompt() : GUIAssets.instance.prompt; }
		
		/**
		 * Tag query graphic
		 */
		public function get queryAnchor():Bitmap { return QueryAnchor ? new QueryAnchor() : GUIAssets.instance.queryAnchor; }
		
		/**
		 * Tag query container background
		 */
		public function get queryBackground():Bitmap { return QueryBackground ? new QueryBackground() : GUIAssets.instance.queryBackground; }
		
		/**
		 * Tag query remove control
		 */
		public function get queryClose():Bitmap { return QueryClose ? new QueryClose() : GUIAssets.instance.queryClose; }
		
		/**
		 * Background of result set navigator
		 */
		public function get resultSetBackground():Bitmap { return ResultSetBackground ? new ResultSetBackground() : GUIAssets.instance.resultSetBackground; }
		
		/**
		 * Color data for scroll track element
		 */
		public function get scrollTrack():Object { return ScrollTrack ? new ScrollTrack() : GUIAssets.instance.scrollTrack; }
		
		/**
		 * Color data for scroll bar element
		 */
		public function get scrollBar():Object { return ScrollBar ? new ScrollBar() : GUIAssets.instance.scrollBar; }
		
		/**
		 * Tag list container background
		 */
		public function get tagBackground():Bitmap { return TagBackground ? new TagBackground() : GUIAssets.instance.tagBackground; }
		
		/**
		 * Tag unselected state
		 */
		public function get tagDefault():Bitmap { return TagDefault ? new TagDefault() : GUIAssets.instance.tagDefault; }
		
		/**
		 * Tag selected state
		 */
		public function get tagSelect():Bitmap { return TagSelected ? new TagSelected() : GUIAssets.instance.tagSelect; }
		
		/**
		 * Omeka viewer background
		 */
		public function get background():Bitmap { return ViewerBackground ? new ViewerBackground() : GUIAssets.instance.background; }		
		
	}

}
class SingletonEnforcer{}