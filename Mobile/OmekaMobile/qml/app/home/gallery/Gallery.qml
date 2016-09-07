import QtQuick 2.0
import QtQuick.Controls 1.4
import "../settings"
import "../../../utils"

/*!Media viewer*/
Item {
    id: gallery

    property var current

    /*!Load first page*/
    Component.onCompleted: {
        Omeka.getPage(1, gallery)
    }

    /*!Dynamically load omeka query results into browser*/
    Connections {
        target: Omeka
        onRequestComplete:{
            if(result.context === gallery){
                browser.append(result)
            }
        }
    }

    /*!Display logo and settings entry*/
    BrandBar {
        id: bar
        onActivated: if(homeStack) homeStack.push(Qt.resolvedUrl("../settings/Settings.qml"))
    }

    /*!Scroll through items*/
    ItemBrowser {
        id: browser
        anchors.top: bar.bottom
        height: parent.height - bar.height
        onCanPaginate: {
            Omeka.getNextPage(gallery)
        }
    }

    //endpoint logo
    Logo {
        contentY: browser.contentY
        minY: 0
        maxY: browser.layout.headerItem.height
        minWidth: parent.width
        maxWidth: Resolution.applyScale(450)
        minHeight: maxY
        maxHeight: bar.height
        source: Style.omekaLogo
    }
}
