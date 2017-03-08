import QtQuick 2.0

Rectangle {

    width: parent.width
    height: parent.height
    color: "red"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(homeStack) {
                homeStack.pop()
            }
        }
    }

}
