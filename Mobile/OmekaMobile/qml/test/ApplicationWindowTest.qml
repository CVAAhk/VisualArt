import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

ApplicationWindow {
    id:window
    visible:true

    width:470;
    height:800;

    ColumnLayout{
        id:root
        anchors.fill: parent
        spacing: 0

        Rectangle{
            id:toolbar
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color:"white"

            RowLayout{
                anchors.fill: parent
                layoutDirection: Qt.RightToLeft
                Button{
                    Layout.margins: 5
                    Layout.fillHeight: true
                    Layout.preferredWidth: 45
                }
            }

            Image{
                anchors.centerIn: parent
                source: "../../ui/logo.png"
            }

        }

        Rectangle{
            id:content
            Layout.minimumHeight: 400
            Layout.fillHeight: true
            Layout.fillWidth: true
            color:"#e6e8e7"
        }

        Rectangle{
            id:navigation
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout{
                anchors.fill: parent
                spacing: 0
                ExclusiveGroup { id: stackGroup }
                Button{
                    checkable: true
                    checked: true
                    exclusiveGroup: stackGroup
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Button{
                    checkable: true
                    exclusiveGroup: stackGroup
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Button{
                    checkable: true
                    exclusiveGroup: stackGroup
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }

}
