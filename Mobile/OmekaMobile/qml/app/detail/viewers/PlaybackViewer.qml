import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../base"
import "../../../utils"

/*!
  \qmltype PlaybackViewer

  PlaybackViewer provides the display and media player of audio and video content.
*/
OmekaViewer {
    id: root     
    objectName: "playbackViewer"

    /*!
      \qmlproperty MediaPlayer PlaybackViewer::player
      The player instance of the playable media
    */
    property MediaPlayer player

    //player settings
    Binding { target: player; property: "autoPlay"; value: true }
    Binding { target: player; property: "seekable"; value: true }
    Binding { target: player; property: "source"; value: root.source }
}
