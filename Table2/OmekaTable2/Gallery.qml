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
                top_left_carousel.appendItems(result);
                lower_left_carousel.appendItems(result);
                top_right_carousel.appendItems(result);
                lower_right_carousel.appendItems(result);
            }
        }
    }


    /*!Scroll through items*/
    //top screen
    Carousel
    {
        id: top_left_carousel
        x: 241 + 480
        y: 315
        topScreen: true
        rotation: 180
        onCreateImage:
        {
            imageHolder.createImage(source, imageX -(1920 - x), imageY, imageRotation, imageWidth, imageHeight, title, "top left")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
    }
    Carousel
    {
        id: top_right_carousel
        x: 1201 + 480
        y: 315
        topScreen: true
        rotation: 180
        onCreateImage:
        {
            imageHolder.createImage(source, imageX -(1920 - x), imageY, imageRotation, imageWidth, imageHeight, title, "top right")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
    }

    //lower screen
    Carousel
    {
        id: lower_left_carousel
        x: 241
        y: 765
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, title, "lower left")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
    }
    Carousel
    {
        id: lower_right_carousel
        x: 1201
        y: 765
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, title, "lower right")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
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

            if(whichScreen === "lower left") lower_left_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "lower right") lower_right_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "top left") top_left_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "top right") top_right_carousel.imageRemovedFromScene(filepath);

        }
    }
}
