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
    function createImage(filepath, startX, startY, imageRotation, imageWidth, imageHeight, title, whichScreen)
    {
        console.log("Creating image in holder " + filepath + " " + startX + " " + startY +
                    " " + imageRotation + ", width: " + imageWidth + ", height: " + imageHeight +
                    " title : ", title);

        var component = Qt.createComponent("Detail.qml");

        if (component.status === Component.Ready)
        {
            console.log("Component ready")

            var imageSource = filepath.toString();

            var imageItem = component.createObject(root);
            imageItem.source = imageSource;

            imageItem.x = startX - root.x;
            imageItem.y = startY - root.y;
            imageItem.imageWidth = 247;
            imageItem.imageHeight = imageWidth / imageHeight * 247;
            imageItem.title = title;
            //imageItem.scale = 0.5;
            //imageItem.x -= imageItem.width / 4;


            //imageItem.imageDragged.connect(root.imageDragged);
            //imageItem.finishedDragging.connect(root.imageFinishedDragging);
            //imageItem.finishedRecycle.connect(root.imageFinishedRecycle);
            imageItem.whichScreen = whichScreen;
            if(imageRotation)
            {
                imageItem.rotation = imageRotation;
                if(imageRotation > 0)
                {
                    //imageItem.topScreen = true;
                    imageItem.y = imageItem.y - 2 * imageItem.height;
                    console.log("imageItem.y = ", imageItem.y, " imageItem.height = ", imageItem.height)
                }
            }


            imageItem.deleteImage.connect(deleteImage);

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

            imageDeleted(selectedItem.source, selectedItem.whichScreen);

            selectedItem.visible = false;
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
