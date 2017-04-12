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
            //imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "top left")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
        onImageDragged:
        {
            gallery.isImageInPairingBox(lower_left_carousel,image);
            gallery.isImageInPairingBox(lower_right_carousel,image);
            gallery.isImageInPairingBox(top_left_carousel,image);
            gallery.isImageInPairingBox(top_right_carousel,image);
        }
        onImageFinishedDragging:
        {
            addImageToFavorites(image)
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
            //imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "top right")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
        onImageDragged:
        {
            gallery.isImageInPairingBox(lower_left_carousel,image);
            gallery.isImageInPairingBox(lower_right_carousel,image);
            gallery.isImageInPairingBox(top_left_carousel,image);
            gallery.isImageInPairingBox(top_right_carousel,image);
        }
        onImageFinishedDragging:
        {
            addImageToFavorites(image)
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
        //property var code
        onCreateImage:
        {
            //imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "lower left")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
        onImageDragged:
        {
            if(gallery.isImageInPairingBox(lower_left_carousel,image)||
            gallery.isImageInPairingBox(lower_right_carousel,image)||
            gallery.isImageInPairingBox(top_left_carousel,image)||
            gallery.isImageInPairingBox(top_right_carousel,image))
            {
                image.turnSmall();
            }
            else
            {
                image.turnBack();
            }
        }
        onImageFinishedDragging:
        {
            addImageToFavorites(image)
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
            //imageHolder.createImage(source, imageX + x, imageY + y, imageRotation, imageWidth, imageHeight, tapOpen, "lower right")
        }
        onCanPaginate:
        {
            Omeka.getNextPage(gallery)
        }
        onImageDragged:
        {
            if(!gallery.isImageInPairingBox(lower_left_carousel,image))
            gallery.isImageInPairingBox(lower_right_carousel,image);
            gallery.isImageInPairingBox(top_left_carousel,image);
            gallery.isImageInPairingBox(top_right_carousel,image);
        }
        onImageFinishedDragging:
        {
            addImageToFavorites(image)
        }
    }

    Item { id: overlayImageTopLeftRoot; x: top_left_carousel.x; y: top_left_carousel.y; rotation: top_left_carousel.rotation }
    Item { id: overlayImageTopRightRoot; x: top_right_carousel.x; y: top_right_carousel.y; rotation: top_right_carousel.rotation }
    Item { id: overlayImageLowerLeftRoot; x: lower_left_carousel.x; y: lower_left_carousel.y; rotation: lower_left_carousel.rotation }
    Item { id: overlayImageLowerRightRoot; x: lower_right_carousel.x; y: lower_right_carousel.y; rotation: lower_right_carousel.rotation }

    function isImageInPairingBox(carousel,image)
    {
        var middleX = image.x + image.width * 3/4;
        var middleY = image.y + image.height * 3/4;

        var pairing_width = carousel.pairingWidth;
        var pairing_height = carousel.pairingHeight;

        var pairing_x = carousel.pairingAbsoluteX;
        var pairing_y = carousel.pairingAbsoluteY;

        if(middleX > pairing_x && image.x < pairing_x + pairing_width - image.width/4 &&
                middleY > pairing_y && image.y < pairing_y + pairing_height - image.height/4)
        {
            if(carousel.paired)
            {
                //image.turnSmall();
                return true;
            }
        }
        else
        {
            //image.turnBack();
            return false;
        }
        return false;
    }
    function addImageToFavorites(image)
    {
        if(gallery.isImageInPairingBox(lower_left_carousel,image) && lower_left_carousel.currentCode)
        {
            console.log("add item = ", image.item.id)
            HeistManager.addItem(lower_left_carousel.currentCode, image.item.id, lower_left_carousel);
        }
        else if(gallery.isImageInPairingBox(lower_right_carousel,image) && lower_right_carousel.currentCode)
        {
            console.log("add item = ", image.item.id)
            HeistManager.addItem(lower_right_carousel.currentCode, image.item.id, lower_right_carousel);
        }
        else if(gallery.isImageInPairingBox(top_right_carousel,image) && top_right_carousel.currentCode)
        {
            console.log("add item = ", image.item.id)
            HeistManager.addItem(top_right_carousel.currentCode, image.item.id, top_right_carousel);
        }
        else if(gallery.isImageInPairingBox(top_left_carousel,image) && top_left_carousel.currentCode)
        {
            console.log("add item = ", image.item.id)
            HeistManager.addItem(top_left_carousel.currentCode, image.item.id, top_left_carousel);
        }
    }
}
