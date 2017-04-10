pragma Singleton
import QtQuick 2.0

Item {
    /*! \qmlproperty
        Target omeka endpoint url
    */
    property url endpoint: "http://dev.omeka.org/mallcopy/"

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

    /* Initialize heist*/
   // Component.onCompleted: heist.initialize(rest+"heist?pairing_id=1245");


    /*! \internal
      Sends http request and links response handler
      \a url - omeka rest api call
      \a context - calling object instance
      \a count - flags the query as a simple count request
    */
    function submitRequest(url, context, count){
        var request = new XMLHttpRequest();
        request.context = context;
        request.count = count
        request.onreadystatechange = onResponse(request);
        request.open("GET", url, true);
        request.send();
    }

    /*! \internal */
    function onResponse(request) {
        return function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    print("Request Error: "+result.errors[0].message);
                }
                else{
                    result.context = request.context;
                    result.count = request.count;
                    processResult(result);
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
                requestComplete({item: res.item.id, context: result.context, media: res.file_urls.original, thumb: res.file_urls.thumbnail, media_type: mediaType(res.file_urls.original)});
            }
            else if(res.element_texts){ //item
                requestComplete({item: res.id, context: result.context, metadata: res.element_texts, file_count: res.files.count});
            }
            else{ //tag
                requestComplete({item: res.id, context: result.context, tag: res.name});
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
    function getFiles(id, context){
        submitRequest(rest+"files?item="+id, context);
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
    function getItemById(id, context) {
        submitRequest(rest+"items/"+id, context)
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
            return "image";
        if(audioExt.test(source))
            return "audio"
        if(videoExt.test(source))
            return "video"
        return "image"
    }
}
