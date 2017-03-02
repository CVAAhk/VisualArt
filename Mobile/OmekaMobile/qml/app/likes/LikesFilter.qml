import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../base"
import "../../utils"

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Resolution.applyScale(30)
    height: childrenRect.height

    //toggle state
    Binding on state {when: button; value: button.checked ? "expand" : "collapse" }

    //border rectangle
    Rectangle {
        id: border
        anchors.fill: parent
        radius: Resolution.applyScale(30)
        color: Style.transparent
        border.width: Resolution.applyScale(6)
        border.color: Style.color1
        z: 1
    }

    //button control
    Button {
        id: button
        width: parent.width
        height: Resolution.applyScale(150)
        checkable: true

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
            background: Rectangle { color: Style.transparent }
            label: OmekaText {
                text: "filter by collection"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                _font: Style.headerFont
            }
        }
    }


    //collapse and expand states
    states: [
        State {
            name: "expand"
            PropertyChanges { target: arrow; explicit: true; rotation: 0}
        },
        State {
            name: "collapse"
        }
    ]

    //state transitions
    transitions: Transition {
        PropertyAnimation { target: arrow; property: "rotation"; duration: 250; easing.type:Easing.OutQuad }
    }
}
