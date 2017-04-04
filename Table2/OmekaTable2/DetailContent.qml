import QtQuick 2.5
import "."

/*
  \qmltype DetailContent

  The content container of the detail scroll view
*/
Item {
    id: content
    width: detail.width
    height: display.height + (margins*4)
    anchors.top: parent.top
    anchors.topMargin: margins

    /*! \qmlproperty
        Space between content and page borders
    */
    property real margins: 30

    //background rectangle
    Rectangle {
        id: background
        visible: opacity > 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: display.width
        height: display.height + 60
        color: Style.color2
        radius: 35
    }

    //media display
    DetailColumn { id: display }
}
