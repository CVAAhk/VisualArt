import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: home
    width: parent.width
    height: parent.height

    onVisibleChanged: {
        if(!visible && homeStack.depth > 1) {
            homeStack.pop()
        }
    }

    StackView{
        id: homeStack
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("gallery/Gallery.qml")
    }

}
