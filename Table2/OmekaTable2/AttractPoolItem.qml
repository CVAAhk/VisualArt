import QtQuick 2.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    property int randomCount: 4

    property var allResults:[]
    property int maxResults: 490
    property bool carouselActivate: false


    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, string whichScreen);


    Component.onCompleted: {
        Omeka.getAllPages(10, root)
        //Omeka.getPage(1, root)
    }

    /*!Dynamically load omeka query results into browser*/
    Connections {
        target: Omeka
        onRequestComplete:{
            if(result.context === root){
                allResults.push(result)
                if(allResults.length == maxResults)
                {
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
        onCreateImage:
        {
            //console.log("create image in attractPoolItem")
            root.createImage(source,imageX + x,imageY + y,imageRotation,imageWidth,imageHeight, "attract lower left")
            var random_id1 = Math.floor(randomizeId());
            imageItem1.itemResult = allResults[random_id1]
        }
    }
    AttractImageItem
    {
        id: imageItem2
        x: 970;y: 539
        onCreateImage:
        {
            root.createImage(source,imageX + x,imageY + y,imageRotation,imageWidth,imageHeight, "attract lower right")

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
        onCreateImage:
        {
            //console.log("create image in attractPoolItem")
            root.createImage(source,imageX + x + 30,imageY + 509,imageRotation,imageWidth,imageHeight, "attract top left")
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
        onCreateImage:
        {
            //console.log("create image in attractPoolItem")
            root.createImage(source,imageX + x + 30,imageY + 509,imageRotation,imageWidth,imageHeight, "attract top right")
            var random_id4 = Math.floor(randomizeId());
            imageItem4.itemResult = allResults[random_id4]
        }
    }

    function removeAttractImage(filePath, whichScreen)
    {
        if(whichScreen === "attract lower left") imageItem1.imageRemovedFromScene(filePath)
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
