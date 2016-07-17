import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../base"
import "../../../utils"

/*!
  \qmltype PlaybackViewer

  PlaybackViewer provides the display and playback controls of audio and video content.
*/
OmekaViewer {
    id: root

    /*!
      \qmlproperty MediaPlayer PlaybackViewer::player
      The player instance of the playable media
    */
    property MediaPlayer player

    //parenting
    Binding { target: player; property: "parent"; value: root }

    //player settings
    Binding { target: player; property: "autoPlay"; value: true }
    Binding { target: player; property: "seekable"; value: true }
    Binding { target: player; property: "source"; value: root.source }

    //playback scrubbing
    Scrubber {
        id: scrubber
        player: root.player
        scale: 1/viewer.scale
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
}
