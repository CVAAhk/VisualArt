import QtQuick 2.5
import "../../base"
import "../../../utils"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root
    objectName: "imageViewer"
    sourceWidth: img.sourceSize.width
    sourceHeight: img.sourceSize.height

    //image element
    display: Image{
        id: img
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: root.source
    }
}
