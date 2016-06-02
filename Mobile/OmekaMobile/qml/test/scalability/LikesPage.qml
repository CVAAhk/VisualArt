import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ScrollView{
    id: page
    implicitWidth: 640
    implicitHeight: 200

    property int size: 200

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    Item{
        id:content
        width: Math.max(page.viewport.width, grid.implicitWidth + 2 * grid.rowSpacing)
        height: Math.max(page.viewport.height, grid.implicitHeight + 2 * grid.columnSpacing)

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
}
