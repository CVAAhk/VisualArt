import QtQuick 2.0
import "."
import "settings.js" as Settings
Item
{
    id: root
    property int randomCount: 2

    property int fileId1 : -1

    property int fileId2 : -1

    property var allResults:[]//: ({})
    property int maxResults: 490
    property int resultCount: 0

    property var model: ListModel{}

    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight);


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

                    imageItem1.itemResult = allResults[random_id1]
                    imageItem2.itemResult = allResults[random_id2]
                }
            }
        }
    }

    function randomizeId()
    {
        return Math.random() * maxResults
    }

    AttractImageItem
    {
        id : imageItem1
        x: 750
        onCreateImage:
        {
            console.log("create image in attractPoolItem")
            root.createImage(source,imageX + x,imageY,imageRotation,imageWidth,imageHeight)
            var random_id1 = Math.floor(randomizeId());
            imageItem1.itemResult = allResults[random_id1]
        }
    }
    AttractImageItem
    {
        id: imageItem2
        x: 970
        onCreateImage:
        {
            root.createImage(source,imageX + x,imageY,imageRotation,imageWidth,imageHeight)

            var random_id2 = Math.floor(randomizeId());
            imageItem2.itemResult = allResults[random_id2]
        }
    }



//    Timer
//    {
//        id: random_timer
//        interval: Settings.ATTRACT_RANDOM_TIMER
//        repeat: true
//        onTriggered:
//        {
//            imageItem1.setInfo();
//            imageItem2.setInfo();
//        }
//    }


}
