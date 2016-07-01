import QtQuick 2.5

Item {

    Rectangle{
        anchors.fill: parent
        color: "red"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: searchStack.pop()
    }

}
