import QtQuick 2.0
import QtQuick.Controls 1.4
import "."


/*!Media viewer*/
Item {
    id: gallery

    property var current

    signal removeAttractImage(string filepath,string whichScreen)
    signal carouselActivate()

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
        onYellowPressed: {top_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}

    }
    TouchToBegin
    {
        id: top_right_begin
        x: 1306; y: 30
        color: "green"
        onGreenPressed: {top_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
    }
    TouchToBegin
    {
        id: lower_left_begin
        x: 346; y: 960
        color: "blue"
        onBluePressed: {lower_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
    }
    TouchToBegin
    {
        id: lower_right_begin
        x: 1306; y: 960
        color: "red"
        onRedPressed: {lower_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
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
        color: "#faa918"
        whichScreen: "top left"
        selectedParent: overlayImageTopLeftRoot
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "top left")
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
        color: "#7ac70c"
        whichScreen: "top right"
        selectedParent: overlayImageTopRightRoot
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "top right")
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
        color: "#2b89d9"
        whichScreen: "lower left"
        selectedParent: overlayImageLowerLeftRoot
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "lower left")
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
        color: "#d33131"
        whichScreen: "lower right"
        selectedParent: overlayImageLowerRightRoot
        onCreateImage:
        {
            imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "lower right")
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

        antialiasing: true

        onImageDeleted:
        {
            //console.log("delete filepath = ",filepath, "whichScreen = ", whichScreen)

            if(whichScreen === "lower left") lower_left_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "lower right") lower_right_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "top left") top_left_carousel.imageRemovedFromScene(filepath);
            if(whichScreen === "top right") top_right_carousel.imageRemovedFromScene(filepath);
            if(whichScreen.includes("attract")) gallery.removeAttractImage(filepath,whichScreen);
        }
    }

    Item { id: overlayImageTopLeftRoot; x: top_left_carousel.x; y: top_left_carousel.y; rotation: top_left_carousel.rotation }
    Item { id: overlayImageTopRightRoot; x: top_right_carousel.x; y: top_right_carousel.y; rotation: top_right_carousel.rotation }
    Item { id: overlayImageLowerLeftRoot; x: lower_left_carousel.x; y: lower_left_carousel.y; rotation: lower_left_carousel.rotation }
    Item { id: overlayImageLowerRightRoot; x: lower_right_carousel.x; y: lower_right_carousel.y; rotation: lower_right_carousel.rotation }

    function imageHolderCreateImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, tapOpen, whichScreen)
    {
        imageHolder.createImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, tapOpen, whichScreen)
    }
}
