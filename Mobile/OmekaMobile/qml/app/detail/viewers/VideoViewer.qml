import QtQuick 2.5
import QtMultimedia 5.5
import "../../base"

/*
  \qmltype VideoViewer

  VideoViewer provides video view and playback controls.
*/
PlaybackViewer {
    id: root
    height: output.height
    sourceWidth: output.contentRect.width

    //video output
    background: VideoOutput {        
        id: output
        width: parent.width
        fillMode: VideoOutput.PreserveAspectFit
        source: player
    }

    //video player
    player: MediaPlayer { }
}
