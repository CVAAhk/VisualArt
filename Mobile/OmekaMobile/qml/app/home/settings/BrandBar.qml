import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"
import "../settings"
import "../../base"

OmekaToolBar {
    id: root
    signal activated()
    backgroundColor: "white"

    //app settings
    OmekaButton{
        anchors.right: parent.right
        icon: Style.settingsIcon
        iconScale: .62
        onClicked: root.activated();
    }
}
