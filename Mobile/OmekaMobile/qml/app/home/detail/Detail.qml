import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: "blue"

    Text{
        anchors.centerIn: parent
        color: "white"
        text: "Image ID"
    }

    MouseArea{
        anchors.fill: parent
        onClicked: if(stack) stack.pop()
    }
}
