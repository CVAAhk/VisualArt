import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../settings"
import "../../base"

OmekaToolBar {
    id: root
    signal activated()
    backgroundColor: Style.toolBarColor

    //app settings
    OmekaButton{
        anchors.right: parent.right
        icon: "../../../../ui/settings.png"
        iconScale: .62
        onClicked: root.activated();
    }

    //endpoint logo
    BorderImage{
        anchors.centerIn: parent        
        scale: (parent.height * .8)/height
        source: "../../../../ui/logo.png"
    }
}
