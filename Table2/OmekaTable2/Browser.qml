import QtQuick 2.5
import QtQuick.Controls 1.4

import "settings.js" as Settings


/*! Item browser component */
Item {
    id: root
    width: parent.width
    height: parent.height
    //state: User.layoutID
    z: -1

    //property Flickable layout: path

    property var model: ListModel{}

    property var delegate: ImageViewer{}

    property real divisor: 478

    property real rowHeight: 300//width/Math.floor(width/(Math.floor(Resolution.applyScale(divisor))))

    property real spacing: -200//Resolution.applyScale(30)

    property real cacheBuffer: rowHeight > 0 ? rowHeight * 200 : 0

    property real headerHeight: 0

    property color headerColor: "white"

    property bool busy: false

    signal imageDragged();

    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight);

//    Flickable
//    {
//        id: scroll_view
        PathView
        {
            id: path
            model: root.model
            //visible: layout === path
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: root.delegate
            maximumFlickVelocity: 800
            path: Path {
                        startX: root.width /2 ; startY: root.height /2
                        PathQuad { x: root.width /2; y: root.height /2; controlX: root.width; controlY: root.height /2 }
                        PathQuad { x: root.width /2; y: root.height /2; controlX: 0; controlY: root.height /2 }
                    }
            onCurrentItemChanged:
            {
                console.log("current index = ", currentIndex)
            }

        }
        Rectangle
        {
            anchors.fill: parent
            color: "green"
            opacity: 0.5
            visible: parent.enabled && Settings.DEBUG_VIEW
        }
//        Rectangle
//        {
//            width: scroll_view.contentWidth
//            height: scroll_view.contentHeight
//            color: "green"
//            opacity: 0.5
//            visible: parent.enabled && Settings.DEBUG_VIEW
//        }
//    }
    MultiPointTouchArea
    {
        id: touch_area

        x: path.currentItem.x
        y: path.currentItem.y

        width: 500
        height: 500

        enabled: true

        property bool creatingImage: false
        property int touchId: -1

        property int bottomFlickMax: 500

        property var dragAmounts: ({})
        property var dragImages: ({})

        onTouchUpdated:
        {
            var updatedCreatedImage = false;

            for(var i = 0; i < touchPoints.length; i++)
            {
                var touchPoint = touchPoints[i];

                var deltaX = touchPoint.x - touchPoint.previousX;
                var deltaY = touchPoint.y - touchPoint.previousY;

                if(!creatingImage)
                {
//                    if(touchPoint.y < bottomFlickMax)
//                    {
//                        scroll_view.flick((touchPoint.x - touchPoint.previousX) * 100, 0);
//                    }

                    if(touchPoint.y < bottomFlickMax + 100)
                    {
                        if(!dragAmounts[touchPoint.pointId])
                        {
                            dragAmounts[touchPoint.pointId] = 0.0;
                            dragImages[touchPoint.pointId] = path.currentItem//path.itemAt(touch_area.x +touchPoint.x, touch_area.y +touchPoint.y)//scroll_view.getImageAtX(touchPoint.x);
                            console.log("touchPoint.x = ", touchPoint.x, " touchPoint.y = ", touchPoint.y)
                            //console.log("touchPoint.pointId( ",touchPoint.pointId, " ) souce = ", dragImages[touchPoint.pointId])
                        }

                        var drag = dragAmounts[touchPoint.pointId] ?
                                    dragAmounts[touchPoint.pointId] : 0.0

                        dragAmounts[touchPoint.pointId] = drag + deltaY;

                        if(dragAmounts[touchPoint.pointId] < -100)
                        {
                            var imageSource = dragImages[touchPoint.pointId].source;
                            var item = dragImages[touchPoint.pointId];


                            if(imageSource !== "" &&
                                    (!item.inScene))
                            {
                                creatingImage = true;

                                touchId = touchPoint.pointId;

                                selected_image.source = imageSource;

                                //scroll_view.cancelFlick();

                                //scroll_view.imageInScene(selected_image.source);
                                item.imageInScene();

                                selected_image.screenX = touchPoint.x;
                                selected_image.screenY = touchPoint.y;

                                updatedCreatedImage = true;

                                root.imageDragged();

                                break;
                            }
                        }
                    }
                }
                else
                {
                    if(touchPoint.pointId === touchId && touchPoint.pressed)
                    {
                        selected_image.screenX = touchPoint.x;
                        selected_image.screenY = touchPoint.y;

                        updatedCreatedImage = true;
                    }
                }
            }

            if(creatingImage && !updatedCreatedImage)
            {
                creatingImage = false;

                var imageCenterX = 0;
                var imageCenterY = 0;
                var rotation = 0;

                imageCenterX = selected_image.x + root.x + touch_area.x; //selected_image.width / 2 + root.x + touch_area.x;//
                imageCenterY = selected_image.y + root.y + touch_area.y; // selected_image.height / 2 + root.y + touch_area.y;
                console.log("selected_image.y = ",selected_image.y, " root.y = ", root.y)
                 console.log("MAking select imag e " + selected_image.width + " " + selected_image.height);

                root.createImage(selected_image.source, imageCenterX, imageCenterY, rotation,
                                 selected_image.width, selected_image.height);
            }

            var dragEntries = Object.getOwnPropertyNames(dragAmounts);
            for (var index = 0; index < dragEntries.length; index++)
            {
                var touchEntry = dragEntries[index];
                var updatedEntry = false;
                for(var j = 0; j < touchPoints.length; j++)
                {
                    if(touchPoints[j].pointId == touchEntry)
                    {
                        updatedEntry = true;
                    }
                }

                if(!updatedEntry)
                {
                    dragAmounts[touchEntry] = 0.0;
                }
            }
        }

        Image
        {
            id: selected_image

            visible: touch_area.creatingImage

            source: ""
            height: root.imageHeight
            fillMode: Image.PreserveAspectFit

            property int screenX: 0
            property int screenY: 0

            x: screenX - width / 2
            y: screenY - height / 2
        }

//        Rectangle
//        {
//            width: path.width
//            height: path.height
//            color: "red"
//            opacity: 0.5
//            visible: parent.enabled && Settings.DEBUG_VIEW
//        }

        /*
        Rectangle
        {
            width: scroll_view.contentWidth
            height: scroll_view.contentHeight
            color: "green"
            opacity: 0.5
            visible: parent.enabled && Settings.showDebugInfo
        }
        */
    }



    /*! Add item from browser */
    function append(item) {
        path.model.append(item);
    }

    /*! Insert item from browser */
    function insert(index, item) {
        layout.model.insert(index, item)
    }

    /*! Clear browser */
    function clear() {
        layout.model.clear();
    }


}
