pragma Singleton
import QtQuick 2.0

Item {
    /*! \qmlproperty
        Target omeka endpoint url
    */
    //property url endpoint: "http://mallhistory.org/api/"
    property url endpoint: "http://dev.omeka.org/mallcopy/api/"

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


    /*! \internal */
    function submitRequest(url, context){
        var request = new XMLHttpRequest();
        request.context = context;
        request.onreadystatechange = onResponse(request);
        request.open("GET", url, true);
        request.send();
    }

    /*! \internal */
    function onResponse(request){
        return function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    print("Request Error: "+result.errors[0].message);
                }
                else{
                    result.context = request.context;
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

        for(var i=0; i<count; i++){
            res = result[i] || result;
            if(res.item){  //file
                requestComplete({item: res.item.id, context: result.context, media: res.file_urls.original, thumb: res.file_urls.fullsize, media_type: mediaType(res.file_urls.original)});
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
        submitRequest(endpoint+"items?page="+page, context);
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
        submitRequest(endpoint+"files?item="+id, context);
    }

    /*! \qmlmethod
        Query repository tags*/
    function getTags(context){
        submitRequest(endpoint+"tags", context)
    }

    /*! \qmlmethod
        Query items by tag*/
    function getItemsByTag(tag, context) {
        submitRequest(endpoint+"items?tags="+tag, context)
    }

    /*! \qmlmethod
        Query items by id*/
    function getItemById(id, context) {
        submitRequest(endpoint+"items/"+id, context)
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
    }
}
