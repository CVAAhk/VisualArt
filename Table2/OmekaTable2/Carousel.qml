import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "settings.js" as Settings

Item
{
    id: root

    property bool topScreen: false
    property string color: "#2b89d9"//blue
    property string whichScreen: "lower left"//default
    property var screenTag: whichTag()
    property bool searchByTag: false

    property var selectedParent: null

    property int pairingAbsoluteX: pairing.x + root.x
    property int pairingAbsoluteY: pairing.y + root.y
    property int pairingWidth: pairing.width
    property int pairingHeight: pairing.height

    property bool paired: pairing.paired

    property var currentCode: pairing.currentCode


    Component.onCompleted:
    {
        selected_image.parent = selectedParent;
        imageHolder.parent = selectedParent;
    }

    //submit tag search
    onScreenTagChanged:
    {
        if(screenTag)
        {
            //console.log("whichTag() = ", screenTag);
            searchByTag = true;
            filter.tagHeaderSearchByTag = true;
            browser.clear();
            Omeka.getItemsByTag(screenTag, root)

            filter_text.text = "filter applied: " + screenTag;
        }
    }



    signal canPaginate()
    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, bool tapOpen);
    signal imageDragged(var image);
    signal imageFinishedDragging(var image);

    enabled: opacity == 1.0
    Behavior on opacity {
        NumberAnimation
        {
            duration: 200
        }
    }

    //populate browser with results
    Connections {
        target: Omeka
        onRequestComplete: {
            if(result.context === root) {

                browser.append(result)
            }
        }
    }
    Filter
    {
        id: filter
        color: root.color
        x: -207; y: 10
        whichScreen: root.whichScreen
        opacity: 0.0
        tagHeaderSearchByTag: searchByTag
        onTagHeaderSearchByTagChanged:
        {
            if(!tagHeaderSearchByTag)
            {
                browser.clear();
                Omeka.getPage(1, root);
                searchByTag = tagHeaderSearchByTag;
            }
        }
    }
    Pairing
    {
        id: pairing
        x: 498; y: 10
        color: root.color
        visible: false
        onPairedChanged:
        {
            if(paired)
            {
                console.log("paired!!")
                pairing_text.text = "TAP TO UNPAIR";
                pairing_btn_touch_area.enabled = false;
                unpair_btn_touch_area.enabled = true;
            }
            else
            {
                console.log("unpaired!!")
                pairing_text.text = "PAIRING";
                pairing.visible = false;
                pairing_btn.visible = false;
                send_to_mobile_btn.visible = true;
                unpair_btn_touch_area.enabled = false;
                pairing_btn_touch_area.enabled = true;
                pairing_btn_touch_area.active = false;
            }
        }
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

    //Carousel UI
    //header
    Rectangle
    {
        id: carousel_header_bkg
        anchors.fill: carousel_header
        color: root.color
        visible: false
    }
    Image
    {
        id: carousel_header
        source: "content/POI/carousel-header.png"
        visible: false

    }
    OpacityMask
    {
        anchors.fill: carousel_header_bkg
        source: carousel_header_bkg
        maskSource: carousel_header
    }
    //footer
    Rectangle
    {
        id: carousel_footer_bkg
        anchors.fill: carousel_footer
        color: root.color
        visible: false
    }
    Image
    {
        id: carousel_footer
        source: "content/POI/carousel-footer.png"
        visible: false
        y: 270
    }
    OpacityMask
    {
        anchors.fill: carousel_footer_bkg
        source: carousel_footer_bkg
        maskSource: carousel_footer
    }
    Image
    {
        id: filter_btn
        source: "content/POI/filter-btn.png"
        x: 10; y: 10
        width: filter_text.width + 10


    }
    Rectangle
    {
        id: filter_applied_btn
        width: filter_text.width + 10
        height: 25
        x: 10; y: 10
        radius: 4
        color: "white"
        visible: false
        enabled: true
        OmekaText
        {
            id: filter_text

            _font: Style.filterFont
            text: "FILTER"
            textColor: root.color
            anchors.centerIn: parent
        }
    }
    MultiPointTouchArea
    {
        anchors.fill: filter_applied_btn
        property bool active: false
        onPressed:
        {
            active = !active;
            filter_btn.visible = !active//.source = active ? "content/POI/filter-btn-bkg.png" : "content/POI/filter-btn.png"
            filter_applied_btn.visible = active;
            filter.opacity = active ? 1.0 : 0.0
            if(!active)
            {
                filter.tagHeaderSearchByTag = false;
                filter.resetFilters();
                filter_text.text = "FILTER";
            }

        }
    }

    Image
    {
        id: send_to_mobile_btn
        source: "content/POI/send-to-mobile.png"
        anchors.top: carousel_header_bkg.top
        anchors.right: carousel_header_bkg.right
        anchors.margins: 10
    }
    Rectangle
    {
        id: pairing_btn
        width: pairing_text.width + 10
        height: 25
        anchors.top: carousel_header_bkg.top
        anchors.right: carousel_header_bkg.right
        anchors.margins: 10
        radius: 4
        color: "white"
        visible: false
        OmekaText
        {
            id: pairing_text

            _font: Style.filterFont
            text: "PAIRING"
            textColor: root.color
            anchors.centerIn: parent
        }
    }
    MultiPointTouchArea
    {
        id: pairing_btn_touch_area
        anchors.fill: send_to_mobile_btn
        property bool active: false
        onPressed:
        {
            active = !active;
            pairing.visible = active//.source = active ? "content/POI/filter-btn-bkg.png" : "content/POI/filter-btn.png"
            pairing_btn.visible = active;
            send_to_mobile_btn.visible = !active;
            if(active) {
                pairing.resetPairing();
                pairing.startSession();
            }
        }
        Rectangle{
            color:"blue"
            visible: enabled
            anchors.fill: parent
        }
    }
    MultiPointTouchArea
    {
        id: unpair_btn_touch_area
        anchors.fill: pairing_btn
        enabled: false
        //property bool active: false
        onPressed:
        {
            pairing.startUnpair();
        }
        Rectangle{
            color:"red"
            visible: enabled
            anchors.fill: parent
        }
    }

    Image {
        id: bkg
        y: 40
        source: "content/POI/carousel-white-bkg.png"

        clip: true

        Browser {
            id: browser
            x: 0;y: 15
            height: 190
            width: 960
            headerHeight: height/3
            topScreen: root.topScreen
            onCreateImage:
            {
                //root.createImage(source, imageX, imageY, imageRotation, imageWidth, imageHeight, tapOpen)
                imageHolder.createImage(source, imageX + (root.topScreen?(Settings.SCREEN_WIDTH - root.x):root.x),
                                        imageY + (root.topScreen?(Settings.SCREEN_HEIGHT - root.y):root.y),
                                        imageRotation, imageWidth, imageHeight, tapOpen, root.whichScreen)
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
                        //console.log("can paginate!!")
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
        text: browser.currentIndex + 1 + " OF " + (searchByTag ? browser.listItemsCount : 490)
        color: "#888888"
        anchors.horizontalCenter: bkg.horizontalCenter
        y: 247
    }

    //Move left
    Rectangle
    {
        id: left_arrow_bkg
        anchors.fill: left_arrow
        color: root.color
        visible: false
    }
    Image
    {
        id: left_arrow
        source: "content/POI/Asset 10.png"
        x: 0; y: 123
        visible: false

    }
    OpacityMask
    {
        anchors.fill: left_arrow_bkg
        source: left_arrow_bkg
        maskSource: left_arrow
        opacity: (browser.currentIndex > 0 && browser.listItemsCount) ? 1.0 : 0.5
        Image
        {
            source: "content/POI/left-arrow.png"
            anchors.centerIn: parent
        }

        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.decreaseCurrentItem();
        }
    }
    //Move right
    Rectangle
    {
        id: right_arrow_bkg
        anchors.fill: right_arrow
        color: root.color
        visible: false
    }
    Image
    {
        id: right_arrow
        source: "content/POI/Asset 9.png"
        anchors.right: bkg.right
        y: 123
        visible: false

    }
    OpacityMask
    {
        anchors.fill: right_arrow_bkg
        source: right_arrow_bkg
        maskSource: right_arrow
        opacity: (browser.currentIndex < browser.listItemsCount && browser.listItemsCount) ? 1.0 : 0.5
        Image
        {
            source: "content/POI/right-arrow.png"
            anchors.centerIn: parent
        }
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed: browser.increaseCurrentItem();
        }
    }

    CollectionImageHolder
    {
        id: imageHolder
        x: root.topScreen?-(Settings.SCREEN_WIDTH - root.x):-root.x;
        y: root.topScreen?-(Settings.SCREEN_HEIGHT - root.y):-root.y
        width: Settings.SCREEN_WIDTH
        height: Settings.SCREEN_HEIGHT

        antialiasing: true

        onImageDeleted:
        {
            //console.log("delete filepath = ",filepath, "whichScreen = ", whichScreen)

            root.imageRemovedFromScene(filepath);
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



    function appendItems(result)
    {
        browser.append(result);
    }
    function imageRemovedFromScene(filepath)
    {
        browser.imageRemovedFromScene(filepath);
    }
    function whichTag()
    {
        if(root.whichScreen === "lower left") return ItemManager.tagSearchLowerLeft;
        if(root.whichScreen === "lower right") return ItemManager.tagSearchLowerRight;
        if(root.whichScreen === "top left") return ItemManager.tagSearchTopLeft;
        if(root.whichScreen === "top right") return ItemManager.tagSearchTopRight;
    }
}
