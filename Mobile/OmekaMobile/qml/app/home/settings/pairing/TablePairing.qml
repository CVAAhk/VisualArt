import QtQuick 2.5
import "../../../base"
import "../../../../utils"

Item {

    id: root
    state: entry.state

    /*!Pairing header and back button*/
    OmekaToolBar {
        id: bar

        backgroundColor: Style.color3
        z: 1

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
        anchors.bottom: parent.bottom
        onKeyPressed: entry.submitEntry(key)
    }

    Rectangle {
        id: linked
        anchors.top: parent.top
        anchors.topMargin: Resolution.applyScale(438)
        width: parent.width
        height: 272
        color: "red"
        MouseArea {
            anchors.fill: parent
            onClicked: entry.reset()
        }
    }

    //pairing states
    states: [
        State {
            name: "pair"
            AnchorChanges { target: keypad; anchors.bottom: parent.bottom; anchors.top: undefined }
            PropertyChanges { target: keypad; opacity: 1 }
            AnchorChanges { target: entry; anchors.top: parent.top; anchors.bottom: undefined }
            PropertyChanges { target: entry; opacity: 1 }
            AnchorChanges { target: linked; anchors.left: parent.right }
            PropertyChanges { target: linked; opacity: 0 }
        },
        State {
            name: "link"
            AnchorChanges { target: keypad; anchors.bottom: undefined; anchors.top: parent.bottom }
            PropertyChanges { target: keypad; opacity: 0 }
            AnchorChanges { target: entry; anchors.top: undefined; anchors.bottom: parent.top }
            PropertyChanges { target: entry; opacity: 0 }
            AnchorChanges { target: linked; anchors.left: parent.left }
            PropertyChanges { target: linked; opacity: 1 }
        }
    ]

    transitions: Transition {
        AnchorAnimation { duration: 400; easing.type: Easing.OutQuad }
        PropertyAnimation { targets: [keypad, entry, linked]; duration: 400; property: "opacity"; easing.type: Easing.OutQuad }
    }

}
