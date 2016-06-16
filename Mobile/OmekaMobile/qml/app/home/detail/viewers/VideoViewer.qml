import QtQuick 2.5
import "../../../base"

OmekaViewer {
    id: root
    width: parent.width
    height: video.height
    sourceWidth: width

    Rectangle {
        id: video
        width: parent.width
        height: 500
        color: "black"
        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Video: "+root.source
        }
    }
}
