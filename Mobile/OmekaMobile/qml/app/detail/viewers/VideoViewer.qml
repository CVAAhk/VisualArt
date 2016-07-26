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
    objectName: "visualPlaybackViewer"
    sourceWidth: output.contentRect.width
    sourceHeight: output.contentRect.height

    //video output
    display: VideoOutput {        
        id: output
        fillMode: VideoOutput.PreserveAspectFit
        source: player
    }

    //video player
    player: MediaPlayer { }
}
