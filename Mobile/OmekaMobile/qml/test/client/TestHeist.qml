import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800

    property var entry_id;
    property var _pairId: "1245";

    Component.onCompleted: {
        timer.start()
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onReturnPressed: removeData()

        Timer {
            id: timer
            interval: 1000
            repeat: true
            running: true
            onTriggered: getData()
        }

        Text {
            id: output
            anchors.centerIn: parent
        }
    }

    //get entry
    function getData(){
        var url = "http://dev.omeka.org/mallcopy/api/heist?pairing_id="+_pairId;

        var request = new XMLHttpRequest();
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    output.text = result.errors[0].message;
                }
                else{
                    entry_id = result[0] ? result[0].id : undefined
                    output.text = entry_id ? entry_id : "polling..."
                }
            }
        }

        request.open("GET", url);
        request.send();
    }

    //create entry
    function postData() {
        var url = "http://dev.omeka.org/mallcopy/api/heist";

        var data = {};
        data.pairing_id = window._pairId
        data.device_id = "1234"
        data.item_ids = [88,3,556]
        var json = JSON.stringify(data);

        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    console.log("Successful Add")
                }
            }
        }

        request.open("POST", url, true);
        request.setRequestHeader('Content-type','application/json');
        request.send(json);
    }

    //update entry
    function putData() {
        var url = "http://dev.omeka.org/mallcopy/api/heist/1";

        var data = {}
        data.pairing_id = "6898"
        data.device_id = ""
        data.item_ids = [55,66,77]
        var json = JSON.stringify(data);

        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    console.log("Successful Update")
                }
            }
        }

        request.open("PUT", url, true);
        request.setRequestHeader('Content-type','application/json');
        request.send(json);

    }

    //delete entry
    function removeData() {

        var url = "http://dev.omeka.org/mallcopy/api/heist/"+entry_id;

        var request = new XMLHttpRequest();
        request.open("DELETE", url, true);
        request.send(null);

    }    
}
