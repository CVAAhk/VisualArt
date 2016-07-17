import QtQuick 2.5
import QtMultimedia 5.5
import "../../base"
import "../../../utils"

/*
  \qmltype VideoViewer

  VideoViewer provides video view and playback controls.
*/
PlaybackViewer {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    sourceWidth: output.contentRect.width
    sourceHeight: output.contentRect.height

    property bool portrait: Resolution.portrait

    Component.onCompleted: setOrientation()
    onPortraitChanged: setOrientation()

    //video output
    background: VideoOutput {        
        id: output
        fillMode: VideoOutput.PreserveAspectFit
        source: player
    }

    //video player
    player: MediaPlayer { }

    states: [
        State {
            name: "portrait"
            PropertyChanges { target: output; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: output.height }
        },
        State {
            name: "landscape"
            PropertyChanges { target: output; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: output.width; height: Resolution.appHeight * .8 }
        }
    ]

    function setOrientation() {
        state = portrait ? "portrait" : "landscape"
    }
}
