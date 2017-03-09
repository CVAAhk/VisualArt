import QtQuick 2.5
import "../../../base"
import "../../../../utils"

Column {

    spacing: Resolution.applyScale(45)

    //icon
    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        source: Style.pair
        width: Resolution.applyScale(180); height: Resolution.applyScale(180)
    }

    //instructions
    OmekaText {
        width: parent.width
        center: true
        text: "enter the code you see on the table"
        _font: Style.pairingInstructions
    }

    //code slots
    ListView {
        width: childrenRect.width
        height: contentItem.children[0].height
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        spacing: Resolution.applyScale(21)
        model: 4
        delegate: delegate
    }

    //slot
    Component {
        id: delegate
        Rectangle {
            width: Resolution.applyScale(109)
            height: Resolution.applyScale(155)
            color: Style.transparent
            border.width: Resolution.applyScale(6)
            border.color: Style.color1
            radius: Resolution.applyScale(15)
        }
    }
}
