import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../base"
import "../../utils"

Button {
    id: root
    checkable: true

    //toggle state
    Binding on state {when: button; value: button.checked ? "open" : "close" }

    //expanded indicator
    Image {
        id: arrow
        height: parent.height * .35
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Resolution.applyScale(30)
        source: Style.expand
        rotation: 180
    }

    //label and background
    style: ButtonStyle {
        background: Rectangle { color: Style.color3 }
        label: OmekaText {
            text: control.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            _font: Style.headerFont
        }
    }

    //open close state
    states: [
        State {
            name: "open"
            PropertyChanges { target: arrow; explicit: true; rotation: 0 }
        },
        State {
            name: "close"
        }
    ]

    //state transitions
    transitions: Transition {
        PropertyAnimation { target: arrow; property: "rotation"; duration: 250; easing.type:Easing.OutQuad }
    }

}
