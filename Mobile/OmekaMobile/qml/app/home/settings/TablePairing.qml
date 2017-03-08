import QtQuick 2.5
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

    /*!Keypad for code entry*/
    Keypad {
        id: keypad
    }

}
