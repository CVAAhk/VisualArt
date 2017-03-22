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

    property var delegate: ImageViewer{}

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

    signal imageDragged();

    signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight, string title);


    ListView
    {
        id: list
        model: root.model
        delegate: root.delegate
        spacing: -70
        cacheBuffer: 478
        maximumFlickVelocity: 8000
        flickDeceleration: 3000
        boundsBehavior: Flickable.StopAtBounds
        orientation: ListView.Horizontal
        //y: root.height /4
        x: 21//root.width * 2/ 5
        width: root.width
        height: root.height
        highlightRangeMode: ListView.StrictlyEnforceRange
        snapMode: ListView.SnapOneItem
        preferredHighlightBegin: 140
        preferredHighlightEnd: 298

        focus: true

        onFlickStarted:
        {
            console.log("flick starts!!!!")
            touch_area.enabled = false;
        }
        onFlickEnded:
        {
            console.log("flick ends")
            touch_area.enabled = true;
        }
        onMovementEnded:
        {
            touch_area.enabled = true;
        }
        onCurrentItemChanged:
        {
            console.log("current index = ", currentIndex)
        }
    }

//    PathView
//    {
//        id: path
//        model: root.model
//        anchors.fill: parent
//        anchors.horizontalCenter: parent.horizontalCenter
//        delegate: root.delegate
//        maximumFlickVelocity: 800
//        flickDeceleration: 50
//        path: Path {
//            id: path_curve
//                    startX: root.width * 1 / 2; startY: root.height /2
////                    PathArc {
////                            x: root.width * 2; y: root.height /2
////                            radiusX: 75; radiusY: 50
////                            direction: PathArc.Counterclockwise
////                        }
//                    PathLine { x: root.width * 2; y: root.height /2}
//                    //PathLine { x: -root.width *1/2; y: root.height /2}

//                    //PathQuad { x: root.width /2; y: root.height /2; controlX: root.width * 2; controlY: root.height /2 }
//                    //PathQuad { x: root.width /2; y: root.height /2; controlX: -root.width *1/2 ; controlY: root.height /2 }
//                }

//    }
    function increaseCurrentItem()
    {
        list.incrementCurrentIndex();
    }
    function decreaseCurrentItem()
    {
        list.decrementCurrentIndex();
    }

//        Rectangle
//        {
//            anchors.fill: parent
//            color: "green"
//            opacity: 0.5
//            visible: parent.enabled && Settings.DEBUG_VIEW
//        }

    MultiPointTouchArea
    {
        id: touch_area

        x: 161//root.width/2 - 200
        //y: //list.curoot.height/2 - 200

        width: 400
        height: 400
        //anchors.fill: path

        property bool creatingImage: false
        property int touchId: -1


        property int bottomFlickMax: 500

        property var dragAmounts: ({})
        property var dragImages: ({})

        onReleased:
        {
            for(var i = 0; i < touchPoints.length; i++)
            {
                var touchPoint = touchPoints[i];
                if(touchPoint.y > 0 && dragAmounts[touchPoint.pointId] > -100)
                {
                    touch_area.enabled = false;
                }
                else
                {
                    touch_area.enabled = true;
                }
            }
        }

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
                    if(touchPoint.y < bottomFlickMax + 100)
                    {
                        if(!dragAmounts[touchPoint.pointId])
                        {
                            dragAmounts[touchPoint.pointId] = 0.0;
                            dragImages[touchPoint.pointId] = list.currentItem
                        }

                        var drag = dragAmounts[touchPoint.pointId] ?
                                    dragAmounts[touchPoint.pointId] : 0.0

                        dragAmounts[touchPoint.pointId] = drag + deltaY;

                        if(dragAmounts[touchPoint.pointId] < -100)
                        {
                            var imageSource = dragImages[touchPoint.pointId].source;
                            var item = dragImages[touchPoint.pointId];
                            var title = dragImages[touchPoint.pointId].title;


                            if(imageSource !== "" &&
                                    (!item.inScene))
                            {
                                creatingImage = true;

                                touchId = touchPoint.pointId;

                                selected_image.source = imageSource;

                                //selected_image.title = title;

                                item.imageInScene();
                                imageItems.push(item);

                                selected_image.screenX = touchPoint.x + touch_area.x + root.x - selected_image.width / 2;
                                selected_image.screenY = touchPoint.y + touch_area.y - root.y + selected_image.height / 2;
                                selected_image.width = 247;
                                console.log("touchPoint.x = ", touchPoint.x, " touchPoint.y = ", touchPoint.y)
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
                        selected_image.screenX = touchPoint.x + touch_area.x + root.x - selected_image.width / 2;
                        selected_image.screenY = touchPoint.y + touch_area.y - root.y + selected_image.height / 2;
                        selected_image.width = 247;
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

                if(root.topScreen)
                {
                    imageCenterX = 1920 - (selected_image.x); //selected_image.width / 2 + root.x + touch_area.x;//
                    imageCenterY = 1080 - (selected_image.y); // selected_image.height / 2 + root.y + touch_area.y;
                    rotation = 180;
                }
                else
                {
                    imageCenterX = selected_image.x//- selected_image.width / 2; //selected_image.width / 2 + root.x + touch_area.x;//
                    imageCenterY = selected_image.y - selected_image.height / 2; // selected_image.height / 2 + root.y + touch_area.y;
                    rotation = 0;
                }
                console.log("selected_image.x = ", selected_image.x, " selected_image.y = ", selected_image.y)
                console.log("MAking select imag e " + selected_image.width + " " + selected_image.height);

                root.createImage(selected_image.source, imageCenterX, imageCenterY, rotation,
                                 selected_image.width, selected_image.height, selected_image.title);
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

//        Image
//        {
//            id: selected_image

//            visible: touch_area.creatingImage

//            source: ""
//            height: root.imageHeight
//            fillMode: Image.PreserveAspectFit

//            property int screenX: 0
//            property int screenY: 0

//            x: screenX - width / 2
//            y: screenY - height / 2
//            z: 10

//            property string title: ""
//            property string description: ""
//        }


        //        Rectangle
        //        {
        //            width: path.width
        //            height: path.height
        //            color: "red"
        //            opacity: 0.5
        //            visible: parent.enabled && Settings.DEBUG_VIEW
        //        }
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
        console.log("Browser! imageRemovedFromScene(source) = ", source)
        for(var i = 0; i < imageItems.length; i ++)
        {
            if(imageItems[i].source === source)
            {
                console.log("Browser! imageRemovedFromScene(source) = ", source, " i = ", i)
                imageItems[i].imageRemovedFromScene(source);
                imageItems.splice(i, 1);
            }
        }
    }


}
