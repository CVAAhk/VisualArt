import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../../base"

/*!
  \qmltype PlaybackViewer

  PlaybackViewer provides the display and playback controls of audio and video content.
*/
OmekaViewer {

    id: root

    /*!
      \qmlproperty Item PlaybackViewer::background
      The display item of the viwer
    */
    property Item background

    /*!
      \qmlproperty MediaPlayer PlaybackViewer::player
      The player instance of the playable media
    */
    property MediaPlayer player

    //parenting
    Binding { target: background; property: "parent"; value: root }
    Binding { target: player; property: "parent"; value: root }

    //player settings
    Binding { target: player; property: "autoPlay"; value: true }
    Binding { target: player; property: "seekable"; value: true }
    Binding { target: player; property: "source"; value: root.source }

    //progress tracking
    ProgressTimer {
        id: timer
        player: root.player
        onProgressComplete: root.reset()
    }

    //on touch, toggle between play and pause states
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(player.playbackState === MediaPlayer.PlayingState)
                player.pause()
            else
                player.play()
        }
    }

    /*! \qmlmethod PlaybackViewer::reset()
        Pause media and reset playhead
    */
    function reset() {
        player.pause()
        player.seek(0)
        timer.reset()
    }
}
