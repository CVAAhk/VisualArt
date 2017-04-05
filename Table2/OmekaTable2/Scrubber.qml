import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "."


/*!
  \qmltype Scrubber

  Scrubber is a control that displays playback progress and also enables media seeking
  by dragging the slider handle.
*/
Item {

    visible: player !== undefined
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.margins: 10//Resolution.applyScale(36)

    property alias player: scrubber.player

    property alias pressed: area.pressed


    PlaybackText {
        id: elapsed
        anchors.right: scrubber.left
        time: timer.position
    }

    PlaybackText {
        id: duration
        anchors.left: scrubber.right
        time: timer.duration
    }

    Slider {

        id: scrubber

        //position and sizing
        anchors.centerIn: parent
        width: parent.width - 30//Resolution.applyScale(300)

        //set max value to the number timer ticks
        maximumValue: timer.totalTicks

        /*!
          \qmlproperty Scrubber::player
          The media player to track
        */
        property var player

        /*!
          \qmlproperty Scrubber::player
          Playback is paused by scrubbing
        */
        property bool scrubPause: false

        //sync scrubber position with playhead
        Binding { target: scrubber; property: "value"; when: !area.pressed; value: timer.tick }

        //progress timer instance
        ProgressTimer {
            id: timer
            onProgressComplete: reset()
        }

        //custom style
        style: ScrubberStyle {}

        //stop/start progress based on visiblity
        onVisibleChanged: {
            if(visible) {
                timer.player = scrubber.player
            }
            else {
                reset()
            }
        }

        //interactive area
        MouseArea{
            id: area
            anchors.centerIn: parent
            width: parent.width
            height: parent.height*2
            onPressed: {
                scrubber.scrubPause = player.playbackState !== MediaPlayer.PausedState
                scrubber.scrub(mouseX)
            }
            onReleased: {
                if(scrubber.scrubPause){
                    player.play()
                }
            }
            onPositionChanged: scrubber.scrub(mouseX)
        }

        /*! \qmlmethod Scrubber::reset()
            Pause media and reset playhead
        */
        function reset() {
            timer.reset()
            scrubber.seek(0)
        }

        /*! \qmlmethod Scrubber::seek(tick)
            Seek timer and player to specified tick
        */
        function seek(tick) {
            timer.seek(tick)
            if(scrubber.player) scrubber.player.seek(tick*timer.interval)
        }

        /*! \internal
            Sync player with scrubber position
        */
        function scrub(mouseX) {
            player.pause()
            value = NumberUtils.map(mouseX, 0, width, 0, maximumValue)
            seek(value)
        }
    }
}
