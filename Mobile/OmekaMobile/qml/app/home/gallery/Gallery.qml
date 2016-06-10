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
                browser.append(result)
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
    Column {
        anchors.fill: parent
        spacing: 0

        /*!Display logo and settings entry*/
        BrandBar {
            id: bar
            onActivated: if(stack) stack.push(Qt.resolvedUrl("../settings/Settings.qml"))
        }

        /*!Scroll through items*/
        Browser { id: browser }
    }
}
