import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import "."

/*!
  \qmltype ScrubberStyle

  ScrubberStyle is a custom appearance for the Scrubber control
*/
SliderStyle {

    //the background groove of the slider
    groove: Rectangle {
        implicitWidth: parent.width
        implicitHeight: 4//Resolution.applyScale(10)
        color: Style.color2

        //the background groove up to handle position
        Rectangle {
            height: parent.height
            width: styleData.handlePosition
            implicitHeight: parent.implicitHeight
            implicitWidth: parent.implicitWidth
            color: Style.color2
        }
    }

    //slider handle
    handle: Rectangle {
        anchors.centerIn: parent
        color: Style.color7
        implicitWidth: 7//Resolution.applyScale(60)
        implicitHeight: implicitWidth
        radius: width * .5
    }
}
