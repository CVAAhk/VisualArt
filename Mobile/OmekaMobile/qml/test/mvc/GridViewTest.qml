import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 470; height: 800

    Component{
        id: delegate
        Item{
            width: grid.cellWidth - 5; height: grid.cellHeight - 5
            Column{
                anchors.fill: parent
                Image{ id:image; source: icon; anchors.centerIn: parent }
                Text { text: name; anchors.horizontalCenter: parent.horizontalCenter; anchors.top:image.bottom}
            }
        }
    }

    GridView{
        id: grid
        anchors.fill: parent
        property int columns: width < height ? 2 : 3
        cellWidth: Math.floor(width/columns); cellHeight: Math.floor(width/columns)
        model: ContactModel{}
        delegate: delegate
        highlight: Rectangle { color: "lightsteelblue"; radius: 5}
        focus: true
    }

}
