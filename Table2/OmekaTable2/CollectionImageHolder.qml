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
        model: root.maxImages

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

            imageItem.item = ItemManager.selectedItems[ItemManager.selectedItems.length - 1];

            if(tapOpen)
            {
                image_pop.target = imageItem;
                if(whichScreen.includes("attract") &&whichScreen.includes("right"))
                {
                    imageItem.y = startY - root.y;
                    image_pop.property = "x";
                    image_pop.from = Settings.ATTRACT_RIGHT_X;
                    image_pop.to = startX;
                }
                else if(whichScreen.includes("attract") &&whichScreen.includes("left"))
                {
                    imageItem.y = startY - root.y;
                    image_pop.property = "x";
                    image_pop.from = Settings.ATTRACT_LEFT_X;
                    image_pop.to = startX;
                }
                else
                {
                    imageItem.x = startX - root.x;
                    image_pop.property = "y";

                    if(imageRotation > 0)
                    {
                        image_pop.from = 315 - imageHeight;
                        image_pop.to = startY - root.y - imageHeight;
                    }
                    else
                    {
                       image_pop.from = 765;
                        image_pop.to = startY - root.y;
                    }
                }

                image_pop.start();
            }
            else
            {
                imageItem.x = startX - root.x;
                imageItem.y = startY - root.y;
            }

            imageItem.imageWidth = 247;
            imageItem.antialiasing = true;



            //imageItem.imageDragged.connect(root.imageDragged);
            //imageItem.finishedDragging.connect(root.imageFinishedDragging);
            //imageItem.finishedRecycle.connect(root.imageFinishedRecycle);
            imageItem.whichScreen = whichScreen;
            if(imageRotation)
            {
                imageItem.rotation = imageRotation;
            }


            imageItem.deleteImage.connect(deleteImage);

            imageItems.push(imageItem);
            //console.log("Added!images holder number of image items: ", imageItems.length)

            imageItem.z = imageItems.length;

            root.imageAdded(imageItem);

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

            selectedItem.inUse = false;

            selectedItem = null;
        }
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

    function lowerAllImagesZ()
    {
        for(var i = 0; i < imageItems.length; i ++)
        {
            imageItems[i].z --;
        }
    }


}
