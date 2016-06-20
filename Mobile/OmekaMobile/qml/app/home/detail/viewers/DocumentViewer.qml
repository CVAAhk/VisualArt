import QtQuick 2.5
import "../../../base"

/*
  \qmltype DocumentViewer

  DocumentViewer provides document view and navigation controls.
*/
OmekaViewer {
    id: root
    width: parent.width
    height: document.height
    sourceWidth: width

    //document element
    Rectangle {
        id: document
        width: parent.width
        height: 500
        color: "black"
        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Document: "+root.source
        }
    }
}
