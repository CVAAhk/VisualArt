import QtQuick 2.5
import "."

/*
  \qmltype DetailContent

  The content container of the detail scroll view
*/
Item
{
    property double rootScale: 1.0

    id: content
    height: display.height + (margins*1)
    anchors.top: parent.top
    anchors.topMargin: margins

    /*! \qmlproperty
        Space between content and page borders
    */
    property real margins: 30

    //background rectangle
    Rectangle
    {
        id: background
        visible: opacity > 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: display.width
        height: display.height
        color: Style.color2
        radius: 35
    }

    //media display
    DetailColumn
    {
        id: display
        rootScale: content.rootScale
    }
}
