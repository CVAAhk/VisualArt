import QtQuick 2.5
import "../../../base"

/*
  \qmltype VideoViewer

  VideoViewer provides video view and playback controls.
*/
OmekaViewer {
    id: root
    width: parent.width
    height: video.height
    sourceWidth: width

    //video element
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
