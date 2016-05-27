import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ScrollView{
    id: home

    property int size: 200

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    state: scrollingUp() ? "up" : scrollingDown() ? "down" : "none"
    states:[
        State {name: "up" },
        State {name: "down" },
        State {name: "none" }
    ]

    Item{
        id:content
        width: Math.max(home.viewport.width, grid.implicitWidth + 2 * grid.rowSpacing)
        height: Math.max(home.viewport.height, grid.implicitHeight + 2 * grid.columnSpacing)

        GridLayout{
            id: grid
            columnSpacing: 0

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: rowSpacing
            anchors.rightMargin: rowSpacing
            anchors.topMargin: columnSpacing

            columns: 2

            Repeater{
                model: 30
                Rectangle{ color:"red"; radius: 10; width: size; height: size }
            }
        }
    }

    function scrollingUp(){
        return flickableItem.dragging && flickableItem.verticalVelocity > 0
    }

    function scrollingDown(){
        return flickableItem.dragging && flickableItem.verticalVelocity < 0
    }
}
