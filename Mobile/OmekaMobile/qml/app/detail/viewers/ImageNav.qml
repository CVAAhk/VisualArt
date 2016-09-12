import QtQuick 2.0

ListView{
    id: list

    property real sourceWidth: currentItem ? currentItem.sourceSize.width : 0
    property real sourceHeight: currentItem ? currentItem.sourceSize.height : 0
    property var imageWidth
    property var imageHeight

    model: ListModel {}

    delegate: Image {
        width: list.imageWidth
        height: list.imageHeight
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: src
        onWidthChanged: list.width = width
        onHeightChanged: list.height = height
    }

    function setImages(images) {
        list.model.clear();
        list.model.append({src:images[0]})
    }

}
