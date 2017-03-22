import QtQuick 2.0
import "."

Item
{
    id: root

    property bool topScreen: false

    signal canPaginate()
    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, string title);
    Image
    {
        id: selected_image

        visible: browser.touch_area.creatingImage

        source: ""
        height: browser.imageHeight
        fillMode: Image.PreserveAspectFit

        property int screenX: 0
        property int screenY: 0

        x: screenX
        y: screenY
        z: 10

        property string title: ""
        property string description: ""
    }

    Image {
        id: bkg
        source: "content/POI/Asset 11.png"

        clip: true

        Browser {
            id: browser
            x: 0;y: 55
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

            property var selected_image: selected_image
            onContentXChanged: pagination()



            function pagination()
            {
                if(nextCount === pageCount)
                {
                    busy = layout.atXEnd
                    if(busy){
                        nextCount++;
                        console.log("can paginate!!")
                        root.canPaginate();
                    }
                }else if(layout.model && layout.model.count)
                {
                    busy = false;
                }
            }

        }
    }
    Text
    {
        id: item_count
        text: browser.currentIndex + 1 + " OF 490"
        color: "#888888"
        anchors.horizontalCenter: bkg.horizontalCenter
        y: 247
    }

    Image
    {
        id: left_arrow
        source: "content/POI/Asset 10.png"
        x: 0; y: 123
        opacity: browser.currentIndex > 0 ? 1.0 : 0.5
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.decreaseCurrentItem();
        }
    }
    Image {
        id: right_arrow
        source: "content/POI/Asset 9.png"
        anchors.right: bkg.right
        y: 123
        opacity: browser.currentIndex < 490 ? 1.0 : 0.5
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.increaseCurrentItem();
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
