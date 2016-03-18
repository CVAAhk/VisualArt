package data
{
	
	import com.adobe.serialization.json.JSON;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * Invokes Omeka REST API calls
	 */
	public class RestCall extends EventDispatcher {
		private var requestor:URLLoader;
		public var apiKey:String;
		public var endPoint:String;
		public var result:Object;	
		
		/**
		 * Constructor
		 */
		public function RestCall() {
			requestor = new URLLoader();
			requestor.addEventListener( Event.COMPLETE, httpRequestComplete );
			requestor.addEventListener( IOErrorEvent.IO_ERROR, httpRequestError );
			requestor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, httpRequestError );
		}

		/**
		 * Make a HTTP request
		 * @param	reqType - GET, POST, PUT, DELETE
		 * @param	resource - where to make this request.
		 * @param	urlParameters - an associative array that can specify extra url parameters
		 */
		public function makeRequest(reqType:String, resource:String, urlParameters:Object = null):void {
			if (!endPoint) {
				throw new Error("Must declare a URL endpoint"); 
			}
			var request:URLRequest = new URLRequest( endPoint + slashPrepend(resource));
			switch(reqType.toUpperCase()) {
				case "GET":    // get info about item
					request.method = URLRequestMethod.GET;
					break;
				case "POST":   // create new item
					request.method = URLRequestMethod.POST;
					break;
				case "PUT":    // edit item
					request.method = URLRequestMethod.PUT;
					break;
				case "DELETE": // delete item
					request.method = URLRequestMethod.DELETE;
					break;
				default:
					throw Error("invalid HTTP request type");
					break;
			}
			
			//Add the URL variables
			var variables:URLVariables = new URLVariables();
			if (apiKey) {
				variables.key = apiKey;
			}
			
			if(urlParameters){
				for (var key:String in urlParameters) {
					variables[key] = urlParameters[key];
				}
			}
			
			request.data = variables;
			requestor.load( request );
		}
		
		/**
		 * HTTP request callback, do stuff with the data here.
		 * @param	event
		 */
		private function httpRequestComplete( e:Event ):void {
			result = com.adobe.serialization.json.JSON.decode(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE, false, false));
		} 
		 
		/**
		 * HTTP error callback.
		 * @param	error
		 */
		private function httpRequestError( error:ErrorEvent ):void {
			try {
				result = com.adobe.serialization.json.JSON.decode(error.target.data);	
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, endPoint + " : " + result["message"]));
			}
			catch (e:Error) {
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "URL Error: The provided endpoint may not support the Omeka REST API"));
			}			
		}
		
		/**
		 * prepend "/" on resource, if it's not already there or on urlEndPoint.
		 * @param	res
		 * @return  res with a "/" if it needed one
		 */
		private function slashPrepend(res:String):String {
			if (res.charAt(0) != "/" && endPoint.charAt(endPoint.length-1) != "/") {
				res = "/" + res;
			}
			else if (res.charAt(0) == "/" && endPoint.charAt(endPoint.length-1) == "/") {
				res = res.substr(1, res.length);
			}
			return res;
		}
	}
}