package display.layout 
{
	import assets.Skin;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import display.abstract.SkinElement;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Display representing the position of the next selected media item
	 * @author Ideum
	 */
	public class Projection extends Sprite implements SkinElement
	{
		private var w:Number = 696;
		private var h:Number = 946;
		private var loadAnimation:TweenMax;
		private var loadCnt:int;
		
		private var _frame:Bitmap;				
		private var _indicator:Bitmap;		
		private var _preloader:Bitmap;				
		
		/**
		 * Constructor
		 */
		public function Projection() {
			updateSkin();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateSkin():void {
			frame = Skin.instance.position;
			indicator = Skin.instance.positionNext;
			preloader = Skin.instance.preloader;			
		}
		
		/**
		 * Media viewer load position
		 */
		private function get frame():Bitmap { return _frame; }
		private function set frame(value:Bitmap):void {
			if (_frame) {
				_frame.bitmapData.dispose();
				removeChild(_frame);
				_frame = null;
			}
			_frame = value; 
			if (_frame) {
				addChild(_frame);
			}
		}
		
		/**
		 * Identifies the position of the next loaded media viewer
		 */		
		public function get indicator():Bitmap { return _indicator; }
		public function set indicator(value:Bitmap):void {
			if (_indicator) {
				_indicator.bitmapData.dispose();
				removeChild(_indicator);
				_indicator = null;
			}
			_indicator = value;
			if (_indicator) {
				_indicator.x = width / 2 - _indicator.width / 2;
				_indicator.y = height / 2 - _indicator.height / 2;
				_indicator.visible = false; 
				addChild(_indicator);
			}
		}
		
		/**
		 * Indicates a media viewer is loading in this projected location
		 */
		private function get preloader():Bitmap { return _preloader; }
		private function set preloader(value:Bitmap):void {
			if (_preloader) {
				_preloader.bitmapData.dispose();
				removeChild(_preloader);
				_preloader = null;
			}
			_preloader = value;
			if (_preloader) {
				_preloader.smoothing = true; 
				_preloader.x = width / 2 - _preloader.width / 2;
				_preloader.y = height / 2 - _preloader.height / 2;
				_preloader.visible = false; 	
				loadAnimation = TweenMax.to(_preloader, 1, { transformAroundCenter: { rotation:360 }, repeat: -1, ease:Linear.easeNone, paused:true } );
				addChild(_preloader);
			}
		}
		
		/**
		 * Display/hide indictor
		 */
		public function toggle():void {
			indicator.visible = !indicator.visible;
		}
		
		/**
		 * Enable/disable preload animation
		 */
		public function set preload(value:Boolean):void {
			if (value) {
				startPreload();
			}
			else {
				endPreload();
			}
		}
		
		/**
		 * Increment load count and resume animation
		 */
		private function startPreload():void {
			loadCnt++;
			loadAnimation.resume();
			preloader.visible = true; 
		}
		
		/**
		 * Decrement load count and pause animation
		 */
		private function endPreload():void {
			loadCnt--;
			if (!loadCnt) {
				preloader.visible = false; 
				loadAnimation.pause();
			}
		}
	}

}