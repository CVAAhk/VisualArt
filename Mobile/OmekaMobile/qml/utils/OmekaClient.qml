pragma Singleton
import QtQuick 2.0
import "../app/home/gallery"

Item {
    /*! \qmlproperty
        Target omeka endpoint url
    */
    property url endpoint: "http://mallhistory.org/api/"    
    /*! \qmlproperty
        Current page number
    */
    property int currentPage: 0    
    /*! \qmlsignal
        Invoked on query result
    */
    signal resultComplete(var result)    
    /*! \internal
        Data object used to pair file and item data
    */
    property var data: ({})


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
        Collect corresponding item and file data. Send result when both data types
        have been paired.
    */
    function processResult(result){
        var res;

        for(var i=0; i<result.length; i++){
            res = result[i];           
            if(!res.item){  //item data
                data[res.id] = {id:res.id, metadata: res.element_texts};
                submitRequest(res.files.url);
            }
            else{   //file data
                data[res.item.id]["image"] = res.file_urls.original;
                data[res.item.id]["thumb"] = res.file_urls.thumb;
                resultComplete(data[res.item.id]);
                delete data[res.item.id];
            }
        }
    }

    /*! \qmlmethod
        Query specified page
    */
    function getPage(page){
        submitRequest(endpoint+"items?page="+page);
        currentPage = page;
    }

    /*! \qmlmethod
        Query next page
    */
    function getNextPage(){
        currentPage++
        getPage(currentPage)
    }
}
