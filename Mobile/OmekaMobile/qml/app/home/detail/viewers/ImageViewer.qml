import QtQuick 2.5
import "../../../base"

OmekaViewer {
    id: root
    width: parent.width
    height: img.height
    sourceWidth: img.sourceSize.width

    Image{
        id: img
        width: parent.width
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: root.source
    }
}
