import QtQuick 2.0
import QtQuick.Controls 1.4
import "../settings"
import "../../../utils"

/*!Media viewer*/
Item {

    /*!Dynamically load omeka query results into browser*/
    Connections {
        target: Omeka
        onRequestComplete:{
            if(result.type === Omeka.file){
                grid.model.append(result)
              //  Omeka.getMetaData(result.id)
            }
            else{
                //print(result.id)
            }
        }
    }

    /*!Load first page*/
    Component.onCompleted: {
        Omeka.getPage(1)
    }

    /*!Gallery display*/
    Column{
        anchors.fill: parent
        spacing: 0

        /*!Display logo and settings entry*/
        BrandBar{
            id: bar
            onActivated: if(stack) stack.push(Qt.resolvedUrl("../settings/SettingsPage.qml"))
        }

        /*!Scroll through items*/
        ScrollView{
            id: browser
            width: parent.width
            height: parent.height - bar.height
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            GridView{
                id: grid
                anchors.horizontalCenter: parent.horizontalCenter
                maximumFlickVelocity: 8000 * Resolution.scaleRatio
                flickDeceleration: 4500 * Resolution.scaleRatio
                cellWidth: width/Math.floor(width/(Math.floor(478 * Resolution.scaleRatio)))
                cellHeight: cellWidth
                cacheBuffer: cellHeight * 10
                model: ListModel{}
                delegate: OmekaItem{}
            }
        }
    }
}
