import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 470; height:800
    property int page: 0;
    property var view

    toolBar: ToolBar{
        Button{
            Text { id:txt; anchors.centerIn: parent }
            state: "gridLayout"
            states:[
                State { name: "gridLayout"
                    PropertyChanges { target: txt; text: "List" }
                    PropertyChanges { target: window; view: grid }
                    PropertyChanges { target: grid; model: model; enabled: true }
                    PropertyChanges { target: list; model: undefined; enabled: false }
                },
                State { name: "listLayout"
                    PropertyChanges { target: txt; text: "Grid" }
                    PropertyChanges { target: window; view: list }
                    PropertyChanges { target: grid; model: undefined; enabled: false }
                    PropertyChanges { target: list; model: model; enabled: true }
                }
            ]
            onClicked: {
                state = state === "gridLayout" ? "listLayout" : "gridLayout"
            }
        }
    }

    ListModel{
        id: model
    }

    Component{
        id: delegate
        Item{
            id: item
            width: grid.cellWidth - 5; height: grid.cellHeight - 5
            Column{
                Image{
                    id: image
                    source: thumb
                    //TODO: figure out how to resolve thread parenting issue
                    //asynchronous: true
                }
                Text { text: id }
            }
            MouseArea{
                anchors.fill: parent
                //onClicked: { console.log(id); }
            }
        }
    }

    GridView{
        id: grid
        anchors.fill: parent
        property int columns: width < height ? 2 : 3
        cellWidth: Math.floor(width/columns)
        cellHeight: Math.floor(width/columns)
        model: model
        delegate: delegate

        onAtYEndChanged: {
            if(grid.atYEnd){
                indicator.running = true
                page++;
                getData();
            }
        }
    }

    ListView{
        id: list
        anchors.fill: parent
        model: undefined
        delegate: delegate

        onAtYEndChanged: {
            if(list.atYEnd){
                indicator.running = true
                page++;
                getData();
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        visible: indicator.running
        id: box
        width: 50
        height: 50
        color: "powderblue"
        RotationAnimator on rotation {
            id: indicator
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
        }
    }

    function getData(){
        //console.log("load page: "+page)
        var request = new XMLHttpRequest();
        var url = "http://mallhistory.org/api/files?page="+page;
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    //console.log("Request Error: "+result.errors[0].message);
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
       // indicator.running = false;
        for(var i = 0; i<json.length; i++){
            var url = "image://testprovider/"+json[i].file_urls.thumbnail;
            view.model.append({id: json[i].id, thumb: url});
        }
    }
}
