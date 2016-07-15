import QtQuick 2.5
import "../../base"
import "../../../utils"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    sourceWidth: img.sourceSize.width
    sourceHeight: img.sourceSize.height

    property bool portrait: Resolution.portrait

    Component.onCompleted: setOrientation()
    onPortraitChanged: setOrientation()

    //image element
    Image{
        id: img
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: root.source
    }

    //toggle fullscreen mode
    onFullScreenChanged: {
        print(fullScreen)
    }

    //orientation states
    states: [
        State {
            name: "portrait"
            PropertyChanges { target: img; width: parent.width; height: undefined }
            PropertyChanges { target: root; width: parent.width; height: img.height }
        },
        State {
            name: "landscape"
            PropertyChanges { target: img; width: undefined; height: parent.height }
            PropertyChanges { target: root; width: img.width; height: Resolution.appHeight *.8}
        }
    ]

    //update device orientation
    function setOrientation() {
        state = portrait ? "portrait" : "landscape"
    }
}
