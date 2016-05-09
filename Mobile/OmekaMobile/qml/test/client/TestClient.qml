import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 470; height:800

    Component.onCompleted: getData()

    ListModel{
        id: model
    }

    Component{
        id: delegate
        Image{
            id: item
            source: thumb
            MouseArea{
                anchors.fill: parent
                onClicked: { console.log(id); }
            }
            onStatusChanged: {
                if(status == Image.Ready)
                    indicator.running = false;
            }
        }
    }

    ListView{
        id: view
        anchors.fill: parent
        model: model
        delegate: delegate
    }

    BusyIndicator{
        id: indicator
        anchors.centerIn: parent
        running: false
    }

    function getData(){
        var request = new XMLHttpRequest();
        var url = "http://mallhistory.org/api/files?page=10";
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    updateView(result);
                }
            }
        }
        request.open("GET", url);
        request.send();
    }

    function updateView(json){
        for(var i = 0; i<json.length; i++){
            indicator.running = true;
            var url = "image://testprovider/"+json[i].file_urls.thumbnail;
            view.model.append({id: json[i].id, thumb: url});
        }
    }
}
