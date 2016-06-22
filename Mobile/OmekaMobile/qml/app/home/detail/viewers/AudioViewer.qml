import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5

/*
  \qmltype AudioViewer

  AudioViewer provides audio view and playback controls.
*/
PlaybackViewer {

    background: Rectangle {
        anchors.fill: parent
        color: "black"
    }

    player: MediaPlayer {}
}
