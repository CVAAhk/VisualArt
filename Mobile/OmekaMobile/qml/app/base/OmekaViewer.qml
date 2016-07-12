import QtQuick 2.5
import QtQuick.Controls 1.4
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

    property alias fullscreen: button.checked

    Button {
        id: button
        scale: 1/viewer.scale
        width: childrenRect.width
        height: childrenRect.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        z: 1
        checkable: true

        Image {
            fillMode: Image.PreserveAspectFit
            source: Style.settingsIcon
            width: 50
        }
    }

}
