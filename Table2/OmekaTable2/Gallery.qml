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
                top_left_browser.append(result);
                //lower_left_browser.append(result);
                lower_left_carousel.appendItems(result);
            }
        }
    }


    /*!Scroll through items*/
    //top screen
    Browser {
        id: top_left_browser
        rotation: 180
        //anchors.top: bar.bottom
        height: parent.height / 2
        headerHeight: height/3
        topScreen: true
        onCreateImage:
        {
            imageHolder.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight, title)
        }
    }

    //lower screen

//    Browser {
//        id: lower_left_browser
//        //anchors.top: bar.bottom
//        y: parent.height / 2
//        height: parent.height / 2
//        headerHeight: height/3
//        topScreen: false
//        onCreateImage:
//        {
//            imageHolder.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight, title)
//        }
//    }
    Carousel
    {
        id: lower_left_carousel
        x: 240.5
        y: 787
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, title, "lower left")
        }
    }

    CollectionImageHolder
    {
        id: imageHolder

        width: parent.width
        height: parent.height

        onImageDeleted:
        {
            console.log("delete filepath = ",filepath, "whichScreen = ", whichScreen)
            //top_left_browser.imageRemovedFromScene(filepath)
            if(whichScreen === "lower left") lower_left_carousel.imageRemovedFromScene(filepath);

        }
    }






}
