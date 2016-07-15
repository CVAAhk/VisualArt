import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

OmekaToolBar {

    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    property alias textField: textField
    state: "search"

    //search field
    TextField {
        id: textField
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(15)
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        font.bold: true
        font.pixelSize: Resolution.applyScale(80)
        placeholderText: "SEARCH"
        style: SearchBarStyle {}
    }

    //clear field control
    OmekaButton {
        id: clear
        enabled: false
        visible: false
        anchors.right: textField.right
        icon: Style.settingsIcon
        iconScale: .62
        onClicked: {
            textField.text = ""
            ItemManager.tagSearch = ""
            ItemManager.searchTerm = ""
        }
    }

    //button modes
    states: [
        State {
            name: "search"
            PropertyChanges { target: clear; opacity: 0 }
        },
        State {
            name: "results"
            PropertyChanges { target: clear; enabled: true; visible: true; opacity: 1 }
        }
    ]

    //button transitions
    transitions: Transition {
        PropertyAnimation { target: clear; property: "opacity"; duration: 250; easing.type: Easing.OutQuad }
    }
}
