import QtQuick 2.5
import QtQuick.Controls 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 470; height:800

    property url query: "http://oe.develop.digitalmediauconn.org/api/files?page="
    property real max_width: 0
    property real max_height: 0
    property var imageExt: /\.(jpe?g|png|gif)$/i
    property int pageNumber: 1
    property int loadCount: 0

    Component.onCompleted: {
        getFilesByPage(pageNumber);
    }

    function getFilesByPage(page) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = onResult(request);
        request.open('GET', query+page, true);
        request.send();
    }

    function onResult(request) {
        return function() {
            if(request.readyState === XMLHttpRequest.DONE) {
                if(!request.responseText) {
                    return;
                }
                var result = JSON.parse(request.responseText);
                if(result.errors !== undefined) {
                    print("Request Error: "+result.errors[0].message);
                }
                else {
                    for(var i=0; i< result.length; i++) {
                        var item = result[i];
                        var source = item.file_urls.original
                        if(imageExt.test(source)) {
                            loadCount++
                            repeater.model.append({itemId: item.item.id, src: source})
                        }
                    }
                }
            }
        }
    }

    Item {
        visible: false
        Repeater {
            id: repeater
            delegate: Image {
                property var item: itemId
                source: src
                onStatusChanged: {
                    if(status === Image.Ready) {
                        if(sourceSize.width > window.max_width) {
                            window.max_width = sourceSize.width
                            print("Largest Width: "+itemId+" "+source+" "+sourceSize.width)
                        }
                        if(sourceSize.height > window.max_height) {
                            window.max_height = sourceSize.height
                            print("Largest Height: "+itemId+" "+source+" "+sourceSize.height)
                        }
                        loadCount--
                        if(loadCount === 0) {
                            print("COMPLETE: "+pageNumber)
                            pageNumber++
                            getFilesByPage(pageNumber)
                        }
                    }
                }
            }
            model: ListModel {}
        }
    }
}
