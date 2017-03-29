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
    TouchToBegin
    {
        id: top_left_begin
        x: 346; y: 30
        color: "yellow"
        onYellowPressed: top_left_carousel.opacity = active ? 1.0 : 0.0

    }
    TouchToBegin
    {
        id: top_right_begin
        x: 1306; y: 30
        color: "green"
        onGreenPressed: top_right_carousel.opacity = active ? 1.0 : 0.0
    }
    TouchToBegin
    {
        id: lower_left_begin
        x: 346; y: 960
        color: "blue"
        onBluePressed: lower_left_carousel.opacity = active ? 1.0 : 0.0
    }
    TouchToBegin
    {
        id: lower_right_begin
        x: 1306; y: 960
        color: "red"
        onRedPressed: lower_right_carousel.opacity = active ? 1.0 : 0.0
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
        opacity: 0.0
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, "top left")
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
        opacity: 0.0
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, "top right")
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
        opacity: 0.0
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, "lower left")
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
        opacity: 0.0
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, "lower right")
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

    function imageHolderCreateImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, whichScreen)
    {
        imageHolder.createImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, whichScreen)
    }
}
