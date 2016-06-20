import QtQuick 2.5
import "../../../base"

/*
  \qmltype AudioViewer

  AudioViewer provides audio view and playback controls.
*/
OmekaViewer {
    id: root
    width: parent.width
    height: audio.height
    sourceWidth: width

    //audio element
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
