import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 470; height: 800
    color: "black"

    ListModel{
        id: model
        ListElement { title: "Calendar"; rectColor: "lime" }
        ListElement { title: "Setup"; rectColor: "red" }
        ListElement { title: "Internet"; rectColor: "blue" }
        ListElement { title: "Messages"; rectColor: "green" }
        ListElement { title: "Music"; rectColor: "grey" }
        ListElement { title: "Call"; rectColor: "chartreuse" }
    }

    Component{
        id: delegate
        Rectangle{
            width: 100; height: 100
            color: rectColor
            scale: y / parent.height
            opacity: scale
        }
    }

    PathView{
        id: view
        anchors.fill: parent
        model: model
        delegate: delegate
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightRangeMode: PathView.StrictlyEnforceRange
        path: Ellipse{
            width: view.width
            height: view.height
        }
    }

    Text{
        id: label
        text: view.model.get(view.currentIndex).title
        color: "white"
        font.pixelSize: 16
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}
