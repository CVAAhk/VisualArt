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
      The display rotation
    */
    property real orientation: 0

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

    //bindings
    Binding { target: display; property: "parent"; value: root }
    Binding { target: display; property: "rotation"; value: orientation }

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
            PropertyChanges { target: background; height: Resolution.appHeight * .3 }
        },
        //default background in landscape orientation
        State {
            name: "landscape"
            PropertyChanges { target: background; height: Resolution.appHeight * .8 }
        },
        //sizing of visual elements in portrait/minimized view
        State {
            name: "portrait_display"
            extend: "portrait"
            PropertyChanges { target: display; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: display.height }
            PropertyChanges { target: background; height: root.height }
        },
        //sizing of visual elements in landscape/minimized view
        State {
            name: "landscape_display"
            extend: "landscape"
            PropertyChanges { target: display; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: display.width; height: Resolution.appHeight *.8}
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
        //image transformations in portrait/maximized view
        State {
            name: "portrait_image"
            extend: "portrait_fullscreen"
            PropertyChanges { target: display; scale: wScale; y: background.height/2 - (height*scale)/2 }
        },
        //image transformations in landscape/maximized view
        State {
            name: "landscape_image"
            extend: "landscape_fullscreen"
            PropertyChanges { target: display; scale: background.height/height; y: background.height/2 - height/2 }
        },
        //orientation of playback controls in portrait/maximized view
        State {
            name: "portrait_playback"
            extend: "portrait_fullscreen"
            PropertyChanges { target: root; explicit: true; orientation: 90 }
        },
        //orientation of playback controls in landscape/maximized view
        State {
            name: "landscape_playback"
            extend: "landscape_fullscreen"
        },
        //playback display trasformations in portrait/maximized view
        State {
            name: "portrait_visual_playback"
            extend: "portrait_playback"
            PropertyChanges { target: display; scale: background.width/sourceHeight; y: background.height/2 - height/2 }
        },
        //playback display trasformations in landscape/maximized view
        State {
            name: "landscape_visual_playback"
            extend: "landscape_playback"
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
    onFullScreenChanged: screenStates()
    function screenStates() {
        if(!enabled) return;
        if(fullScreen) {
            switch(objectName) {
                case "imageViewer":
                    state = portrait ? "portrait_image" : "landscape_image"
                    break;
                case "playbackViewer":
                    state = portrait ? "portrait_playback" : "landscape_playback"
                    break;
                case "visualPlaybackViewer":
                    state = portrait ? "portrait_visual_playback" : "landscape_visual_playback"
                    break;
                default:
                    state = portrait ? "portrait_fullscreen" : "landscape_fullscreen"
                    break;
            }
        } else {
            orientationStates()
        }
    }
}
