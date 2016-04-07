import QtQuick 2.5
import QtQuick.Controls 1.4

ApplicationWindow{
    visible: true
    width: 240; height: 200

    Component{
        id: delegate
        Column{
            id: wrapper
            Image{
                anchors.horizontalCenter: nameText.horizontalCenter
                width: 64; height: 64
                source: icon
            }
            Text{
                id: nameText
                text: name
                font.pointSize: 16
                color: wrapper.PathView.isCurrentItem ? "red" : "black"
            }
        }
    }

    PathView{
        anchors.fill: parent
        model: ContactModel{}
        delegate: delegate
        path: Path{
            startX: 120; startY: 100
            PathQuad { x: 120; y: 25; controlX: 260; controlY: 75 }
            PathQuad { x: 120; y: 100; controlX: -20; controlY: 75 }
        }
    }

}
