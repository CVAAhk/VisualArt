import QtQuick 2.0
import QtQuick.Controls 1.4
import "."


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
                console.log("result.context = ", result.context)
                browser.append(result)
            }
        }
    }

//    /*!Display logo and settings entry*/
//    BrandBar {
//        id: bar
//        onActivated: if(homeStack) homeStack.push(Qt.resolvedUrl("../settings/Settings.qml"))
//    }

    /*!Scroll through items*/
    Browser {
        id: browser
        //anchors.top: bar.bottom
        height: parent.height
        headerHeight: height/3
        busy: true
        onCreateImage:
        {
            imageHolder.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight)
        }
    }
    CollectionImageHolder
    {
        id: imageHolder

        width: parent.width
        height: parent.height

        onImageDeleted:
        {
            browser.imageRemovedFromScene(filepath)
        }
    }


}
