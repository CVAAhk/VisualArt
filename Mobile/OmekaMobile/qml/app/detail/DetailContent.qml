import QtQuick 2.5
import "../../utils"

/*
  \qmltype DetailContent

  The content container of the detail scroll view
*/
Item {
    id: content
    width: detail.width
    height: display.height + margins

    /*! \qmlproperty
        Space between content and page borders
    */
    property real margins: ItemManager.fullScreen ? 0 : Resolution.applyScale(30)

    //background rectangle
    Rectangle {
        id: background
        visible: opacity > 0
        anchors.fill: display
        color: Style.detailContentBackground
        radius: Resolution.applyScale(35)
    }

    //media display
    DetailColumn { id: display }
}
