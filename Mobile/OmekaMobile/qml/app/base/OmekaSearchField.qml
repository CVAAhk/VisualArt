import QtQuick 2.5
import QtQuick.Controls 1.4
import "../base"
import "../styles"
import "../../utils"

OmekaToolBar {
    id: bar
    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    property alias textField: textField
    state: "search"

    //search field
    TextField {
        id: textField
        anchors.fill: parent
        anchors.margins: Resolution.applyScale(15)
        verticalAlignment: TextInput.AlignVCenter
        font.bold: true
        font.pixelSize: Resolution.applyScale(80)
        placeholderText: "SEARCH..."
        style: SearchBarStyle {}
    }

    //clear field control
    OmekaButton {
        id: clear
        enabled: false
        visible: false
        anchors.right: textField.right
        icon: Style.clear
        iconScale: .62
        onClicked: bar.clear()
    }

    //search icon
    Image {
        id: icon
        source: Style.searchButtonOff
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.4
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Resolution.applyScale(45)
    }

    function clear() {
        textField.text = ""
        ItemManager.tagSearch = ""
        ItemManager.searchTerm = ""
    }

    //button modes
    states: [
        State {
            name: "search"
            PropertyChanges { target: clear; opacity: 0 }
            PropertyChanges { target: icon; visible: true}
        },
        State {
            name: "results"
            PropertyChanges { target: clear; enabled: true; visible: true; opacity: 1 }
            PropertyChanges { target: icon; visible: false}
        }
    ]

    //button transitions
    transitions: Transition {
        PropertyAnimation { target: clear; property: "opacity"; duration: 250; easing.type: Easing.OutQuad }
    }
}
