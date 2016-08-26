import QtQuick 2.5
import "../../base"
import "../../../utils"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root
    sourceWidth: img.sourceSize.width
    sourceHeight: img.sourceSize.height


    //image element
    display: Image{
        id: img
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: root.source
        visible: !fullScreen
    }

    ImageZoom {
        z: 1
        visible: fullScreen
        width: background.width
        height: background.height
        contentWidth: img.width
        contentHeight: img.height
        source: img
    }

}
