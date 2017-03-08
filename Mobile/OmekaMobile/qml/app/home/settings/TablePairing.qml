import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../base"
import "../../../utils"

Item {

    /*!Pairing header and back button*/
    OmekaToolBar {
        id: bar

        backgroundColor: Style.color3

        OmekaText {
            anchors.centerIn: parent
            text: "pairing"
            _font: Style.titleFont
        }

        OmekaButton {
            id: back
            icon: Style.back
            iconScale: .7
            onClicked: if(homeStack) homeStack.pop()
        }
    }

    /*!Keypad key declarations*/
    ListModel {
        id: model
        ListElement { digit: "1" }
        ListElement { digit: "2" }
        ListElement { digit: "3" }
        ListElement { digit: "4" }
        ListElement { digit: "5" }
        ListElement { digit: "6" }
        ListElement { digit: "7" }
        ListElement { digit: "8" }
        ListElement { digit: "9" }
        ListElement { }
        ListElement { digit: "0" }
        ListElement { }
    }

    /*!Keypad keys*/
    Component {
        id: key
        Button {
            width: keypad.cellWidth
            height: keypad.cellHeight - keypad.spacing
            text: digit ? digit: ""
            property var defaultColor: digit ? Style.color2 : Style.color3

            style: ButtonStyle {
                background: Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: control.width - keypad.spacing
                    color: control.pressed ? Style.color4 : control.defaultColor
                }
                label: OmekaText {
                    text: control.text
                    center: true
                    _font: Style.keypadFont
                }
            }

            onClicked: console.log(text)
        }
    }

    /*!Keypad layout*/
    GridView {
        id: keypad
        anchors.bottom: parent.bottom
        anchors.bottomMargin: cellHeight
        width: parent.width
        height: childrenRect.height
        cellWidth: (parent.width/3)
        cellHeight: Resolution.applyScale(180)
        anchors.horizontalCenter: parent.horizontalCenter
        model: model
        delegate: key

        property var spacing: Resolution.applyScale(6)
    }

}
