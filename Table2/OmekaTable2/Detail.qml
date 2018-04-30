import QtQuick 2.8
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "./TouchHelpers"
import "settings.js" as Settings
import "."

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item
{
    property bool touching: (pinch_area.dragging || pinch_area.pinching) && readyToReparent

    property bool opened: readyToReparent && imageHeight > 0

    property bool readyToReparent: false

    id: root

    //interactive: false
    height: false ? root.imageHeight + scroll_bkg.height + controls.height : root.imageHeight + controls.height
    width: root.imageWidth
    objectName: "detail"
    visible: false

    property int imageWidth

    property int imageHeight : media.height

    property string whichScreen
    property string source

    property int imageTimerDuration : Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    property bool active: false

    property bool openedAttract: false

    property bool inUse: false

    property int oldImageHeight: controls.height

    property bool inPairingBox: false

    property bool topScreen: false

    property int recoveryX//x after detail item is added to mobile favorites
    property int recoveryY

    signal imageDragged(var image, var touchPoint, var imageX, var imageY);

    signal finishedDragging(var image, var touchPoint, var imageX, var imageY);

    signal deleteImage(var image);

    signal imagePressed(var image);

    signal finishedRecycle();

    signal interactive();

    /*! \qmlproperty
        Currently selected item
    */
    property var item: null //getSelectedItem();//: ItemManager.current

    property var contentScreen: content_screen

//    onHeightChanged:
//    {
//        if(root.rotation === 180 && !active && whichScreen.includes("attract")&& !openedAttract )   {root.y -= root.height - controls.height;}
//        else if(root.rotation === 180 && active && whichScreen.includes("attract") )   {root.y -= scroll_bkg.height;}
//        else if(root.rotation === 180 && !active && whichScreen.includes("attract") ) {root.y += scroll_bkg.height;}
//    }
    onInUseChanged:
    {
        if(inUse)
            image_timer.start();
    }

    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
        anchors.fill: content_screen
        anchors.margins: -10
        visible: false // media.progress == 1
    }

    Rectangle
    {
        id: content_screen
        width: root.width
        height: root.height

        property bool topScreen: root.topScreen

        property string whichScreen: root.whichScreen

        property var item: root.item


        //anchor to touch point when scaling test
        transform: Scale { origin.x: content_screen.center.x; origin.y: content_screen.center.y; xScale: (content_screen.realScaling < 0.5 ? 0.5 : content_screen.realScaling);
            yScale: (content_screen.realScaling < 0.5 ? 0.5 : content_screen.realScaling)

        }

        property real scaling: 1.0
        property real realScaling: 1.0

        onScalingChanged:
        {
            var c = pinch_area.calculatePinchCenter()
            root.x -= (scaling-realScaling)*c.minus(center).x
            root.y -= (scaling-realScaling)*c.minus(center).y
            realScaling = scaling
        }

        property vector2d center: Qt.vector2d(root.imageWidth/2, root.imageHeight/2)

        Behavior on scaling { NumberAnimation { duration: 200 } }
        //Behavior on x { NumberAnimation { duration: 200 } }
        //Behavior on y { NumberAnimation { duration: 200 } }

        smooth: true
        antialiasing: true


        MultiPointPinchArea
        {

            //change scale of the content_screen
            id: pinch_area
            anchors.fill: parent

            maximumScale: 2                        // only set if bounded AND listenForScale = true
            minimumScale: 1

            maximumRotation: 180                   // only set if bounded AND listenForRotation = true
            minimumRotation: -180

            dragOnPinch: true
            listenForRotation: true
            listenForScale: true
            listenForDrag: true

            onItemPressed:
            {
                root.imagePressed(root);
                image_timer.restart();
            }

            onScaleUpdated:
            {
                image_timer.restart();


                var center = lastTouchPosition
                //center.x = whichScreen.includes("attract top") ? content_screen.width - center.x : center.x
                //center.y = whichScreen.includes("attract top") ? content_screen.height - center.y : center.y
//                content_screen.center = Qt.vector2d(center.x,
//                                                    center.y)//Qt.vector2d(pinch_area.width/2, pinch_area.height/2)

                checkBoundry(delta_scale)


                //console.log("scaling = ", content_screen.scaling, " delta_scale = ", delta_scale)
                //root.x += -zoomX * delta_scale + zoomX//zoomX - ((zoomX - root.x) * delta_scale );
                //root.y += -zoomY * delta_scale + zoomY//zoomY - ((zoomY - root.y) * delta_scale );
            }

            onDraggingChanged:
            {
                if(!dragging)
                {
                    //var center = calculatePinchCenter()
                    console.log("touchstate = ", touchState)
                    image_timer.restart();
                    var center = lastTouchPosition
                    center.x = whichScreen.includes("attract top") ? content_screen.width - center.x : center.x
                    center.y = whichScreen.includes("attract top") ? content_screen.height - center.y : center.y
                    root.finishedDragging(content_screen,
                                          Qt.vector2d(center.x,
                                                      center.y),
                                          root.x + content_screen.x * (whichScreen.includes("attract top") ? -1 : 1) ,
                                          root.y + content_screen.y * (whichScreen.includes("attract top") ? -1 : 1));
                }
            }



            onPositionUpdated:
            {
                image_timer.restart();

                if(whichScreen == "middle right")
                {
                    root.y += delta_x;
                    root.x += -delta_y;
                }
                else if(whichScreen == "middle left")
                {
                    root.y += -delta_x;
                    root.x += delta_y;
                }
                else
                {
                    root.x += delta_x//* (root.topScreen ? -1.0 : 1.0);//delta_x* (root.topScreen ? -1.0 : 1.0)//// * detail.scale;
                    root.y += delta_y//* (root.topScreen ? -1.0 : 1.0);// * detail.scale;
                }

                var center = pinch_area.calculatePinchCenter()

                center.x = whichScreen.includes("attract top") ? content_screen.width - center.x : center.x
                center.y = whichScreen.includes("attract top") ? content_screen.height - center.y : center.y

                console.log("dragging!!", root.x, root.y)
                root.imageDragged(content_screen,
                                  Qt.vector2d(center.x,
                                              center.y),
                                  root.x + content_screen.x * (whichScreen.includes("attract top") ? -1 : 1) ,
                                  root.y + content_screen.y * (whichScreen.includes("attract top") ? -1 : 1));

            }
            onRotationUpdated:
            {
                image_timer.restart();
                content_screen.rotation += delta_rotation;
            }



            function checkBoundry(zoom)
            {
                var delta_zoom
                if(content_screen.scaling + zoom  < pinch_area.minimumScale)
                {

                    delta_zoom = 1 + (pinch_area.minimumScale - content_screen.scaling)/content_screen.scaling;
                    content_screen.scaling = pinch_area.minimumScale
                }
                else if(content_screen.scaling + zoom > pinch_area.maximumScale)
                {
                    delta_zoom = 1.0 + (pinch_area.maximumScale - content_screen.scaling)/content_screen.scaling;
                    content_screen.scaling = pinch_area.maximumScale
                }
                else
                {
                    content_screen.scaling += zoom
                }
                return delta_zoom
            }

        }
        MediaViewer
        {
            id: media
            anchors.top: controls.bottom
            sources: root.item ? root.item.media : null
            type: root.item ? root.item.mediaTypes[0] : ""
            //visible: root.visible ? true : false
            opacity: root.visible ? 1.0 : 0.0

            onHeightChanged:
            {
                if(scale > 1)
                {
                    anchors.topMargin = (scale * height - height) * 0.5;
                }
                else
                {
                    anchors.topMargin = 0;
                }
            }
        }

        Image
        {
            id: controls
            width: scroll_bkg.width
            source: "content/POI/info-panel-controls-bkg.png"

            height: 40 / root.scale

            Image
            {
                source: "content/POI/info-panel-controls-bkg-left.png"
                width: 32 / root.scale
                height: controls.height
            }

            Image
            {
                source: "content/POI/info-panel-controls-bkg-right.png"
                width: 32 / root.scale
                height: controls.height
                x: controls.width - width
            }

            Image
            {
                id: close
                source: "content/POI/close@4x.png"

                x: 10 / root.scale
                y: 10 / root.scale

                transformOrigin: Item.TopLeft

                scale: 1.0 / root.scale
                width: 24; height: 24

                MultiPointTouchArea
                {
                    anchors.fill: parent
                    anchors.margins: -10
                    onPressed:
                    {
                        root.deleteImage(root);
                        image_timer.stop();
                    }
                }
            }
            Image
            {
                id: info_btn
                source: root.active ? "content/POI/info-on@4x.png" : "content/POI/info-off@4x.png"
                //anchors.left: controls.left
                //anchors.margins: 10
                width: 24; height: 24

                x: controls.width + -24 - 10 / root.scale;
                y: 10 / root.scale

                transformOrigin: Item.TopRight

                scale: 1.0 / root.scale

                MultiPointTouchArea
                {
                    anchors.fill: parent
                    anchors.margins: -10
                    onPressed:
                    {
                        image_timer.restart();
                        root.active = !root.active
                        if(!openedAttract) openedAttract=true; //todo: reset
                    }
                }
            }
        }


        //primary display
        property DetailColumn column
        /*! scroll container */


        Image
        {
            id: scroll_bkg
            source: "content/POI/description_bkg.png"
            height: 200 / root.scale
            anchors.top: media.bottom
            anchors.left: media.left
            opacity: root.active ? 1.0 : 0.0

            Image
            {
                source: "content/POI/description_bkg-left.png"
                width: 64 / root.scale
                height: scroll_bkg.height
            }

            Image
            {
                source: "content/POI/description_bkg-right.png"
                width: 64 / root.scale
                height: scroll_bkg.height
                x: scroll_bkg.width - width
            }

            /*! scroll container */
            OmekaScrollView
            {
                id: scroll
                width: root.imageWidth
                height: 180 / root.scale
                enabled: parent.opacity == 1.0
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                //media display
                DetailContent
                {
                    id: detail_content;
                    width: root.width
                    rootScale: root.scale
                }

                flickableItem.onContentYChanged:
                {
                    image_timer.restart();
                    scroll_bar.updateBar(flickableItem.contentY / (flickableItem.contentHeight - flickableItem.height));
                }
            }
            ScrollBar
            {
                id: scroll_bar

                x: (scroll_bkg.width * root.scale - 15) / root.scale
                y: 40 / root.scale

                transform: Scale { xScale: 1.0 / root.scale; yScale: 1.0 / root.scale }

                onScrollChanged:
                {
                    image_timer.restart();
                    scroll.flickableItem.contentY = percent * (scroll.flickableItem.contentHeight - scroll.flickableItem.height);
                }
            }

        }

        LoadScreen
        {
            width: root.width
            height: controls.height
            progress: media ? media.progress : 0
        }


        MediaControls
        {
            media: media
            onInterative: image_timer.restart();
        }

        SequentialAnimation
        {
            id: recoveryAnimation


            PauseAnimation {
                duration: 5000
            }

            PropertyAction { target: content_screen; property: "scaling"; value: 1 }

            ParallelAnimation
            {
                //PropertyAnimation { target: root; property: 'opacity'; to: 1.0; duration: 250 }
                PropertyAnimation { target: root; property: 'x'; to: recoveryX; duration: 250 }
                PropertyAnimation { target: root; property: 'y'; to: recoveryY; duration: 250 }
            }
            PropertyAction { target: root; property: "visible"; value: true }
            PropertyAction { target: root; property: "opacity"; value: 1.0 }

            onRunningChanged:
            {
                if(!running)
                {
                    image_timer.restart();
                    //finishedRecycle();
                }
            }
        }

        SequentialAnimation
        {
            id: recycleAnimation

            PropertyAction { target: root; property: "transformOrigin"; value: Item.Center }
            ParallelAnimation
            {
                PropertyAnimation { target: content_screen; property: 'scaling'; to: 0.1; duration: 250; easing.type: Easing.InOutQuad }
                PropertyAnimation { target: root; property: 'opacity'; to: 0.0; duration: 250; easing.type: Easing.InOutQuad }
            }
            //PropertyAction { target: root; property: "visible"; value: false }
            onRunningChanged:
            {
                if(!running)
                {
                    finishedRecycle();
                    content_screen.x = 0
                    content_screen.y = 0
                    recoveryAnimation.start();
                }
            }
        }

        function recycle(recoveryX, recoveryY)
        {
            root.recoveryX = recoveryX;
            root.recoveryY = recoveryY;

//            content_screen.center = Qt.vector2d(pinch_area.width/2, pinch_area.height/2)

            recycleAnimation.start();
        }

        function turnSmall(mouseX, mouseY)
        {

            root.active = false;
            root.inPairingBox = true;
            mouseX = whichScreen.includes("attract top") ? content_screen.width - mouseX : mouseX
            mouseY = whichScreen.includes("attract top") ? content_screen.height - mouseY : mouseY

//            content_screen.center =  Qt.vector2d(mouseX,
//                                                 mouseY)
            content_screen.scaling = 0.5;
            //selected_image_small.start()
        }

        function turnBack(mouseX, mouseY)
        {
            if(root.inPairingBox)
            {
                //root.scale = 1.0;
                //selected_image_original.start()
//                content_screen.center =  Qt.vector2d(mouseX,
//                                                     mouseY)
                root.inPairingBox = false;
                content_screen.scaling = 1.0;
            }


        }

        NumberAnimation {
            id: selected_image_small
            target: content_screen
            property: "scaling"
            to: 0.5
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            id: selected_image_original
            target: content_screen
            property: "scaling"
            to: 1.0
            duration: 200
            easing.type: Easing.InOutQuad
        }


//        MultiPointPinchArea
//        {
//            id: touch_area
//            anchors.fill:parent

//            dragOnPinch: true
//            listenForRotation: true
//            listenForScale: false

//            mouseEnabled: true
//            touchPoints: [TouchPoint{id: touch_1}, TouchPoint{id: touch_2}]

//            property int touchState: touch_1.pressed + 2*(touch_2.pressed) // 0 for no touching, 1 for point 1, 2 for point 2, 3 for pinch

//            //minimumX: 0 - root.imageWidth
//            //maximumX: 1920 - root.imageWidth

//            //minimumY: 0 - root.imageHeight
//            //maximumY: 1080 - root.imageHeight

//            onDraggingChanged:
//            {
//                if(!dragging)
//                {
//                    image_timer.restart();
//                    root.finishedDragging(root, touchPoints[0]);
//                }
//            }

//            onPositionUpdated:
//            {
//                image_timer.restart();
//                if(whichScreen == "middle right")
//                {
//                    root.y += delta_x;
//                    root.x += -delta_y;
//                }
//                else if(whichScreen == "middle left")
//                {
//                    root.y += -delta_x;
//                    root.x += delta_y;
//                }
//                else
//                {

//                root.x += delta_x* (root.topScreen ? -1.0 : 1.0);//delta_x* (root.topScreen ? -1.0 : 1.0)//// * detail.scale;
//                root.y += delta_y* (root.topScreen ? -1.0 : 1.0);// * detail.scale;
//                }

//                root.imageDragged(root, touchPoints[1]);
//            }
//            onRotationUpdated:
//            {
//                image_timer.restart();
//                root.rotation += delta_rotation;
//            }
////            onScaleUpdated:
////            {
////                image_timer.restart();
////                content_screen.scaling += delta_scale * root.scaleFactor;

////                content_screen.checkScaling()

////                console.log("scaling = ", content_screen.scaling, " delta_scale = ", delta_scale)
////                //root.x += -zoomX * delta_scale + zoomX//zoomX - ((zoomX - root.x) * delta_scale );
////                //root.y += -zoomY * delta_scale + zoomY//zoomY - ((zoomY - root.y) * delta_scale );
////            }

//            onItemPressed:
//            {
//                root.imagePressed(root);
//                image_timer.restart();
//            }

//            debugView: false

//            function calculatePinchCenter()
//            {
//                if (touchState === 3)
//                {
//                    return Qt.vector2d((touch_1.x+touch_2.x)*0.5,(touch_1.y+touch_2.y)*0.5);
//                }
//                else if (touchState === 2)
//                {
//                    return Qt.vector2d(touch_2.x,touch_2.y);
//                }
//                else if (touchState === 1)
//                {
//                    return Qt.vector2d(touch_1.x,touch_1.y);
//                }
//                else
//                {
//                    return undefined;
//                }
//            }

//        }


    }

    Timer
    {
        id: image_timer

        interval: root.imageTimerDuration

        onTriggered:
        {
            //image back to the viewer
            root.deleteImage(root);
        }
    }

    function reset()
    {
        content_screen.scaling = 1.0
        content_screen.rotation = 0
        root.state = "CREATED"
    }



}
