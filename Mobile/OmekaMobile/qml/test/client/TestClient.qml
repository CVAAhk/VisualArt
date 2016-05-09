import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 470; height:800

    ListModel{
        id: model
    }

    ListView{
        id: view
        anchors.fill: parent
        model: model
        delegate: Text{
            text: jsondata
        }
    }

    Button{
        anchors.bottom: parent.bottom
        width: parent.width
        text: "SUBMIT REQUEST"
        onClicked: getData()
    }

    function getData(){
        var request = new XMLHttpRequest();
        var url = "http://mallhistory.org/api/items";
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    updateView(result)
                }
            }
        }
        request.open("GET", url);
        request.send();
    }

    function updateView(json){
        for(var i = 0; i<json.length; i++){
            console.log(json[i].id);
            view.model.append({jsondata: json[i].id});
        }
    }
}
