import QtQuick 2.5
import "../../../utils"

Item {
    width: detail.width
    height: display.height + margins

    /*! \qmlproperty
        Space between content and page borders
    */
    property real margins: Resolution.applyScale(30)

    //background rectangle
    Rectangle {
        id: background
        anchors.fill: display
        color: Style.detailContentBackground
        radius: Resolution.applyScale(35)
    }

    //media display
    DetailColumn { id: display }
}
