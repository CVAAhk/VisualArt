import QtQuick 2.0
import "settings.js" as Settings

Item
{
    //=========================================================================
    // ROOT ITEM PROPERTIES
    //=========================================================================
    property bool debugView: Settings.DEBUG_VIEW

    property var imageItems: []

    //property alias itemsLength: imageItems.length

    property int maxImages: 1000

    //=========================================================================
    // ROOT ITEM SETTINGS
    //=========================================================================
    id: root
    // clip: true

    signal imageDeleted(string filepath, bool topScreen);

    signal imageAdded(var image);

    signal imageDragged(var image);

    signal imageFinishedDragging(var image);

    signal imageFinishedRecycle();
    //=========================================================================
    // UI ELEMENTS
    //=========================================================================
    Rectangle
    {
        color: "red"
        anchors.fill: parent
        opacity: 0.5
        visible: root.debugView
    }

    //=========================================================================
    // FUNCTIONS
    //=========================================================================
    function createImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight)
    {
        console.log("Creating image in holder " + filepath + " " + startX + " " + startY +
                    " " + imageRotation + ", width: " + imageWidth + ", height: " + imageHeight);

        var component = Qt.createComponent("DetailImage.qml");

        if (component.status === Component.Ready)
        {
            console.log("Component ready")

            var imageSource = filepath.toString();

            var imageItem = component.createObject(root);
            imageItem.source = imageSource;

            imageItem.x = startX - root.x;
            imageItem.y = startY - root.y;
            //imageItem.imageWidth = imageWidth;
            //imageItem.imageHeight = imageHeight;
            //imageItem.scale = 0.5;
            //imageItem.x -= imageItem.width / 4;
            //imageItem.y -= imageItem.height / 4;

            //imageItem.imageDragged.connect(root.imageDragged);
            //imageItem.finishedDragging.connect(root.imageFinishedDragging);
            //imageItem.finishedRecycle.connect(root.imageFinishedRecycle);

            //imageItem.collectionHolder = root;
/*
            imageItem.title = collections.getImageTitle(filepath);
            imageItem.date = collections.getImageDate(filepath);
            imageItem.artist = collections.getImageArtist(filepath);
            imageItem.description = collections.getImageDescription(filepath);
*/
            if(imageRotation)
            {
                imageItem.rotation = imageRotation;
                if(imageRotation > 0)
                {
                    //imageItem.topScreen = true;
                }
            }


            //imageItem.deleteImage.connect(deleteImage);

            imageItems.push(imageItem);

            imageItem.z = imageItems.length;

            //imageItem.imageTimer.start();

            root.imageAdded(imageItem);

            if(imageItems.length > root.maxImages)
            {
                root.deleteImage(imageItems[0]);
            }
        }
        else if(component.status === Component.Error)
        {
          console.log("error is ", component.errorString());
        }

        return component;
    }

    function deleteImage(selectedItem)
    {
        if(selectedItem)
        {
            var deleteIndex = imageItems.indexOf(selectedItem);
            imageItems.splice(deleteIndex, 1);

            imageDeleted(selectedItem.source, selectedItem.topScreen);

            selectedItem.destroy();
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
