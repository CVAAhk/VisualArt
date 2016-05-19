import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQml.Models 2.2

ApplicationWindow {
    id: root
    visible: true
    width: 470; height: 800
    color: "lightgray"
    property bool printDestruction: true

    ObjectModel{
        id: itemModel

        Rectangle{
            width: view.width; height: view.height
            color: "#FFFEF0"
            Text { text: "Page 1"; font.bold: true; anchors.centerIn: parent }
            Component.onDestruction: if(printDestruction) print("destroyed 1")
        }

        Rectangle{
            width: view.width; height: view.height
            color: "#F0FFF7"
            Text { text: "Page 2"; font.bold: true; anchors.centerIn: parent }
            Component.onDestruction: if(printDestruction) print("destroyed 2")
        }

        Rectangle{
            width: view.width; height: view.height
            color: "#F4F0FF"
            Text { text: "Page 3"; font.bold: true; anchors.centerIn: parent }
            Component.onDestruction: if(printDestruction) print("destroyed 3")
        }
    }

    ListView{
        id: view
        anchors { fill: parent; bottomMargin: 30 }
        model: itemModel
        preferredHighlightBegin: 0.5; preferredHighlightEnd: 0.5
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 200
        cacheBuffer: 200
    }

    Rectangle{
        width: root.width; height: 30
        anchors { top: view.bottom; bottom: parent.bottom }
        color: "gray"

        Row{
            anchors.centerIn: parent
            spacing: 20

            Repeater{
                model: itemModel.count

                Rectangle{
                    width: 5; height: 5
                    radius: 3
                    color: view.currentIndex == index ? "blue" : "white"

                    MouseArea{
                        width: 20; height: 20
                        anchors.centerIn: parent
                        onClicked: view.currentIndex = index
                    }
                }
            }
        }
    }

}
