import QtQuick 2.0
import QtQuick.Controls 1.4
import "."
import "settings.js" as Settings


/*!Media viewer*/
Item {
    id: gallery

    property var current
    property int maxResults

    property Item referenceOverlayArea: activeDetailHolder

    signal turnOnAtrract()

    onMaxResultsChanged:
    {
        top_left_carousel.maxResults = gallery.maxResults;
        top_right_carousel.maxResults = gallery.maxResults;
        lower_left_carousel.maxResults = gallery.maxResults;
        lower_right_carousel.maxResults = gallery.maxResults;
        middle_right_carousel.maxResults = gallery.maxResults;
        middle_left_carousel.maxResults = gallery.maxResults;
    }

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
                if(Settings.USERS == 2)
                {
                    top_right_carousel.appendItems(result);
                    lower_right_carousel.appendItems(result);
                }
                else if(Settings.USERS == 4)
                {
                    top_left_carousel.appendItems(result);
                    lower_left_carousel.appendItems(result);
                    top_right_carousel.appendItems(result);
                    lower_right_carousel.appendItems(result);
                }
                else if(Settings.USERS == 6)
                {
                    top_left_carousel.appendItems(result);
                    lower_left_carousel.appendItems(result);
                    top_right_carousel.appendItems(result);
                    lower_right_carousel.appendItems(result);
                    middle_right_carousel.appendItems(result);
                    middle_left_carousel.appendItems(result);
                }



            }
        }
    }
    TouchToBegin
    {
        id: top_left_begin
        x: 346+280; y: 130
        color: "blue"
        visible: Settings.USERS != 2
        enabled: visible
        rotation: 180
        //onYellowPressed: {top_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {top_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}

    }
    TouchToBegin
    {
        id: top_right_begin
        x: Settings.USERS == 2 ? 820+280 : 1306+280; y: 130
        color: "blue"
        rotation: 180
        enabled: visible
        //onGreenPressed: {top_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {top_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}
    }
    TouchToBegin
    {
        id: lower_left_begin
        x: 346; y: 960
        color: "blue"
        visible: Settings.USERS != 2
        enabled: visible
        //onBluePressed: {lower_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {lower_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}
    }
    TouchToBegin
    {
        id: lower_right_begin
        x: Settings.USERS == 2 ? 780 : 1306; y: 960
        color: "blue"
        //onRedPressed: {lower_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {lower_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}
    }
    TouchToBegin
    {
        id: middle_left_begin
        x: 130
        y: 400
        color: "blue"
        visible: Settings.USERS == 6
        enabled: visible
        rotation: 90
        //onYellowPressed: {top_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {middle_left_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}

    }
    TouchToBegin
    {
        id: middle_right_begin
        x: 1790; y: 680
        color: "blue"
        rotation: 270
        visible: Settings.USERS == 6
        enabled: visible
        //onGreenPressed: {top_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}
        onTouchToBeginPressed: {if(active) {middle_right_carousel.opacity = active ? 1.0 : 0.0; gallery.carouselActivate()}}
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
        color: Settings.CAROUSEL_COLOR
        whichScreen: "top left"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            carouselImageRelease(image, touchPoint, imageX, imageY)
        }
        onTimeOut: {if(Settings.USERS !== 2) {top_left_begin.visible = true;isAllTouchToBeginOn()}}
    }
    Carousel
    {
        id: top_right_carousel
        x: Settings.USERS == 2 ? 720 + 480 : 1201 + 480
        y: 315
        topScreen: true
        rotation: 180
        opacity: 0.0
        color: Settings.CAROUSEL_COLOR
        whichScreen: "top right"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            carouselImageRelease(image, touchPoint, imageX, imageY)
        }
        onTimeOut: {top_right_begin.visible = true;isAllTouchToBeginOn()}
    }

    //lower screen
    Carousel
    {
        id: lower_left_carousel
        x: 241
        y: 765
        opacity: 0.0
        color: Settings.CAROUSEL_COLOR
        whichScreen: "lower left"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            carouselImageRelease(image, touchPoint, imageX, imageY)
        }
        onTimeOut: {if(Settings.USERS !== 2) {lower_left_begin.visible = true;isAllTouchToBeginOn()}}
    }
    Carousel
    {
        id: lower_right_carousel
        x: Settings.USERS == 2 ? 720 : 1201
        y: 765
        opacity: 0.0
        color: Settings.CAROUSEL_COLOR
        whichScreen: "lower right"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            carouselImageRelease(image, touchPoint, imageX, imageY)
        }
        onTimeOut: {lower_right_begin.visible = true;isAllTouchToBeginOn()}
    }

    //Middle
    Carousel
    {
        id: middle_right_carousel
        x: 1605
        y: 780
        rotation: 270
        opacity: 0.0
        color: Settings.CAROUSEL_COLOR
        whichScreen: "middle right"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY) ||
                   gallery.isImageInPairingBox(middle_right_carousel,image, touchPoint, imageX, imageY)  )
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_left_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_right_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(middle_right_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(middle_right_carousel);
                target_x = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y - image.width;
                target_y = pairing_box_coordinates.x - image.height - 50;
            }
            else
            {
                return;
            }
            gallery.addImageToFavorites(image, touchPoint, imageX, imageY);

            image.recycle(target_x,target_y);
        }
        onTimeOut: {if(Settings.USERS === 2) {middle_left_begin.visible = true;isAllTouchToBeginOn()}}
    }
    Carousel
    {
        id: middle_left_carousel
        x: 315
        y: 300
        rotation: 90
        opacity: 0.0
        color: Settings.CAROUSEL_COLOR
        whichScreen: "middle left"
        referenceOverlayArea: activeDetailHolder
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
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
            gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY) ||
            gallery.isImageInPairingBox(middle_left_carousel,image, touchPoint, imageX, imageY) )
            {
                image.turnSmall(touchPoint.x, touchPoint.y);
            }
            else
            {
                image.turnBack(touchPoint.x, touchPoint.y);
            }
        }
        onImageFinishedDragging:
        {
            var pairing_box_coordinates;
            var target_x;
            var target_y;
            if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y + 50;
            }
            else if(gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_left_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
                target_x = Settings.SCREEN_WIDTH - pairing_box_coordinates.x - image.width;
                target_y = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y- image.height - top_right_carousel.pairingHeight;
            }
            else if(gallery.isImageInPairingBox(middle_left_carousel,image, touchPoint, imageX, imageY))
            {
                pairing_box_coordinates = pairingBoxCoordinates(middle_right_carousel);
                target_x = Settings.SCREEN_HEIGHT - pairing_box_coordinates.y - image.width;
                target_y = pairing_box_coordinates.x - image.height - 50;
            }
            else
            {
                return;
            }
            gallery.addImageToFavorites(image, touchPoint, imageX, imageY);

            image.recycle(target_x,target_y);
        }
        onTimeOut: {if(Settings.USERS === 2) {middle_right_begin.visible = true;isAllTouchToBeginOn()}}
    }

    Item
    {
        id: activeDetailHolder
        anchors.fill: parent
    }

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

    function isImageInPairingBox(carousel,image, touchPoint, imageX, imageY)
    {
//        console.log(carousel.whichScreen, " gallery!! touchPoint.x = ", touchPoint.x, " touchPoint.y = ", touchPoint.y,
//                    imageX, imageY)
        return carousel.pairingBox.contains(image.mapToItem(carousel.pairingBox, touchPoint.x, touchPoint.y)) && carousel.paired && carousel.pairedEnabled
        var middleX = imageX + touchPoint.x//image.x + image.width * 1/2;
        var middleY = imageY + touchPoint.y//image.y + image.height * 1/2;

        if(image.topScreen && !image.whichScreen.includes("attract"))
        {
            middleX = Settings.SCREEN_WIDTH - middleX;
            middleY = Settings.SCREEN_HEIGHT - middleY;
        }
        if(carousel.whichScreen === "middle right")
        {
            var temp = middleX
            middleX = middleY;
            middleY = Settings.SCREEN_HEIGHT -(temp);
        }
        if(carousel.whichScreen === "middle left")
        {
            var temp2 = middleY;
            middleY = middleX;
            middleX = Settings.SCREEN_WIDTH - temp2 + carousel.pairingHeight;
        }

        var pairing_box_coordinates = pairingBoxCoordinates(carousel)
        var pairing_x = pairing_box_coordinates.x;
        var pairing_y = pairing_box_coordinates.y;

        var pairing_width = carousel.whichScreen.includes("middle") ? carousel.pairingHeight :carousel.pairingWidth;
        var pairing_height = carousel.whichScreen.includes("middle") ? carousel.pairingWidth :carousel.pairingHeight;

        //console.log(carousel.whichScreen, "middleX = ", middleX, " middleY = ", middleY, "pairing_x = ", pairing_x, "pairing_y = ", pairing_y,
        //            "pairing_width = ", pairing_width, " pairing_height = ", pairing_height)


        if(middleX > pairing_x && middleX < pairing_x + pairing_width&&
                middleY > pairing_y && middleY < pairing_y + pairing_height)
        {
            if(carousel.paired && carousel.pairedEnabled)
            {
                console.log("in pairing box!!!")
                return true;

            }
        }
        else
        {
            return false;
        }
        return false;
    }
    function addImageToFavorites(image, touchPoint, imageX, imageY)
    {

        if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY) && lower_left_carousel.currentCode && lower_left_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(lower_left_carousel.currentCode, image.item.id, lower_left_carousel);
        }
        else if(gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY) && lower_right_carousel.currentCode && lower_right_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(lower_right_carousel.currentCode, image.item.id, lower_right_carousel);
        }
        else if(gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY) && top_right_carousel.currentCode && top_right_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(top_right_carousel.currentCode, image.item.id, top_right_carousel);
        }
        else if(gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY) && top_left_carousel.currentCode && top_left_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(top_left_carousel.currentCode, image.item.id, top_left_carousel);
        }
        else if(gallery.isImageInPairingBox(middle_right_carousel,image, touchPoint, imageX, imageY) && middle_right_carousel.currentCode && middle_right_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(middle_right_carousel.currentCode, image.item.id, middle_right_carousel);
        }
        else if(gallery.isImageInPairingBox(middle_left_carousel,image, touchPoint, imageX, imageY) && middle_left_carousel.currentCode && middle_left_carousel.checkItemsOfPairing(image.item.id))
        {
            //console.log("add item = ", image.item.id)
            HeistClient.addItem(middle_left_carousel.currentCode, image.item.id, middle_left_carousel);
        }
    }
    function attractImageIsInPairingBox(image, touchPoint, imageX, imageY)
    {
        if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY)||
        gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY)||
        gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY)||
        gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
        {
            image.turnSmall(touchPoint.x, touchPoint.y);
        }
        else
        {
            image.turnBack(touchPoint.x, touchPoint.y);
        }
    }
    function attractImageReleased(image, touchPoint, imageX, imageY)
    {
        var pairing_box_coordinates;
        var target_x;
        var target_y;
        if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY))
        {
            pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY))
        {
            pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY))
        {
            pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_left_carousel.pairingHeight + 50;
        }
        else if(gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
        {
            pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_right_carousel.pairingHeight + 50;
        }
        else
        {
            return;
        }
        gallery.addImageToFavorites(image, touchPoint, imageX, imageY);

        image.recycle(target_x,target_y);
    }

    function carouselImageRelease(image, touchPoint, imageX, imageY)
    {
        var pairing_box_coordinates;
        var target_x;
        var target_y;
        var add_success_carousel;
        if(gallery.isImageInPairingBox(lower_left_carousel,image, touchPoint, imageX, imageY))
        {
            add_success_carousel = lower_left_carousel
            pairing_box_coordinates = pairingBoxCoordinates(lower_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(lower_right_carousel,image, touchPoint, imageX, imageY))
        {
            add_success_carousel = lower_right_carousel
            pairing_box_coordinates = pairingBoxCoordinates(lower_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y - image.height;
        }
        else if(gallery.isImageInPairingBox(top_left_carousel,image, touchPoint, imageX, imageY))
        {
            add_success_carousel = top_left_carousel
            pairing_box_coordinates = pairingBoxCoordinates(top_left_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_left_carousel.pairingHeight + 50;
        }
        else if(gallery.isImageInPairingBox(top_right_carousel,image, touchPoint, imageX, imageY))
        {
            add_success_carousel = top_right_carousel
            pairing_box_coordinates = pairingBoxCoordinates(top_right_carousel);
            target_x = pairing_box_coordinates.x;
            target_y = pairing_box_coordinates.y + top_right_carousel.pairingHeight + 50;
        }
        else
        {
            return;
        }
        gallery.addImageToFavorites(image, touchPoint, imageX, imageY);

        image.recycle(target_x,target_y);

        add_success_carousel.startAddSuccess()
    }

    function isAllTouchToBeginOn()
    {
        if(Settings.USERS === 2)
        {
            if(top_right_begin.visible && lower_right_begin.visible)
            {
                turnOnAtrract()
                return true
            }
            else
            {
                return false
            }
        }
        else if(Settings.USERS === 4)
        {
            if(top_left_begin.visible && top_right_begin.visible &&
                    lower_left_begin.visible && lower_right_begin.visible)
            {
                turnOnAtrract()
                return true
            }
            else
            {
                return false
            }
        }
        else if(Settings.USERS === 6)
        {
            if(top_left_begin.visible && top_right_begin.visible &&
                    lower_left_begin.visible && lower_right_begin.visible &&
                    middle_left_begin.visible && middle_right_begin.visible)
            {
                turnOnAtrract()
                return true
            }
            else
            {
                return false
            }
        }
    }
}
