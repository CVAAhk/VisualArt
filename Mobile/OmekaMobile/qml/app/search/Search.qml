import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../utils"
import "../base"

Item {

    Component.onCompleted: {
        Omeka.getTags()
    }

    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.type === Omeka.tag) {
                list.model.append(result)
            }
        }
    }

    Rectangle {
        width: parent.width
        height: list.height
        color: "#b1b1b1"
    }

    Column {
        anchors.fill: parent;
        spacing: 0

        OmekaToolBar {
            TextField {
                anchors.fill: parent
                anchors.margins: Resolution.applyScale(15)
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                placeholderText: "SEARCH"
                font.bold: true
                font.pixelSize: Resolution.applyScale(80)

                style: TextFieldStyle {
                    textColor: Style.titleFont.color
                    placeholderTextColor: textColor
                    background: Rectangle{
                        width: control.width
                        height: control.height
                        border.width: 0
                        radius: Resolution.applyScale(30)
                    }
                }
            }
        }

        OmekaScrollView {
            width: parent.width
            height: parent.height

            ListView {
                id: list
                anchors.fill: parent
                spacing: 2
                model: ListModel {}
                delegate: SearchDelegate {}
                header: SearchHeader {}
            }
        }
    }
}
