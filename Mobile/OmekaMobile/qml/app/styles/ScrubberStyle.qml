import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import "../../utils"

/*!
  \qmltype ScrubberStyle

  ScrubberStyle is a custom appearance for the Scrubber control
*/
SliderStyle {

    //the background groove of the slider
    groove: Rectangle {
        implicitWidth: parent.width
        implicitHeight: Resolution.applyScale(8)
        color: Style.scrubberGrooveColor

        //the background groove up to handle position
        Rectangle {
            height: parent.height
            width: styleData.handlePosition
            implicitHeight: parent.implicitHeight
            implicitWidth: parent.implicitWidth
            color: Style.scrubberGroovePositionColor
        }
    }

    //slider handle
    handle: Rectangle {
        anchors.centerIn: parent
        color: Style.scrubberHandleColor
        implicitWidth: Resolution.applyScale(50)
        implicitHeight: implicitWidth
        radius: width * .5
    }
}
