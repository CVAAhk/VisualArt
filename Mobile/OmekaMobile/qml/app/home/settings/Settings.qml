import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: "green"

    MouseArea {
        anchors.fill: parent
        onClicked: if(stack) stack.pop()
    }
}
