import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ScrollView{
    id: page
    implicitWidth: 640
    implicitHeight: 200

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    Item{
        id:content
        width: Math.max(page.viewport.width, column.implicitWidth + 2 * column.spacing)
        height: Math.max(page.viewport.height, column.implicitHeight)

        ColumnLayout{
            id:column

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle{
                anchors.left: parent.left
                Layout.fillWidth: true
                height: 50
                color: "white"
                Label{
                    anchors.centerIn: parent
                    text: "Administrator (1)"
                }
            }

            Rectangle{
                anchors.left: parent.left
                Layout.fillWidth: true
                height: 50
                color: "white"
                Label{
                    anchors.centerIn: parent
                    text: "Community (2)"
                }
            }

            Rectangle{
                anchors.left: parent.left
                Layout.fillWidth: true
                height: 50
                color: "white"
                Label{
                    anchors.centerIn: parent
                    text: "Building (2)"
                }
            }

            Rectangle{
                anchors.left: parent.left
                Layout.fillWidth: true
                height: 50
                color: "white"
                Label{
                    anchors.centerIn: parent
                    text: "Events (4)"
                }
            }

            Rectangle{
                anchors.left: parent.left
                Layout.fillWidth: true
                height: 50
                color: "white"
                Label{
                    anchors.centerIn: parent
                    text: "Press (6)"
                }
            }
        }
    }
}
