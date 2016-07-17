import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../../utils"

/*
  \qmltype AudioViewer

  AudioViewer provides audio view and playback controls.
*/
PlaybackViewer {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter

    property bool portrait: Resolution.portrait

    Component.onCompleted: setOrientation()
    onPortraitChanged: setOrientation()

    background: Rectangle {
        id: content
        anchors.fill: parent
        color: "black"
    }

    player: MediaPlayer {}

    states: [
        State {
            name: "portrait"
            PropertyChanges { target: root; height: Resolution.applyScale(Resolution.targetHeight*.3) }
        },
        State {
            name: "landscape"
            PropertyChanges { target: root; height: Resolution.appHeight * .8 }
        }

    ]

    function setOrientation() {
        state = portrait ? "portrait" : "landscape"
    }
}
