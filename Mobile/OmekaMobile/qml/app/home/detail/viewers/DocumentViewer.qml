import QtQuick 2.5
import "../../../base"

OmekaViewer {
    id: root
    width: parent.width
    height: document.height
    sourceWidth: width

    Rectangle {
        id: document
        width: parent.width
        height: 500
        color: "black"
        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Document: "+root.source
        }
    }
}
