import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    visible: true
    width: 470; height:800
    property real item: 2

    Component.onCompleted: {
        getData("http://mallhistory.org/api/items/"+item)
    }

    Flickable{
        id: flick
        anchors.fill: parent
        contentWidth: 500
        contentHeight: 500

        Column{
            anchors.fill: parent

            PinchArea{
                id: zoom
                width: flick.contentWidth
                height: flick.contentHeight

                property real initialWidth
                property real initialHeight
                property real scaledWidth
                property real scaledHeight

                onPinchStarted: {
                    initialWidth = flick.contentWidth
                    initialHeight = flick.contentHeight
                }

                onPinchUpdated: {
                    flick.contentX += pinch.previousCenter.x - pinch.center.x;
                    flick.contentY += pinch.previousCenter.y - pinch.center.y;
                    scaledWidth = clamp(initialWidth * pinch.scale, 500, 5000);
                    scaledHeight = clamp(initialHeight * pinch.scale, 500, 5000);
                    flick.resizeContent(scaledWidth, scaledHeight, pinch.center)
                }

                onPinchFinished: {
                    flick.returnToBounds()
                }

                Rectangle{
                    width: flick.contentWidth
                    height: flick.contentHeight
                    color: "white"
                    Image{
                        id:image
                        anchors.fill: parent
                        MouseArea{
                            anchors.fill: parent
                        }
                    }
                }
            }

            TextArea{
                id: info
                width: 470
                height: 300
                textFormat: TextEdit.RichText
                font.pointSize: 10
            }
        }

    }

    Button{
        id: button
        state: "FULL"

        states: [
            State{
                name: "FULL"
                PropertyChanges { target: button; text: "FULL" }
                PropertyChanges { target: zoom; enabled: false }
                PropertyChanges { target: flick; contentWidth: 500; contentHeight: 500 }
                PropertyChanges { target: info; visible: true }
            },
            State{
                name: "MIN"
                PropertyChanges { target: button; text: "MIN" }
                PropertyChanges { target: zoom; enabled: true }
                PropertyChanges { target: flick; contentWidth: 500; contentHeight: 500 }
                PropertyChanges { target: info; visible: false }
            }
        ]

        onClicked: {
            state = state === "FULL" ? "MIN" : "FULL"
        }
    }

    function clamp(value, min, max){
        return value < min ? min : value > max ? max : value;
    }

    function getData(url){
        var request = new XMLHttpRequest();
        request.onreadystatechange = function(){
            if(request.readyState === XMLHttpRequest.DONE){
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined){
                    console.log("Request Error: "+result.errors[0].message);
                }
                else{
                    if(result.files !== undefined){
                        setMetaData(result)
                        getData(result.files.url); //get image file
                    }
                    else{
                        image.source = result[0].file_urls.original
                    }
                }
            }
        }
        request.open("GET", url);
        request.send();
    }

    function setMetaData(result){
        var element;
        var metadata = "";
        for(var i = 0; i<result.element_texts.length; i++){
            element = result.element_texts[i];
            metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
        }
        info.text = metadata
    }
}
