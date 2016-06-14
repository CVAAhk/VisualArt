import QtQuick 2.0
import "../../app"
import "../../utils"

ToolBarButton {
    icon: "../../../../ui/back.png"
    iconScale: .55
    releasedColor: Style.backgroundColor
    onClicked: if(stack) stack.pop()
}
