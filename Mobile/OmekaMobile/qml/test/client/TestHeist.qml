import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow {
    id: window
    visible: true
    width: 470; height: 800

    Component.onCompleted: postData()

    function getData(){
        var url = "http://dev.omeka.org/mallcopy/api/heist?pairing_id=7891";

        var request = new XMLHttpRequest();
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    console.log(result[0].item_ids.length)
                }
            }
        }

        request.open("GET", url);
        request.send();
    }

    function postData() {
        var url = "http://dev.omeka.org/mallcopy/api/heist";

        var data = {};
        data.pairing_id = "7788"
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
                    console.log("Successful Post")
                }
            }
        }

        request.open("POST", url, true);
        request.setRequestHeader('Content-type','application/json');
        request.send(json);
    }

}
