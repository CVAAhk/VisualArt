import QtQuick 2.0
import "settings.js" as Settings
import "."

Item
{
    //=========================================================================
    // ROOT ITEM PROPERTIES
    //=========================================================================
    property bool debugView: Settings.DEBUG_VIEW

    property var imageItems: []

    //property alias itemsLength: imageItems.length

    property int maxImages: 5

    property double maxImageHeight: 0.0
    property var maxImage: null

    //=========================================================================
    // ROOT ITEM SETTINGS
    //=========================================================================
    id: root
    // clip: true

    signal imageDeleted(string filepath, string whichScreen);

    signal imageAdded(var image);

    signal imageDragged(var image);

    signal imageFinishedDragging(var image);

    signal imageFinishedRecycle();

    signal resetBrowser();
    //=========================================================================
    // UI ELEMENTS
    //=========================================================================
//    Rectangle
//    {
//        color: "red"
//        anchors.fill: parent
//        opacity: 0.5
//        visible: root.debugView
//    }

    //=========================================================================
    // FUNCTIONS
    //=========================================================================
    NumberAnimation {
        id: image_pop
        duration: 200
        easing.type: Easing.InOutQuad
    }

    property var allImageItems: []

    Repeater
    {
        model: root.maxImages + 1

        Detail { }

        onItemAdded:
        {
            allImageItems.push(item);
        }
    }

    function getNextImage()
    {
        for(var i = 0; i != allImageItems.length; i++)
        {
            if(!allImageItems[i].inUse)
            {
                return allImageItems[i];
            }
        }


        allImageItems[0].inUse = false;
        return allImageItems[0];
    }

    function createImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, tapOpen, whichScreen)
    {
        console.log("Creating image in holder " + filepath + " " + startX + " " + startY +
                    " " + imageRotation + ", width: " + imageWidth + ", height: " + imageHeight);

        var imageItem = getNextImage();
        if (!imageItem.inUse)
        {
            imageItem.inUse = true;
            imageItem.active = false;
            imageItem.openedAttract = false;

            //imageItem.item = null;
            imageItem.item = ItemManager.selectedItems[ItemManager.selectedItems.length - 1];
            imageItem.source = filepath;
            console.log("selected itemdata = ", imageItem.item)
            if(tapOpen)
            {
                image_pop.target = imageItem;
                if(whichScreen.includes("attract") &&whichScreen.includes("right"))
                {
                    //imageItem.y = startY - root.y;
                    image_pop.property = "x";
                    if(imageRotation > 0)
                    {
                        imageItem.y = startY - imageItem.oldImageHeight;
                        //imageItem.rotation = imageRotation;
                    }
                    else
                    {
                        imageItem.y = startY;
                    }

                    image_pop.from = Settings.ATTRACT_RIGHT_X;
                    image_pop.to = startX;
                }
                else if(whichScreen.includes("attract") &&whichScreen.includes("left"))
                {
                    //imageItem.y = startY - root.y;
                    image_pop.property = "x";
                    if(imageRotation > 0)
                    {
                        imageItem.y = startY - imageItem.oldImageHeight;
                        //imageItem.rotation = imageRotation;
                    }
                    else
                    {
                        imageItem.y = startY;
                    }

                    image_pop.from = Settings.ATTRACT_LEFT_X;
                    image_pop.to = startX;
                }
                else
                {
                    imageItem.x = startX;
                    image_pop.property = "y";

//                    if(imageRotation > 0)
//                    {
//                        image_pop.from = 315 - imageHeight;
//                        image_pop.to = startY - imageHeight;
//                    }
//                    else
//                    {
                       image_pop.from = 765;
                       image_pop.to = startY;
//                    }
                }

                image_pop.start();
            }
            else
            {
                imageItem.x = startX;
                imageItem.y = startY;
            }

            imageItem.imageWidth = 247;
            imageItem.antialiasing = true;

            imageItem.imageDragged.connect(root.imageDragged);
            imageItem.finishedDragging.connect(root.imageFinishedDragging);
            //imageItem.finishedRecycle.connect(root.imageFinishedRecycle);
            imageItem.imagePressed.connect(imagePressed);

            imageItem.deleteImage.connect(deleteImage);
            imageItem.finishedRecycle.connect(imageFinishedRecycle);
            imageItem.whichScreen = whichScreen;


            //imageItem.rotation = imageRotation;
            if(whichScreen.includes("attract"))
            {
                imageItem.topScreen = false;
                imageItem.rotation = imageRotation;
            }
            else
            {
                imageItem.rotation = 0;
                imageItem.topScreen = imageRotation > 0;
            }


            imageItem.scale = 1;

            if(imageItems.length == 0) maxImageHeight = 10;
            maxImageHeight += 0.01;
            imageItem.z = maxImageHeight;

            maxImage = imageItem;
            imageItems.push(imageItem);
            //console.log("Added!images holder number of image items: ", imageItems.length)

            root.imageAdded(imageItem);

            if(imageItems.length > root.maxImages)
            {
                root.deleteImage(imageItems[0]);
            }

            imageItem.visible = true;
        }

        return imageItem;
    }

    function deleteImage(selectedItem)
    {
        if(selectedItem)
        {
            var deleteIndex = imageItems.indexOf(selectedItem);
            imageItems.splice(deleteIndex, 1);

            imageDeleted(selectedItem.source, selectedItem.whichScreen);

            selectedItem.visible = false;
            selectedItem.x = -10000;
            selectedItem.y = 0;

            selectedItem.inUse = false;
            selectedItem.item = null;

            selectedItem.active = false;
            selectedItem.openedAttract = false;

            //if(imagesCount() === 0) reset_timer.start();
        }
    }

    function imagePressed(selectedItem)
    {
        if(selectedItem == maxImage)
            return;
        maxImageHeight += 0.01;
        selectedItem.z = maxImageHeight;
        maxImage = selectedItem;

        var deleteIndex = imageItems.indexOf(selectedItem);

        imageItems.splice(deleteIndex, 1);
        imageItems.push(selectedItem);
        deleteIndex = imageItems.indexOf(selectedItem);
    }   


    function imagesCount()
    {
        return imageItems.length;
    }

    function reset()
    {
        while(imageItems.length > 0)
        {
            deleteImage(imageItems[0]);
        }
    }
    Timer
    {
        id: reset_timer
        interval: Settings.ATTRACT_RANDOM_TIMER
        onTriggered: root.resetBrowser();
    }
}
