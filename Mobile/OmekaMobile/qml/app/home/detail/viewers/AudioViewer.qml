import QtQuick 2.5
import "../../../base"

OmekaViewer {
    id: root
    width: parent.width
    height: audio.height
    sourceWidth: width

    Rectangle {
        id: audio
        width: parent.width
        height: 500
        color: "black"
        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Audio: "+root.source
        }
    }
}
