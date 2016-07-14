import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../../utils"

/*!
   \qmltype OmekaViewer

   OmekaViewer is the base class for the various omeka media types.
  */
Item {
    visible: false
    enabled: false
    width: parent.width
    height: Resolution.applyScale(Resolution.targetHeight*.3)

    /*!
        \qmlproperty url OmekaViewer::source
        File url of media item
    */
    property url source

    /*!
        \qmlproperty real OmekaViewer::sourceWidth
        Actual width of source file
    */
    property real sourceWidth: width

    /*!
        \qmlproperty real OmekaViewer::fullScreen
        Enables full screen state of media object
    */
    property alias fullScreen: button.checked

    //full screen mode toggle
    OmekaToggle {
        id: button
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        defaultSource: Style.settingsIcon
        checkedSource: Style.more
        scale: 1/viewer.scale
        iconScale: .15
        z: 1
    }
}
