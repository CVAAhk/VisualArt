import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "../../../styles"
import "../../../../utils"

/*!
  \qmltype Scrubber

  Scrubber is a control that displays playback progress and also enables media seeking
  by dragging the slider handle.
*/
Slider {

    id: scrubber

    //position and sizing
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width: parent.width - Resolution.applyScale(300)

    //draw on top of media
    z: 1

    //set max value to the number timer ticks
    maximumValue: timer.totalTicks

    /*!
      \qmlproperty MediaPlayer Scrubber::player
      The media player to track
    */
    property MediaPlayer player

    //sync scrubber position with playhead
    Binding { target: scrubber; property: "value"; when: !scrubber.pressed; value: timer.tick }

    //sync media with scrubber position
    onValueChanged: scrubber.scrub()

    //progress timer instance
    ProgressTimer {
        id: timer
        player: scrubber.player
        onProgressComplete: reset()
    }

    //custom style
    style: ScrubberStyle {}

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
        scrubber.player.seek(tick*timer.interval)
    }

    /*! \internal
        Sync player with scrubber position
    */
    function scrub() {
        if(scrubber.pressed){
            seek(scrubber.value)
        }
    }
}
