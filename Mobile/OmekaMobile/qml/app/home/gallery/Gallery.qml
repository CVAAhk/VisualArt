import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../settings"

Item {
    Column{
        anchors.fill: parent
        spacing: 0
        SettingsBar{
            id: bar
            onActivated: if(stack) stack.push(Qt.resolvedUrl("../settings/Settings.qml"))
        }
        Rectangle{
            color: "black"
            width: parent.width
            height: parent.height - bar.height

            MouseArea{
                anchors.fill: parent
                onClicked: if(stack) stack.push(Qt.resolvedUrl("../detail/Detail.qml"))
            }
        }
    }
}
