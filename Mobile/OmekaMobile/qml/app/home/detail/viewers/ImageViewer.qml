import QtQuick 2.5
import "../../../base"

/*
  \qmltype ImageViewer

  ImageViewer provides image view and manipulation controls.
*/
OmekaViewer {
    id: root
    width: parent.width
    height: img.height
    sourceWidth: img.sourceSize.width

    //image element
    Image{
        id: img
        width: parent.width
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: root.source
    }
}
