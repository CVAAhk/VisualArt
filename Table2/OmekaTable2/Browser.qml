import QtQuick 2.5
import QtQuick.Controls 1.4

import "settings.js" as Settings


/*! Item browser component */
Item {
    id: root
    width: parent.width
    height: parent.height

    property Flickable layout : list

    property var model: ListModel{}

    property var delegate: ThumbnailViewer{}

    property real divisor: 478

    property real rowHeight: 300//width/Math.floor(width/(Math.floor(Resolution.applyScale(divisor))))

    property real spacing: -300//Resolution.applyScale(30)

    property real cacheBuffer: rowHeight > 0 ? rowHeight * 200 : 0

    property real headerHeight: 0

    property int currentIndex: list.currentIndex

    property var currentItem: list.currentItem

    property color headerColor: "white"

    property bool busy: false

    property bool topScreen: false

    property var imageItems: []

    property var touch_area: touch_area

    property int listItemsCount: list.count

    property var itemsPositions: [Qt.vector2d(-300,-300),
        Qt.vector2d(-300,-300),
        Qt.vector2d(-300,-300),
        Qt.vector2d(-300,-300),
        Qt.vector2d(-300,-300),
        Qt.vector2d(-300,-300)]

    property var usedPositions :[]

    property vector2d assignedPosition: Qt.vector2d(0,0)

    signal imageDragged(var touchPoint);

    signal imageFinishedDragging(var touchPoint);

    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, bool tapOpen, var touchPoint);

    signal interactive();

    function assignItemPosition(x)
    {
        if(itemsPositions.length === 1)
        {
            resetItemsPositions()
        }

        assignedPosition = itemsPositions.pop();

        assignedPosition.x = x;

        var addPositionX = x;
        var addPositionY = assignedPosition.y;

        usedPositions.push(Qt.vector2d(addPositionX, addPositionY));
    }
    function deleteAssignPosition()
    {
        var deletePosition = usedPositions.splice(0,1);
        itemsPositions.unshift(deletePosition[0]);
    }

    function clearPositions()
    {
        usedPositions = [];
    }

    function resetItemsPositions()
    {
        itemsPositions = [Qt.vector2d(-300,-300),
                          Qt.vector2d(-300,-300),
                          Qt.vector2d(-300,-300),
                          Qt.vector2d(-300,-300),
                          Qt.vector2d(-300,-300),
                          Qt.vector2d(-300,-300)]
    }


    ListView
    {
        id: list
        model: root.model
        delegate: root.delegate
        spacing: -70
        cacheBuffer: 478
        //maximumFlickVelocity: 8000
        //flickDeceleration: 300
        boundsBehavior: Flickable.StopAtBounds
        orientation: ListView.Horizontal
        x: 21
        width: root.width
        height: root.height
        highlightRangeMode: ListView.StrictlyEnforceRange
        //snapMode: ListView.SnapToItem
        preferredHighlightBegin: 140
        preferredHighlightEnd: 298

        focus: true
        enabled: false
    }

    function increaseCurrentItem()
    {
        list.incrementCurrentIndex();
        interactive();
    }
    function decreaseCurrentItem()
    {
        list.decrementCurrentIndex();
        interactive();
    }
    Timer
    {
        id: delayTimerSwitch

        interval: 500; repeat: false
    }

    MultiPointTouchArea
    {
        id: touch_area

        x: 21//161//root.width/2 - 200
        enabled: !delayTimerSwitch.running

        width: list.width//400
        height: list.height//400
        //anchors.fill: path

        property bool creatingImage: false
        property bool flick: true
        property int touchId: -1


        property int bottomFlickMax: 500

        property var dragAmounts: ({})
        property var dragImages: ({})

        property var lastTouchPoint

        onReleased:
        {
            for(var i = 0; i < touchPoints.length; i++)
            {
                var touchPoint = touchPoints[i];

                var deltaX = touchPoint.x - touchPoint.startX;
                var deltaY = touchPoint.y - touchPoint.startY;

                if(Math.abs(deltaX) < 10 &&
                        Math.abs(deltaY) < 10)
                {

                    var item = list.itemAt(list.contentX +touchPoint.x + touch_area.x, touchPoint.y);

                    if(item) var imageSource = item.source;

                    var newImageWidth = 247;


                    if(imageSource && imageSource != "" && !item.inScene)
                    {
                        var tap_x = 0;
                        var tap_y = 0;
                        var rotation = 0;
//                        if(root.topScreen)
//                        {
//                            tap_x = (root.width * 0.5) * -0.5 + -newImageWidth * 0.5;
//                        }
//                        else
//                        {
                            tap_x = (root.width * 0.5) * 0.5 - newImageWidth * 0.5
//                        }

                        assignItemPosition(tap_x);
                        if(root.topScreen)
                        {
                            tap_y = assignedPosition.y;

                            rotation = 180;
                        }
                        else
                        {
                            tap_y = assignedPosition.y;

                            rotation = 0;
                        }
                        item.imageInScene();
                        imageItems.push(item);
                        root.createImage(imageSource, tap_x, tap_y, rotation, newImageWidth, newImageWidth, true, touchPoint);
                        //console.log("assign possition x: ", assignedPosition.x , " assign position y: ", assignedPosition.y);

                        console.log("TAP!! createImage()");
                        delayTimerSwitch.start();
                        interactive();
                    }
                }
            }
        }

        onTouchUpdated:
        {

            var updatedCreatedImage = false;

            for(var i = 0; i < touchPoints.length; i++)
            {
                lastTouchPoint = touchPoints[i];
                var touchPoint = touchPoints[i];

                var deltaX = touchPoint.x - touchPoint.previousX;
                var deltaY = touchPoint.y - touchPoint.previousY;

                if(!creatingImage)
                {
                    if(touchPoint.y < bottomFlickMax)
                    {
                        if(Math.abs(touchPoint.x - touchPoint.previousX) > 10)
                        {
                            list.flick((touchPoint.x - touchPoint.previousX) * 100, 0);
                            touch_area.flick = true;
                            interactive();
                        }
                        else
                        {
                            touch_area.flick = false;
                        }
                    }

                    if(touchPoint.y < bottomFlickMax + 100)
                    {
                        if(!dragAmounts[touchPoint.pointId])
                        {
                            dragAmounts[touchPoint.pointId] = 0.0;
                            dragImages[touchPoint.pointId] = list.itemAt(list.contentX +touchPoint.x + touch_area.x, touchPoint.y);
                        }

                        var drag = dragAmounts[touchPoint.pointId] ?
                                    dragAmounts[touchPoint.pointId] : 0.0

                        dragAmounts[touchPoint.pointId] = drag + deltaY;
                        //console.log("pressed!touchPoint.y = ", touchPoint.y)
                        if(dragImages[touchPoint.pointId] != null &&
                                dragAmounts[touchPoint.pointId] < -100)
                        {
                            var imageSource = dragImages[touchPoint.pointId].source;
                            var item = dragImages[touchPoint.pointId];
                            var title = dragImages[touchPoint.pointId].title;


                            if(imageSource !== "" &&
                                    (!item.inScene))
                            {
                                creatingImage = true;
                                selected_image.visible = true;

                                layout.cancelFlick();

                                touchId = touchPoint.pointId;

                                selected_image.source = imageSource;

                                //selected_image.title = title;

                                item.imageInScene();
                                imageItems.push(item);

                                selected_image.screenX = touchPoint.x + touch_area.x + root.x - selected_image.width / 2;
                                selected_image.screenY = touchPoint.y + touch_area.y - root.y// + selected_image.height / 2;

                                selected_image.width = 247;
                                selected_image.item = item.itemData;
                                //console.log("touchPoint.x = ", touchPoint.x, " touchPoint.y = ", touchPoint.y)
                                updatedCreatedImage = true;

                                root.imageDragged(touchPoint);

                                break;
                            }
                        }
                    }
                }
                else
                {
                    if(touchPoint.pointId === touchId && touchPoint.pressed)
                    {
                        selected_image.screenX = touchPoint.x + touch_area.x + root.x - selected_image.width / 2;
                        selected_image.screenY = touchPoint.y + touch_area.y - root.y// + selected_image.height / 2;
                        selected_image.width = 247;
                        updatedCreatedImage = true;
                        root.imageDragged(touchPoint);
                    }
                }
            }

            if(creatingImage && !updatedCreatedImage)
            {
                creatingImage = false;
                selected_image.visible = false;

                var imageCenterX = 0;
                var imageCenterY = 0;
                var rotation = 0;

                if(root.topScreen)
                {
                    imageCenterX = selected_image.x//-selected_image.x - selected_image.width// + root.x + touch_area.x;//
                    imageCenterY = selected_image.y//-selected_image.y - selected_image.height// / 2//1080 + (selected_image.y); // selected_image.height / 2 + root.y + touch_area.y;
                    rotation = 180;
                }
                else
                {
                    imageCenterX = selected_image.x//- selected_image.width / 2; //selected_image.width / 2 + root.x + touch_area.x;//
                    imageCenterY = selected_image.y// - selected_image.height / 2; // selected_image.height / 2 + root.y + touch_area.y;
                    rotation = 0;
                }
                imageFinishedDragging(lastTouchPoint);
                //console.log("touchPoint.x = ", lastTouchPoint.x, " touchPoint.y = ", lastTouchPoint.y)

                root.createImage(selected_image.source, imageCenterX, imageCenterY, rotation,
                                 selected_image.width, selected_image.height, false, lastTouchPoint);
                interactive();
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

        Rectangle
        {
            anchors.fill: parent
            color: "red"
            opacity: 0.5
            visible: parent.enabled && Settings.DEBUG_VIEW
        }
    }




    /*! Add item from browser */
    function append(item) {
        //path.model.append(item);
        layout.model.append(item);
    }

    /*! Insert item from browser */
    function insert(index, item) {
        layout.model.insert(index, item)
    }

    /*! Clear browser */
    function clear() {
        layout.model.clear();
    }

    function imageRemovedFromScene(source)
    {
        //console.log("Browser! imageRemovedFromScene(source) = ", source)
        deleteAssignPosition();
        for(var i = 0; i < imageItems.length; i ++)
        {
            if(imageItems[i].source == source)
            {
                console.log("Browser! imageRemovedFromScene(source) = ", source, " i = ", i)
                imageItems[i].imageRemovedFromScene(source);
                imageItems.splice(i, 1);
            }
        }
    }

    function reset()
    {
        resetItemsPositions()
        list.positionViewAtIndex(0, ListView.Center)
    }

}
