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
    height: background.height

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
      \qmlproperty Item OmekaViewer::display
      The display item of the viwer
    */
    property Item display

    /*!
      \qmlproperty Item OmekaViewer::portrait
      Indicates portrait orientation when true and landscape otherwise
    */
    property bool portrait: Resolution.portrait

    //update orientation
    onSourceChanged: setOrientation()
    onPortraitChanged: setOrientation()

    //bindings
    Binding { target: display; property: "parent"; value: root }
    Binding { target: background; property: "visible"; when: display; value: !portrait }

    //background
    Rectangle {
        id: background
        color: "black"
        anchors.centerIn: parent
        width: viewer.width
        height: portrait ? Resolution.appHeight * .3 : Resolution.appHeight * .8
        scale: 1/viewer.scale
    }

    //full screen mode toggle control
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
            PropertyChanges { target: display; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: display.height }
        },
        State {
            name: "landscape"
            PropertyChanges { target: display; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: display.width; height: Resolution.appHeight *.8}
        }
    ]

    //update device orientation
    function setOrientation() {
        if(!display) return
        state = portrait ? "portrait" : "landscape"
    }
}
