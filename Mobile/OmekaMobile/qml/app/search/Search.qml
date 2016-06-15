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
                anchors.margins: 15 * Resolution.scaleRatio
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                placeholderText: "SEARCH"
                font.bold: true
                font.pixelSize: 80 * Resolution.scaleRatio

                style: TextFieldStyle {
                    textColor: Style.titleColor
                    placeholderTextColor: textColor
                    background: Rectangle{
                        width: control.width
                        height: control.height
                        border.width: 0
                        radius: 30 * Resolution.scaleRatio
                    }
                }
            }
        }

        ScrollView {
            width: parent.width
            height: parent.height
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            ListView {
                id: list
                anchors.fill: parent
                spacing: 2
                model: ListModel {}
                delegate: SearchDelegate {}
                header: Text {
                    width: parent.width
                    height: 150 * Resolution.scaleRatio
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "TAGS"
                    font.pointSize: 15
                    color: Style.titleColor
                }
            }
        }
    }
}
