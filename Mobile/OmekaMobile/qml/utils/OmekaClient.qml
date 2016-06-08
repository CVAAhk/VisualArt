pragma Singleton
import QtQuick 2.0
import "../app/home/gallery"

Item {
    /*! Target omeka endpoint url */
    property url endpoint: "http://mallhistory.org/api/"
    /*! Current page number */
    property int currentPage: 0
    /*! Invoked on query result */
    signal resultComplete(var result)
    /*! \internal */
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

    /*! \internal */
    function processResult(result){
        var res;
        var id;

        for(var i=0; i<result.length; i++){
            res = result[i];
            id = res.files !== undefined ? res.id : res.item.id;

            //store item and corresponding file data
            if(data.hasOwnProperty(id)){
                data[id].push(res);
                resultComplete(data[id]);
                delete data[id];
            }
            else{
                data[id] = [res];
            }
        }
    }

    /*! Query specified page */
    function getPage(page){
        submitRequest(endpoint+"files?page="+page);
        submitRequest(endpoint+"items?page="+page);
        currentPage = page;
    }

    /*! Query next page */
    function getNextPage(){
        currentPage++
        getPage(currentPage)
    }
}
