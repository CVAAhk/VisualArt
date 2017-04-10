import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../base"
import "../../../../utils"

Item {
    id: root
    width: parent.width
    height: childrenRect.height
    anchors.bottomMargin: keypad.cellHeight
    property var spacing: Resolution.applyScale(6)

    signal keyPressed(var key)


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
        ListElement { back: true }
    }

    /*!Keypad keys*/
    Component {
        id: key
        Button {
            width: keypad.cellWidth
            height: keypad.cellHeight - root.spacing
            text: digit ? digit: ""
            property var defaultColor: digit ? Style.color2 : Style.color3

            style: ButtonStyle {
                background: Rectangle {
                    id: bkg
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: control.width - root.spacing
                    color: control.pressed ? Style.color4 : control.defaultColor

                    //icon
                    Image {
                        id: icon
                        anchors.centerIn: parent
                        width: Resolution.applyScale(66)
                        fillMode: Image.PreserveAspectFit
                    }

                    //assign icon
                    Component.onCompleted: {
                        if(back) {
                            icon.source = Style.backKey
                        }
                    }

                }
                //digit display
                label: OmekaText {
                    text: control.text
                    center: true
                    _font: Style.keypadFont
                }
            }

            onClicked: {
                if(text) {
                    keyPressed(text)
                } else if(back) {
                    keyPressed("back")
                }
            }
        }
    }

    /*!Keypad layout*/
    GridView {
        id: keypad
        interactive: false
        width: parent.width
        height: childrenRect.height
        cellWidth: (parent.width/3)
        cellHeight: Resolution.applyScale(180)
        anchors.horizontalCenter: parent.horizontalCenter
        model: model
        delegate: key
    }
}
