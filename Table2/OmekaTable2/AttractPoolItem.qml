import QtQuick 2.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    property int randomCount: 4

    property var allResults:[]
    property int maxResults
    property bool carouselActivate: false


    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, bool tapOpen, string whichScreen);

    signal imageDragged(var image);

    signal imageFinishedDragging(var image);

    Component.onCompleted: {
        Omeka.getAllPages(3, root)
        //Omeka.getPage(1, root)
    }

    /*!Dynamically load omeka query results into browser*/
    Connections {
        target: Omeka
        onRequestComplete:{
            if(result.context === root){
                allResults.push(result)
                if(allResults.length == 124)
                {
                    maxResults = 124//result.file_count;
                    var random_id1 = Math.floor(randomizeId());
                    var random_id2 = Math.floor(randomizeId());
                    var random_id3 = Math.floor(randomizeId());
                    var random_id4 = Math.floor(randomizeId());

                    imageItem1.itemResult = allResults[random_id1]
                    imageItem2.itemResult = allResults[random_id2]
                    imageItem3.itemResult = allResults[random_id3]
                    imageItem4.itemResult = allResults[random_id4]

                    if(!carouselActivate) random_timer.start();
                }
            }
        }
    }

    function randomizeId()
    {
        return Math.random() * maxResults
    }

    //lower screen
    AttractImageItem
    {
        id : imageItem1
        x: 750;y: 539
        visible: !carouselActivate
        enabled: !carouselActivate
        onCreateImage:
        {
            imageHolder.createImage(source,imageX + x,imageY + y,imageRotation,imageWidth,imageHeight, tapOpen, "attract lower left")
            var random_id1 = Math.floor(randomizeId());
            imageItem1.itemResult = allResults[random_id1]
        }
        onRecreateItem:
        {
            var random_id1 = Math.floor(randomizeId());
            imageItem1.itemResult = allResults[random_id1]
        }
    }
    AttractImageItem
    {
        id: imageItem2
        x: 970;y: 539
        visible: !carouselActivate
        enabled: !carouselActivate
        onCreateImage:
        {
            imageHolder.createImage(source,imageX + x,imageY + y,imageRotation,imageWidth,imageHeight, tapOpen, "attract lower right")
            var random_id2 = Math.floor(randomizeId());
            imageItem2.itemResult = allResults[random_id2]
        }
        onRecreateItem:
        {
            var random_id2 = Math.floor(randomizeId());
            imageItem2.itemResult = allResults[random_id2]
        }
    }
    //top screen
    AttractImageItem
    {
        id : imageItem3
        x: 750; //y: 459
        anchors.bottom: imageItem1.top
        anchors.bottomMargin: 30
        topScreen: true
        rotation: 180
        visible: !carouselActivate
        enabled: !carouselActivate
        onCreateImage:
        {
            imageHolder.createImage(source,imageX + x + 30,imageY + 509,imageRotation,imageWidth,imageHeight, tapOpen, "attract top left")
            var random_id3 = Math.floor(randomizeId());
            imageItem3.itemResult = allResults[random_id3]
        }
        onRecreateItem:
        {
            var random_id3 = Math.floor(randomizeId());
            imageItem3.itemResult = allResults[random_id3]
        }
    }

    AttractImageItem
    {
        id : imageItem4
        x: 970; //y: 459
        anchors.bottom: imageItem2.top
        anchors.bottomMargin: 30
        topScreen: true
        rotation: 180
        visible: !carouselActivate
        enabled: !carouselActivate
        onCreateImage:
        {
            imageHolder.createImage(source,imageX + x + 30,imageY + 509,imageRotation,imageWidth,imageHeight, tapOpen, "attract top right")
            var random_id4 = Math.floor(randomizeId());
            imageItem4.itemResult = allResults[random_id4]
        }
        onRecreateItem:
        {
            var random_id4 = Math.floor(randomizeId());
            imageItem4.itemResult = allResults[random_id4]
        }
    }

    CollectionImageHolder
    {
        id: imageHolder
        x: -root.x; y: -root.y
        width: Settings.SCREEN_WIDTH
        height: Settings.SCREEN_HEIGHT

        antialiasing: true

        onImageDeleted:
        {
            //console.log("delete filepath = ",filepath, "whichScreen = ", whichScreen)

            root.removeAttractImage(filepath, whichScreen);
        }
        onImageDragged:
        {
            root.imageDragged(image);
        }
        onImageFinishedDragging:
        {
            root.imageFinishedDragging(image);
        }
    }

    function removeAttractImage(filePath, whichScreen)
    {
        if(whichScreen === "attract lower left") imageItem1.imageRemovedFromScene(filePath)
        if(whichScreen === "attract lower right") imageItem2.imageRemovedFromScene(filePath)
        if(whichScreen === "attract top left") imageItem3.imageRemovedFromScene(filePath)
        if(whichScreen === "attract top right") imageItem4.imageRemovedFromScene(filePath)
    }

    Timer
    {
        id: random_timer
        interval: Settings.ATTRACT_RANDOM_TIMER
        repeat: true
        onTriggered:
        {
            var random_id1 = Math.floor(randomizeId());
            var random_id2 = Math.floor(randomizeId());
            var random_id3 = Math.floor(randomizeId());
            var random_id4 = Math.floor(randomizeId());

            imageItem1.itemResult = allResults[random_id1]
            imageItem2.itemResult = allResults[random_id2]
            imageItem3.itemResult = allResults[random_id3]
            imageItem4.itemResult = allResults[random_id4]
        }
    }

    function stopAttractTimer()
    {
        random_timer.stop();
    }


}
