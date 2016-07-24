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
    objectName: "defaultViewer"
    visible: false
    enabled: false
    anchors.centerIn: parent
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
      \qmlproperty Item OmekaViewer::display
      The display item of the viwer
    */
    property Item display

    /*!
      \qmlproperty Item OmekaViewer::portrait
      Indicates portrait orientation when true and landscape otherwise
    */
    property bool portrait: Resolution.portrait

    /*!
      \qmlproperty Item OmekaViewer::fullScreen
      Indicates item is in maximized state
    */
    property bool fullScreen: ItemManager.fullScreen

    /*!
      \qmlproperty Item OmekaViewer::angle
      The intended angle of rotation
    */
    property real angle: 0

    /*!
      \qmlproperty Item OmekaViewer::background
      Reference to background graphic
    */
    property alias background: background

    /*!
      \internal
      The scale required to fill width of parent in portrait orientation
    */
    property real wScale: viewer.width > sourceWidth ? viewer.width / sourceWidth : 1

    /*!
      \internal
      The scale required to fill height of parent in landscape orientation
    */
    property real hScale: viewer.height > sourceHeight ? viewer.height / sourceHeight : 1

    /*!
      \qmlproperty Item OmekaViewer::fillScale
      The scale required to fill parent while preserving aspect ratio
    */
    property real fillScale: portrait ? wScale : hScale

    //bindings
    Binding { target: display; property: "parent"; value: root }

    //background
    Rectangle {
        id: background
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        width: viewer.width
        scale: 1/viewer.scale
        y: fullScreen ? 0 : viewer.height/2 - height/2
    }

    //orientation states
    states: [
        State {
            name: "portrait"
            PropertyChanges { target: background; height: Resolution.appHeight * .3 }
        },
        State {
            name: "landscape"
            PropertyChanges { target: background; height: Resolution.appHeight * .8 }
        },
        State {
            name: "portrait_display"
            extend: "portrait"
            PropertyChanges { target: display; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: display.height }
        },
        State {
            name: "landscape_display"
            extend: "landscape"
            PropertyChanges { target: display; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: display.width; height: Resolution.appHeight *.8}
        },
        State {
            name: "portrait_fullscreen"
            extend: "portrait_display"
            PropertyChanges { target: background; height: Resolution.appHeight }
        },
        State {
            name: "landscape_fullscreen"
            extend: "landscape_display"
            PropertyChanges { target: background; height: Resolution.appHeight }
            PropertyChanges { target: root; explicit: true; fillScale: 1 }
        },
        State {
            name: "portrait_playback"
            extend: "portrait_fullscreen"
            PropertyChanges { target: root; explicit: true; angle: 90 }
        },
        State {
            name: "landscape_playback"
            extend: "landscape_fullscreen"
        }
    ]

    onSourceChanged: orientationStates()
    onPortraitChanged: orientationStates()
    function orientationStates() {
        if(fullScreen) return
        if(display) {
            state = portrait ? "portrait_display" : "landscape_display"
        } else {
            state = portrait ? "portrait" : "landscape"
        }
    }

    onFullScreenChanged: screenStates()
    function screenStates() {
        if(fullScreen) {
            if(objectName === "playbackViewer") {
                state = portrait ? "portrait_playback" : "landscape_playback"
            } else {
                state = portrait ? "portrait_fullscreen" : "landscape_fullscreen"
            }
        } else {
            orientationStates()
        }
    }
}
