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
    visible: player !== undefined

    //position and sizing
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.margins: 10
    width: parent.width - Resolution.applyScale(300)

    //set max value to the number timer ticks
    maximumValue: timer.totalTicks

    /*!
      \qmlproperty Scrubber::player
      The media player to track
    */
    property var player

    //sync scrubber position with playhead
    Binding { target: scrubber; property: "value"; when: !scrubber.pressed; value: timer.tick }

    //sync media with scrubber position
    onValueChanged: scrubber.scrub()

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
    function scrub() {
        if(scrubber.pressed){
            seek(scrubber.value)
        }
    }
}
