import QtQuick 2.5
import QtQuick.Controls 1.4
import "."


/*!
   \qmltype OmekaViewer

   OmekaViewer is the base class for the various omeka media types.
  */
Item {
    id: root
    visible: false
    enabled: false
    anchors.centerIn: parent
    width: parent.width
    height: background.height

    /*!
        \qmlproperty url OmekaViewer::source
        File url of media item
    */
    property var source

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
    property var display

    /*!
      \qmlproperty Item OmekaViewer::portrait
      Indicates portrait orientation when true and landscape otherwise
    */
    property bool portrait: true//Resolution.portrait

    /*!
      \qmlproperty Item OmekaViewer::fullScreen
      Indicates item is in maximized state
    */
    property bool fullScreen: ItemManager.fullScreen

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
    property real fillScale: portrait ? wScale : sourceWidth * hScale > viewer.width ? wScale : hScale

    /*!
      \qmlproperty Item OmekaViewer::progress
      The load progress of the media file
    */
    property real progress: 0

    //parenting
    onDisplayChanged: {
        if(display){
            display.parent = root
        }
    }

    //background
    Rectangle {
        id: background
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        width: viewer.width
        scale: 1/viewer.scale
    }

    //viewer specific layout states for orientation and screen size
    states: [
        //default background in portrait orientation
        State {
            name: "portrait"
            PropertyChanges { target: background; height: 300 }//TODO
        },
        //default background in landscape orientation
        State {
            name: "landscape"
            PropertyChanges { target: background; height: Resolution.appHeight * .8 }
        },
        //sizing of visual elements in portrait/minimized view
        State {
            name: "portrait_display"
            PropertyChanges { target: display; displayWidth: parent.width; displayHeight: undefined }
            PropertyChanges { target: root; width: parent.width; height: display.height }
            PropertyChanges { target: background; height: root.height }
        },
        //sizing of visual elements in landscape/minimized view
        State {
            name: "landscape_display"
            PropertyChanges { target: display; displayWidth: undefined; displayHeight: parent.height }
            PropertyChanges { target: root; width: display.width; height: Resolution.appHeight *.8}
            PropertyChanges { target: background; height: root.height }
        },
        //sizing of visual elements in portrait/maximized view
        State {
            name: "portrait_fullscreen"
            extend: display ? "portrait_display" : "portrait"
            PropertyChanges { target: background; height: Resolution.appHeight }
            PropertyChanges { target: root; explicit: true; fillScale: 1 }
        },
        //sizing of visual elements in landscape/maximized view
        State {
            name: "landscape_fullscreen"
            extend: display ? "landscape_display" : "landscape"
            PropertyChanges { target: background; height: Resolution.appHeight }
            PropertyChanges { target: root; explicit: true; fillScale: 1 }
        },
        State {
            name: "portrait_fullscreen_display"
            extend: "portrait_fullscreen"
            PropertyChanges { target: display; scale: wScale; y: background.height/2 - height/2 }
        },
        State {
            name: "landscape_fullscreen_display"
            extend: "landscape_fullscreen"
            PropertyChanges { target: display; scale: background.height/sourceHeight; y: background.height/2 - height/2 }
        }
    ]

    //orientation state change
    onSourceChanged: orientationStates()
    onPortraitChanged: orientationStates()
    function orientationStates() {
        if(!enabled) return;
        if(fullScreen) {
            screenStates()
        }
        else if(display) {
            state = portrait ? "portrait_display" : "landscape_display"
        } else {
            state = portrait ? "portrait" : "landscape"
        }
    }

    //full screen state change
    //onFullScreenChanged: screenStates()
    function screenStates() {
        if(!enabled) return;
        if(fullScreen) {
            if(display) {
                state = portrait ? "portrait_fullscreen_display" : "landscape_fullscreen_display"
            } else {
                state = portrait ? "portrait_fullscreen" : "landscape_fullscreen"
            }
        } else {
            orientationStates()
        }
    }
}
