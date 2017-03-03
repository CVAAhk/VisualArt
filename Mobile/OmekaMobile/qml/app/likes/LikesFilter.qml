import QtQuick 2.5
import "../../utils"

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Resolution.applyScale(30)
    height: border.height

    //border rectangle
    Rectangle {
        id: border
        width: parent.width
        height: button.height + filters.verticalOffset
        color: Style.transparent
        border.width: Resolution.applyScale(6)
        border.color: Style.color1
        z: 1
    }

    //main container
    Column {
        id: column
        width: parent.width
        height: childrenRect.height

        //button control
        FilterButton {
            id: button
            text: "filter by collection"
            width: parent.width
            height: Resolution.applyScale(150)
        }

        //filter list
        Filters {
            id: filters
            width: parent.width
            state: button.state
        }
    }
}
