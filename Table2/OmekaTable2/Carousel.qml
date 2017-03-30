import QtQuick 2.0
import "."

Item
{
    id: root

    property bool topScreen: false
    property string color: "#2b89d9"//blue

    signal canPaginate()
    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight);

    enabled: opacity == 1.0
    Behavior on opacity {
        NumberAnimation
        {
            duration: 200
        }
    }
    Filter
    {
        id: filter
        color: root.color
        x: -207; y: 10
    }

    Image
    {
        id: selected_image

        visible: browser.touch_area.creatingImage

        source: ""
        //height: browser.imageHeight
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
        source: "content/POI/carousel-bkg.png"

        Image
        {
            id: filter_btn
            source: "content/POI/filter-btn.png"
            x: 10; y: 10

            OmekaText
            {
                id: filter_text

                _font: Style.filterFont
                text: "FILTER"
                textColor: root.color
                anchors.centerIn: parent
                visible: false
            }

            MultiPointTouchArea
            {
                anchors.fill: parent
                property bool active: false
                onPressed:
                {
                    active = !active;
                    filter_btn.source = active ? "content/POI/filter-btn-bkg.png" : "content/POI/filter-btn.png"
                    filter_text.visible = active
                }
            }
        }

        Image
        {
            id: send_to_mobile_btn
            source: "content/POI/send-to-mobile.png"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            MultiPointTouchArea
            {
                anchors.fill: parent
                onPressed:
                {

                }
            }
        }

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
                root.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight)
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
                    busy = (layout.currentIndex === layout.count -4)//layout.atXEnd
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
