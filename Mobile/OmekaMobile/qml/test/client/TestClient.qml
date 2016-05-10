import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 470; height:800
    property int page: 1;

    Component.onCompleted: getData(page)

    ListModel{
        id: model
    }

    Component{
        id: delegate
        Item{
            id: item
            width: view.cellWidth - 5; height: view.cellHeight - 5
            Column{
                Image{
                    id: image
                    source: thumb
                }
                Text { text: id }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: { console.log(id); }
            }
        }
    }

    GridView{
        id: view
        anchors.fill: parent
        property int columns: width < height ? 2 : 3
        cellWidth: Math.floor(width/columns)
        cellHeight: Math.floor(width/columns)
        model: model
        delegate: delegate

        onAtYEndChanged: {
            if(view.atYEnd){
                indicator.running = true
                page++;
                console.log("load page: "+page)
                getData(page);
            }
        }
    }

    BusyIndicator{
        id:indicator
        anchors.centerIn: parent
        anchors.bottom: parent.bottom
        running: false;
    }

    function getData(page){
        var request = new XMLHttpRequest();
        var url = "http://mallhistory.org/api/files?page="+page;
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
        indicator.running = false;
        for(var i = 0; i<json.length; i++){
            var url = "image://testprovider/"+json[i].file_urls.thumbnail;
            view.model.append({id: json[i].id, thumb: url});
        }
    }
}
