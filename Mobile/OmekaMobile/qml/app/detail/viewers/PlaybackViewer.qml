import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../base"

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

}
