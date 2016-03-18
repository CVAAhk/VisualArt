package display.media.back 
{
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TLF;
	import com.gestureworks.cml.elements.TouchContainer;
	import data.ItemData;
	/**
	 * The content meta data fields
	 * @author Ideum
	 */
	public class MetaData extends TouchContainer
	{
		private var tlf:TLF;
		private var input:XMLList;
		private var elements:Vector.<String>;
		
		private var nameFont:String;
		private var nameSize:Number;
		private var nameColor:String; 
		
		private var valueFont:String;
		private var valueSize:Number; 
		private var valueColor:String;
		
		public var paragraphSpaceAfter:Number = 20;
		
		/**
		 * Constructor
		 */
		public function MetaData() {
			mouseChildren = false; 
			tlf = new TLF();
			elements = new Vector.<String>();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			if (!initialized) {
				addChild(tlf);
			}
			super.init();
		}
		
		/**
		 * Retrieve the type of meta data to display and the order to display it 
		 * @param	cml
		 * @return
		 */
		override public function parseCML(cml:XMLList):XMLList {
			if (cml.length() > 0) {
				var attributes:XMLList = cml[0].*;
				for (var i:int = 0; i < attributes.length(); i++) {
					if (attributes[i].name() == "element") {
						elements.push(String(attributes[i]));
					}
				}
				delete cml[0].*;
			}
			return super.parseCML(cml);
		}
		
		/**
		 * Update font properties
		 */
		public function set font(value:Object):void {
			nameFont = value["font2"];
			nameSize = value["fontSize2"];
			nameColor = value["fontColor2"];
			valueFont = value["font"];
			valueSize = value["fontSize"];
			valueColor = value["fontColor"];
		}
		
		/**
		 * Text value
		 */
		public function set infoMetaData(value:ItemData):void {
			format(value);
			tlf.font = valueFont; 
			tlf.input(input); 		
		}
		
		/**
		 * 
		 * @param	value
		 */
		private function format(value:ItemData):void {
			input = XMLList( < TextFlow xmlns = 'http://ns.adobe.com/textLayout/2008' color = { valueColor } fontSize = { valueSize } paragraphSpaceAfter = { paragraphSpaceAfter } paddingLeft="20" paddingTop="20"/> );
			for each(var element:String in elements) {
				addElement(element, value);
			}
			input.appendChild(<p><br/></p>);
		}
		
		/**
		 * Insert formatted meta data element into text flow
		 * @param	element
		 * @param	value
		 */
		private function addElement(element:String, value:ItemData):void {
			var prop:String = element.toLowerCase();
			if (prop in value && value[prop] != null) {
				input.appendChild(<p><span fontFamily={nameFont} fontSize={nameSize} color={nameColor}>{element}</span><br/>{value[prop]}</p>);	
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void {
			super.width = value;
			tlf.width = value; 
		}
	}

}