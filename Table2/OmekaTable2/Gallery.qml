import QtQuick 2.0
import QtQuick.Controls 1.4
import "."
import "settings.js" as Settings


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
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_left_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_right_carousel.pairingHeight;
            }
            else
            {
                return;
            }
            addImageToFavorites(image);

            image.recycle(target_x,target_y);
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
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_left_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_right_carousel.pairingHeight;
            }
            else
            {
                return;
            }
            addImageToFavorites(image);

            image.recycle(target_x,target_y);
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
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y - image.height;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y - image.height;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y + top_left_carousel.pairingHeight + 50;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y + top_right_carousel.pairingHeight + 50;
            }
            else
            {
                return;
            }
            addImageToFavorites(image);

            image.recycle(target_x,target_y);
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
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y - image.height;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y - image.height;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y + top_left_carousel.pairingHeight + 50;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = pairing_box_coordinates.x;
                target_y = pairing_box_coordinates.y + top_right_carousel.pairingHeight + 50;
            }
            else
            {
                return;
            }
            addImageToFavorites(image);

            image.recycle(target_x,target_y);
        }
    }

    Item { id: overlayImageTopLeftRoot; x: top_left_carousel.x; y: top_left_carousel.y; rotation: top_left_carousel.rotation }
    Item { id: overlayImageTopRightRoot; x: top_right_carousel.x; y: top_right_carousel.y; rotation: top_right_carousel.rotation }
    Item { id: overlayImageLowerLeftRoot; x: lower_left_carousel.x; y: lower_left_carousel.y; rotation: lower_left_carousel.rotation }
    Item { id: overlayImageLowerRightRoot; x: lower_right_carousel.x; y: lower_right_carousel.y; rotation: lower_right_carousel.rotation }

    function pairingBoxCoordinates(carousel)
    {
        var pairing_width = carousel.pairingWidth;
        var pairing_height = carousel.pairingHeight;

        var pairing_x = carousel.pairingAbsoluteX;
        var pairing_y = carousel.pairingAbsoluteY;
        if(carousel.topScreen)
        {
            pairing_x = Settings.SCREEN_WIDTH - pairing_x - pairing_width;
            pairing_y = Settings.SCREEN_HEIGHT - pairing_y - pairing_height;
        }

        var pairing_box_coordinates = ({});
        pairing_box_coordinates.x = pairing_x;
        pairing_box_coordinates.y = pairing_y;
        return pairing_box_coordinates;
    }

    function isImageInPairingBox(carousel,image)
    {
        var middleX = image.x + image.width * 1/2;
        var middleY = image.y + image.height * 1/2;
        if(image.topScreen)
        {
            middleX = Settings.SCREEN_WIDTH - middleX;
            middleY = Settings.SCREEN_HEIGHT - middleY;
        }
        var pairing_box_coordinates = pairingBoxCoordinates(carousel)
        var pairing_x = pairing_box_coordinates.x;
        var pairing_y = pairing_box_coordinates.y;

        var pairing_width = carousel.pairingWidth;
        var pairing_height = carousel.pairingHeight;


        //console.log("middleX = ", middleX, " middleY = ", middleY, "pairing_x = ", pairing_x, "pairing_y = ", pairing_y)


        if(middleX > pairing_x && middleX < pairing_x + pairing_width&&
                middleY > pairing_y && middleY < pairing_y + pairing_height)
        {
            if(carousel.paired && carousel.pairedEnabled)
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
    function attractImageIsInPairingBox(image)
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
    function attractImageReleased(image)
    {
        var pairing_box_coordinates;
        var target_x;
        var target_y;
        if(gallery.isImageInPairingBox(lower_left_carousel,image))
        {
            pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(lower_right_carousel,image))
        {
            pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(top_left_carousel,image))
        {
            pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_left_carousel.pairingHeight + 50;
        }
        else if(gallery.isImageInPairingBox(top_right_carousel,image))
        {
            pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_right_carousel.pairingHeight + 50;
        }
        else
        {
            return;
        }
        addImageToFavorites(image);

        image.recycle(target_x,target_y);
    }
}
