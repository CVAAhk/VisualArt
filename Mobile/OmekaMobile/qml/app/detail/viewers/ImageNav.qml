import QtQuick 2.0
import "../../../utils"

ListView{
    id: list

    property real sourceWidth: currentItem ? currentItem.sourceSize.width : 0
    property real sourceHeight: currentItem ? currentItem.sourceSize.height : 0
    property var imageWidth
    property var imageHeight

    width: imageWidth ? imageWidth : currentItem.width
    height: imageHeight ? imageHeight : currentItem.height

    orientation: ListView.Horizontal
    snapMode: ListView.SnapOneItem
    cacheBuffer: width*model.count
    interactive: model.count > 1
    clip: true
    spacing: Resolution.applyScale(90)
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: currentItem ? width/2 - currentItem.width/2 : 0
    preferredHighlightEnd: currentItem ? width/2 + currentItem.width/2: 0

    model: ListModel {}
    delegate: Image {
        anchors.verticalCenter: parent.verticalCenter
        width: list.imageWidth
        height: list.imageHeight
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: src
    }

    function setImages(images) {
        list.model.clear();
        for(var i=0; i<images.length; i++) {
            list.model.append({src:images[i]})
        }
    }        
}
