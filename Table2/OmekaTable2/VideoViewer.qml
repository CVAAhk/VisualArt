import QtQuick 2.5
import QtMultimedia 5.5
import "."


/*
  \qmltype VideoViewer

  VideoViewer provides video view and playback controls.
*/
PlaybackViewer {
    id: root
    sourceWidth: output.contentRect.width
    sourceHeight: output.contentRect.height

    //video output
    display: Item {

        width: output.width
        height: output.height

        property alias displayWidth: output.width
        property alias displayHeight: output.height

        VideoOutput {
            id: output
            fillMode: VideoOutput.PreserveAspectFit
            source: player
        }
    }

    //video player
    player: MediaPlayer { }
}
