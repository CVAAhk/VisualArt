import QtQuick 2.0
import "."

Item
{
    id: root

    property bool topScreen: false

    signal canPaginate()
    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, string title);
    Image {
        id: bkg
        source: "content/POI/Asset 11.png"

        clip: true

        Browser {
            id: browser
            x: -root.x;y: 55
            height: 190
            width: 960
            headerHeight: height/3
            topScreen: root.topScreen
            onCreateImage:
            {
                root.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight, title)
            }

            property real contentX: layout.contentX

            property int nextCount: 1

            property int pageCount: layout.model ? layout.model.count / 50 : 0
            onContentXChanged: pagination()



            function pagination()
            {
                if(nextCount === pageCount)
                {
                    busy = layout.atXBeginning
                    if(busy){
                        nextCount++;
                        console.log("can paginate!!")
                        root.canPaginate();
                    }
                }else if(layout.model && layout.model.count)
                {
                    budy = false;
                }
            }

        }
    }

    Image
    {
        id: left_arrow
        source: "content/POI/Asset 10.png"
        x: -10; y: 108
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.increaseCurrentItem();
        }
    }
    Image {
        id: right_arrow
        source: "content/POI/Asset 9.png"
        anchors.right: bkg.right
        anchors.rightMargin: -10
        y: 108
        opacity: browser.currentIndex > 0 ? 1.0 : 0.5
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.decreaseCurrentItem();
        }
    }


    function appendItems(result)
    {
        browser.append(result);
    }
    function imageRemovedFromScene(filepath)
    {
        browser.imageRemovedFromScene(filepath);
    }
}
