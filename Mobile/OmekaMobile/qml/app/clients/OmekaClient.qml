pragma Singleton
import QtQuick 2.5

Item {

    id: omeka_client

    /*! \qmlproperty
        Target omeka endpoint url
    */
    //property url endpoint: "http://oe.develop.digitalmediauconn.org/"
    property url endpoint: "http://dev.omeka.org/mallcopy/"
    //property url endpoint: "http://www.huapala.net/"  //no heist support test
    //property url endpoint: "http://marb.kennesaw.edu/identities/"  //no enabled api test

    /*! \qmlproperty
        Target omeka rest api
    */
    property url rest: endpoint+"api/"

    /*! \qmlproperty
        Url root path for sharing items
    */
    property url link: endpoint+"items/show/"

    /*! \qmlproperty
        Current page number
    */
    property int currentPage: 0

    /*! \qmlproperty
        Returns whether or not the REST API is enabled for this omeka instance
    */
    property bool apiIsEnabled: true

    /*! \qmlproperty
        The total number of items in the repository
    */
    property int totalItemCount: 0

    /*! \qmlproperty
        The maximum number of results per request
    */
    property int resultsPerPage: 50

    /*! \qmlproperty
        A formatted name derived from the endpoint url
    */
    property var omekaID: ""

    /*! \qmlproperty
        The site title
    */
    property var title: ""

    /*!
      \internal
      Regex of supported image formats
    */
    property var imageExt: /\.(jpe?g|png|gif|tif?f)$/i

    /*!
      \internal
      Regex of supported audio formats
    */
    property var audioExt: /\.(mp3)$/i

    /*!
      \internal
      Regex of supported video formats
    */
    property var videoExt: /\.(avi|mpe?g|mp4|qt|swf|wmv|mov)$/i

    /*! \qmlsignal
        Invoked on query result*/
    signal requestComplete(var result)

    /*! \qmlsignal
        Invoked when query produces empty result*/
    signal emptyResult(var result)

    /*! \qmlsignal
        Invoked on site info results*/
    signal siteInfo(var result)

    //Check api on complete
    Component.onCompleted: {
        omekaID = prettyName(endpoint)
        getSiteInfo(omeka_client)
        pingAPI()
    }

    /*! \internal
     Ping the REST API to verify it is enabled for this omeka instance. If it is, parse header
     for properties and if it isn't, set apiIsEnabled flag to false.
    */
    function pingAPI() {
        var request = new XMLHttpRequest();        
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.responseText) {
                    try {
                        var result = JSON.parse(request.responseText)

                        //extract item count
                        totalItemCount = request.getResponseHeader("omeka-total-results")

                        //parse results per page
                        var strlink = request.getResponseHeader("link")
                        var re = /.*per_page=(.*)>.*/;
                        resultsPerPage = strlink.replace(re, "$1")

                    } catch(e) {
                        apiIsEnabled = false
                    }
                }
            }
        }
        request.open("GET", rest+"items", true);
        request.send();
    }

    /*! \internal
     Pull site information mainly to acquire title to provide context
    */
    function getSiteInfo(context, url) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                try {
                    var result = JSON.parse(request.responseText)
                    if(context === omeka_client) {
                        title = result.title || omekaID
                    } else {
                        result.context = context
                        result.omekaID = prettyName(url.substring(0, url.lastIndexOf("api")))
                        result.title = result.title || result.omekaID
                        siteInfo(result)
                    }
                } catch(e) {}
            }
        }
        var api = url || rest
        request.open("GET", api+"site", true);
        request.send()
    }

    /*! \internal
      Sends http request and links response handler
      \a url - omeka rest api call
      \a context - calling object instance
      \a count - flags the query as a simple count request
    */
    function submitRequest(url, context, count){
        if(!apiIsEnabled) return;
        var request = new XMLHttpRequest();
        request.url = url;
        request.context = context;
        request.count = count;
        request.onreadystatechange = onResponse(request);
        request.open("GET", url, true);
        request.send();
    }

    /*! \internal */
    function onResponse(request) {
        return function(){
            if(request.readyState === XMLHttpRequest.DONE){
                try {
                    var result = JSON.parse(request.responseText);
                    if(result.errors !== undefined){
                        print("Request Error: "+result.errors[0].message);
                    }
                    else{
                        result.url = request.url;
                        result.context = request.context;
                        result.count = request.count;
                        processResult(result);
                    }
                } catch(e) {
                    print(e);
                }
            }
        }
    }

    /*! \internal
        Generate and send data objects to registered handlers*/
    function processResult(result){       
        var count = result.length || 1;
        var res;

        //result count request
        if(result.count) {
            requestComplete({context: result.context, count: count})
            return;
        }

        //data request
        for(var i=0; i<count; i++){
            res = result[i] || result;
            if(res.item){  //file

                //determine media type
                var media = res.file_urls.original
                var mType = mediaType(media)

                //for optimized loading, swith to fullsize derivative on image types
                if(mType === "image") {
                    media = res.file_urls.fullsize
                }

                requestComplete({item: res.item.id, context: result.context, media: media, thumb: res.file_urls.thumbnail, media_type: mType});
            }
            else if(res.element_texts){ //item
                requestComplete({item: res.id, context: result.context, metadata: res.element_texts, file_count: res.files.count, url: res.url});
            }
            else if(res.name){ //tag and search term
                requestComplete({item: res.id, context: result.context, tag: res.name});
            }
            else {
                emptyResult(result)
            }
        }
    }        

    /*! \qmlmethod
        Query specified page*/
    function getPage(page, context){
        submitRequest(rest+"items?page="+page, context);
        currentPage = page;
    }

    /*! \qmlmethod
        Query next page*/
    function getNextPage(context){
        currentPage++
        getPage(currentPage, context)
    }

    /*! \qmlmethod
        Query files of specified item*/
    function getFiles(id, context, api){
        var url = api || rest
        submitRequest(url+"files?item="+id, context);
    }

    /*! \qmlmethod
        Query repository tags*/
    function getTags(context){
        submitRequest(rest+"tags", context)
    }

    /*! \qmlmethod
        Query items by tag*/
    function getItemsByTag(tag, context) {
        submitRequest(rest+"items?tags="+encodeURIComponent(tag), context)
    }

    /*! \qmlmethod
        Query items by search term*/
    function getItemsByTerm(term, context) {
        submitRequest(rest+"items?search="+encodeURIComponent(term), context)
    }

    /*! \qmlmethod
        Query items by id*/
    function getItemById(id, context, api) {
        var url = api || rest
        submitRequest(url+"items/"+id, context)
    }    

    /*! \qmlmethod
        Get number of items with provided tag*/
    function getTaggedItemCount(tag, context) {
        submitRequest(rest+"items?tags="+encodeURIComponent(tag), context, true)
    }   

    /*! \qmlmethod
        Return media type of original file*/
    function mediaType(source) {
        if(imageExt.test(source))
            return "image"
        if(audioExt.test(source))
            return "audio"
        if(videoExt.test(source))
            return "video"
        return "image"
    }

    /*! \qmlmethod
        Returns formatted name derived from provided url*/
    function prettyName(url) {
        var host = qutils.getHost(url)
        host = host.substring(host.indexOf(".")+1, host.lastIndexOf("."))
        host = host.replace(".", "_")

        var path = qutils.getPath(url)
        path = path.replace(/\//g,'')

        var id = path ? host+"_"+path : host
        return id
    }
}
