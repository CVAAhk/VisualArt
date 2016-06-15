import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../home"
import "../../base"
import "../../../utils"

/*!User settings*/
Item {

    Column {
        anchors.fill: parent
        spacing: 0

        /*!Settings header and back button*/
        OmekaToolBar {
            id: bar
            Text {
                anchors.centerIn: parent
                text: "SETTINGS"
                font.bold: true
                font.pointSize: Style.titleSize
                color: Style.titleColor
            }

            OmekaButton {
                id: back
                icon: "../../../../ui/back.png"
                onClicked: if(stack) stack.pop()
            }
        }

        ScrollView {
            width: parent.width
            height: parent.height - bar.height
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            ListView {
                anchors.fill: parent
                model: SettingsModel{}
                delegate: SettingsDelegate{}
                spacing: 150 * Resolution.scaleRatio
            }
        }
    }
}
