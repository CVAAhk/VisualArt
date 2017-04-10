import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../../utils"
import "../../../base"

Item {

    signal unpair()

    //state display
    Item {
        width: parent.width
        height: Resolution.applyScale(294)

        //icon
        Image {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: Style.linked
            width: Resolution.applyScale(180)
            height: width
        }

        //state text
        OmekaText {
            anchors.bottom: parent.bottom
            width: parent.width
            center: true
            text: "paired with omeka collection viewer"
            _font: Style.pairingInstructions
        }
    }

    //unpair control
    Button {
        height: Resolution.applyScale(160)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Resolution.applyScale(30)
        onClicked: unpair()

        style: ButtonStyle {
            background: Rectangle {
                border.color: Style.color5
                border.width: Resolution.applyScale(6)
                color: Style.color3
                radius: Resolution.applyScale(30)
            }
            label: OmekaText {
                center: true
                text: "tap to unpair"
                _font: Style.unpairText
            }
        }
    }
}
