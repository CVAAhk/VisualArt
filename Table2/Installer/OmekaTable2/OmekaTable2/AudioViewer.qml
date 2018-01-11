import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "."

/*
  \qmltype AudioViewer

  AudioViewer provides audio view and playback controls.
*/
PlaybackViewer {
    id: root
    player: MediaPlayer {}
}
