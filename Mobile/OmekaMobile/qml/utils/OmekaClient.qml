pragma Singleton
import QtQuick 2.0

Item {
    /*! \qmlproperty
        Target omeka endpoint url*/
    property url endpoint: "http://mallhistory.org/api/"    
    /*! \qmlproperty
        Current page number*/
    property int currentPage: 0
    /*! \qmlsignal
        Invoked on query result*/
    signal requestComplete(var result)

    //data types
    property int file: 0
    property int metadata: 1
    property int tag: 2


    /*! \internal */
    function submitRequest(url){
        var request = new XMLHttpRequest();
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
            if(res.item){
                requestComplete({item: res.item.id, type: file, image: res.file_urls.original, full: res.file_urls.fullsize});
            }
            else if(res.element_texts){
                requestComplete({item: res.id, type: metadata, metadata: res.element_texts});
            }
            else{
                requestComplete({item: res.id, type: tag, tag: res.name});
            }
        }
    }

    /*! \qmlmethod
        Query specified page*/
    function getPage(page){
        submitRequest(endpoint+"files?page="+page);
        currentPage = page;
    }

    /*! \qmlmethod
        Query next page*/
    function getNextPage(){
        currentPage++
        getPage(currentPage)
    }

    /*! \qmlmethod
        Query meta data of specified item*/
    function getMetaData(id){
        submitRequest(endpoint+"items/"+id);
    }

    function getTags(){
        submitRequest(endpoint+"tags")
    }
}
