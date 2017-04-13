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
    id: root

    height: active ? root.imageHeight + scroll_bkg.height + controls.height : root.imageHeight + controls.height
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

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);

    signal imagePressed(var image);

    signal finishedRecycle();

    signal interactive();

    /*! \qmlproperty
        Currently selected item
    */
    property var item: null //getSelectedItem();//: ItemManager.current


    onHeightChanged:
    {
        if(root.rotation === 180 && !active && whichScreen.includes("attract")&& !openedAttract )   {root.y -= root.height - controls.height;}
        else if(root.rotation === 180 && active && whichScreen.includes("attract") )   {root.y -= scroll_bkg.height;}
        else if(root.rotation === 180 && !active && whichScreen.includes("attract") ) {root.y += scroll_bkg.height;}
    }
    onInUseChanged:
    {
        if(inUse)
            image_timer.start();
    }

    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
        anchors.fill: root
        anchors.margins: -10
        visible: false // media.progress == 1
    }

    MultiPointPinchArea
    {
        anchors.fill: root

        dragOnPinch: true
        listenForRotation: false//true
        listenForScale: true

        maximumScale: 2
        minimumScale: 1

        mouseEnabled: true

        minimumX: 0 - root.imageWidth
        maximumX: 1920 - root.imageWidth

        minimumY: 0 - root.imageHeight
        maximumY: 1080 - root.imageHeight

        onDraggingChanged:
        {
            if(!dragging)
            {
                image_timer.restart();
                root.finishedDragging(root);
            }
        }

        onPositionUpdated:
        {
            image_timer.restart();
            root.x += delta_x* (root.topScreen ? -1.0 : 1.0);// * detail.scale;
            root.y += delta_y* (root.topScreen ? -1.0 : 1.0);// * detail.scale;

            //console.log("root.x = ", root.x, "root.y = ", root.y, "root.z = ", root.z)
            if(root.y + root.height/2 > Settings.BASE_SCREEN_HEIGHT / 2)
            {
                root.rotation = 0;
            }
            else
            {
                root.rotation = 180;
            }

            root.imageDragged(root);
        }
        onRotationUpdated:
        {
            image_timer.restart();
            root.rotation += delta_rotation;
        }
        onScaleUpdated:
        {
            image_timer.restart();
            root.scale += delta_scale * root.scaleFactor;
        }

        onItemPressed:
        {
            root.imagePressed(root);
            image_timer.restart();
        }

        debugView: Settings.DEBUG_VIEW

    }
    MediaViewer
    {
        id: media
        anchors.top: controls.bottom
        sources: item ? item.media : null
        type: item ? item.mediaTypes[0] : ""
        //visible: root.visible ? true : false
        opacity: root.visible ? 1.0 : 0.0
    }
    MediaControls { media: media }
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
            source: "content/POI/close-off.png"

            x: 10 / root.scale
            y: 10 / root.scale

            transformOrigin: Item.TopLeft

            scale: 1.0 / root.scale

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
            source: root.active ? "content/POI/info-icon-on.png" : "content/POI/info-icon-off.png"
            //anchors.left: controls.left
            //anchors.margins: 10

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
        anchors.left: root.left
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

    SequentialAnimation
    {
        id: recoveryAnimation


        PauseAnimation {
            duration: 500
        }

        PropertyAction { target: root; property: "visible"; value: true }

        ParallelAnimation
        {
            PropertyAnimation { target: root; property: 'opacity'; to: 1.0; duration: 250 }
            PropertyAnimation { target: root; property: 'scale'; to: 1; duration: 250 }
            PropertyAnimation { target: root; property: 'x'; to: recoveryX; duration: 250 }
            PropertyAnimation { target: root; property: 'y'; to: recoveryY; duration: 250 }
        }

        onRunningChanged:
        {
            if(!running)
            {
                image_timer.restart();
                finishedRecycle();
            }
        }
    }

    SequentialAnimation
    {
        id: recycleAnimation

        PropertyAction { target: root; property: "transformOrigin"; value: Item.Center }
        ParallelAnimation
        {
            PropertyAnimation { target: root; property: 'scale'; to: 0.1; duration: 250 }
            PropertyAnimation { target: root; property: 'opacity'; to: 0.0; duration: 250 }
        }
        //PropertyAction { target: root; property: "visible"; value: false }
        onRunningChanged:
        {
            if(!running)
            {
                //finishedRecycle();
                recoveryAnimation.start();
            }
        }
    }
    function recycle(recoveryX, recoveryY)
    {
        root.recoveryX = recoveryX;
        root.recoveryY = recoveryY;
        recycleAnimation.start();
    }

    function turnSmall()
    {
        root.scale = 0.5;
        root.active = false;
        inPairingBox = true;
    }

    function turnBack()
    {
        if(inPairingBox)
        {
            root.scale = 1.0;
            inPairingBox = false;
        }


    }

}
