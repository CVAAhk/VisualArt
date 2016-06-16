import QtQuick 2.5
import "../../../utils"

Item {
    width: detail.width
    height: display.height + margins

    /*! \qmlproperty Margins between content and page borders */
    property real margins: Resolution.applyScale(30)
    /*! \qmlproperty Currently selected item */
    property variant item: ItemManager.current

    //background rectangle
    Rectangle {
        id: background
        anchors.fill: display
        color: Style.detailContentBackground
        radius: Resolution.applyScale(35)
    }

    //media and data display
    DetailDisplay {
        id: display
    }
}
