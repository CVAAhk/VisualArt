import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../../utils"

/*!
   \qmltype OmekaViewer

   OmekaViewer is the base class for the various omeka media types.
  */
Item {
    id: root
    visible: false
    enabled: false
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width

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
        \qmlproperty real OmekaViewer::sourceHeight
        Actual height of source file
    */
    property real sourceHeight: height

    /*!
        \qmlproperty real OmekaViewer::fullScreen
        Enables full screen state of media object
    */
    property alias fullScreen: button.checked

    /*!
      \qmlproperty Item OmekaViewer::background
      The display item of the viwer
    */
    property Item background

    /*!
      \qmlproperty Item OmekaViewer::portrait
      Indicates portrait orientation when true and landscape otherwise
    */
    property bool portrait: Resolution.portrait

    //update orientation
    onSourceChanged: setOrientation()
    onPortraitChanged: setOrientation()

    //parenting
    Binding { target: background; property: "parent"; value: root }

    //full screen mode toggle
    OmekaToggle {
        id: button
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        defaultSource: Style.maximize
        checkedSource: Style.minimize
        scale: 1/viewer.scale
        iconScale: .5
        z: 1
    }

    //orientation states
    states: [
        State {
            name: "portrait"
            when: background
            PropertyChanges { target: background; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: background.height }
        },
        State {
            name: "landscape"
            when: background
            PropertyChanges { target: background; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: background.width; height: Resolution.appHeight *.8}
        }
    ]

    //update device orientation
    function setOrientation() {
        state = portrait ? "portrait" : "landscape"
    }
}
