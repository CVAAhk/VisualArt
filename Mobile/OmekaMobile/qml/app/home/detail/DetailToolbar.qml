import QtQuick 2.5
import "../../base"
import "../../../utils"

OmekaToolBar {
    OmekaButton{
        id: back
        anchors.left: parent.left
        icon: Style.back
        onClicked: if(stack) stack.pop()
    }
    OmekaButton {
        id: more
        anchors.right: like.left
        icon: Style.more
    }
    OmekaButton {
        id: like
        anchors.right: parent.right
        icon: Style.likeIndicator2
    }
}
