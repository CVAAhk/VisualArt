import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"

Button {
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    height: parent.height
    width: parent.height

    BorderImage{
        anchors.centerIn: parent
        width: parent.width * .65
        height: parent.height * .65
        source: "../../../ui/settings.png"
    }

    style: ButtonStyle{
        background: Rectangle{
            implicitWidth: control.width
            implicitHeight: control.height
            radius: 30 * Resolution.scaleRatio
            color: control.pressed ? Style.tabDefault : Style.toolBarColor
        }
    }
}
