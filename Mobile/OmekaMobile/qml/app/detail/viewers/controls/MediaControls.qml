import QtQuick 2.5
import "../../../base"
import "../../../../utils"

Item {
    visible: false
    z: 1

    //full screen mode toggle control
    OmekaToggle {
        id: toggle
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        defaultSource: Style.maximize
        checkedSource: Style.minimize
        iconScale: .5
        onCheckedChanged: ItemManager.fullScreen = checked
    }

}
