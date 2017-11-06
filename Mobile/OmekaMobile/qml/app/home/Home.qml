import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: home
    width: parent.width
    height: parent.height
    enabled: false

    onVisibleChanged: {
        if(!visible) {
            while(homeStack.depth > 1) {
                homeStack.pop()
            }
        }
    }

    StackView{
        id: homeStack
        anchors.fill: parent
        initialItem: Qt.resolvedUrl("gallery/Gallery.qml")
    }

    function onHomeStack()
    {
        if(homeStack.depth === 1)
        {
            return true;
        }
        else
        {
            homeStack.pop()
            return false;
        }
    }

}
