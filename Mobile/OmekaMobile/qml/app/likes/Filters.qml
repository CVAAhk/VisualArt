import QtQuick 2.0

Rectangle {
    id: root
    color: "red"

    states: [
        State {
            name: "open"
            PropertyChanges { target: root; explicit: true; height: 200}
        },
        State {
            name: "close"
        }
    ]

    transitions: Transition {
        PropertyAnimation { target: root; property: "height"; duration: 250; easing.type:Easing.OutQuad }
    }
}
