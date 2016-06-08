import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../settings"
import "../../../utils"

/*!Top level media viewer*/
Item {

    Connections {
        target: Omeka
        onResultComplete:{
            print("results: "+result)
        }
    }

    Component.onCompleted: {
        Omeka.getPage(1)
    }

    Column{
        anchors.fill: parent
        spacing: 0

        /*!Display logo and settings entry*/
        BrandBar{
            id: bar
            onActivated: if(stack) stack.push(Qt.resolvedUrl("../settings/Settings.qml"))
        }

        /*!Item browser*/
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
