import QtQuick 2.5
import "../../../base"
import "../../../../utils"

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

    /*!Code display*/
    CodeEntry {
        id: entry
        width: Resolution.applyScale(546)
        anchors.top: parent.top
        anchors.topMargin: Resolution.applyScale(438)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    /*!Keypad for code entry*/
    Keypad {
        id: keypad
        onKeyPressed: entry.submitEntry(key)
    }

}
