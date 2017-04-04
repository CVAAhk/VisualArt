import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "./TouchHelpers"
import "settings.js" as Settings

/*! \qmltype Displays detailed view of media items and corresponding metadata */
Item
{
    id: root

    height: active ? root.imageHeight + scroll_bkg.height + controls.height : root.imageHeight + controls.height
    width: root.imageWidth
    objectName: "detail"
    property alias source: img.source

    property alias imageWidth: img.width

    property alias imageHeight: img.height

    property string whichScreen

    property int imageTimerDuration : 100000000 // Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    property bool active: false

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);

//    DropShadow
//    {
//        id: imageEffect
//          anchors.fill: root
//          horizontalOffset: 20
//          verticalOffset: 20
//          radius: 8.0
//          samples: 17
//          color: "#80000000"
//          source: root
//          z: 0
//    }

    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
//        x: -20; y:-20
//        width: root.imageWidth + 40
//        height: active ? root.imageHeight + scroll_bkg.height + 40 : root.imageHeight + 40
        anchors.fill: root
        anchors.margins: -10
    }


    Image
    {
        id: img
        fillMode: Image.PreserveAspectFit
        width: root.width
        anchors.top: controls.bottom

    }
    //load indicator
    OmekaIndicator {
        scale: 2
        running: img.progress < 1
    }
    MultiPointPinchArea
    {
        anchors.fill: img
        anchors.topMargin: -40

        dragOnPinch: true
        listenForRotation: true
        listenForScale: true

        maximumScale: 3
        minimumScale: 1

        mouseEnabled: true

        minimumX: 0
        maximumX: 1920 - root.imageWidth

        minimumY: 0
        maximumY: 1080 - root.imageHeight

        onDraggingChanged:
        {
//            if(!dragging)
//            {
//                root.finishedDragging(root);
//            }
        }

        onPositionUpdated:
        {
            root.x += delta_x// * (root.topScreen ? -1.0 : 1.0);// * root.scale;
            root.y += delta_y// * (root.topScreen ? -1.0 : 1.0);// * root.scale;

            root.imageDragged(root);
        }
        onRotationUpdated:
        {
            root.rotation += delta_rotation;
            //image_timer.restart();
        }
        onScaleUpdated:
        {
            root.scale += delta_scale * root.scaleFactor;
            close.scale = 1/root.scale;
            info_btn.scale = 1/root.scale;
            //image_timer.restart();
        }

        debugView: Settings.DEBUG_VIEW
    }
    Image
    {
        id: controls
        width: scroll_bkg.width
        source: "content/POI/info-panel-controls-bkg.png"

        Image
        {
            id: close
            source: "content/POI/close-off.png"
            anchors.top: controls.top
            anchors.right: controls.right
            anchors.margins: 10
            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    root.deleteImage(root);
                }
            }
        }
        Image
        {
            id: info_btn
            source: "content/POI/info-icon-off.png"
            anchors.top: controls.top
            anchors.left: controls.left
            anchors.margins: 10
            MouseArea
            {
                anchors.fill: parent
                anchors.margins: -10
                onPressed:
                {
                    root.active = !root.active
                    scroll_bkg.opacity = root.active ? 1.0 : 0.0
                    info_btn.source = root.active ? "content/POI/info-icon-on.png" : "content/POI/info-icon-off.png"
                }
            }
        }
    }

    Image
    {
        id: scroll_bkg
        source: "content/POI/description_bkg.png"
        height: 200
        anchors.top: img.bottom
        anchors.left: root.left
        opacity: 0.0

        //primary display item
        //property DetailColumn column

        /*! scroll container */
        OmekaScrollView {
            id: scroll
            width: root.imageWidth
            height: 180
            //anchors.fill: parent
            enabled: parent.opacity == 1.0
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            //media display
            DetailColumn { id: display; width: root.imageWidth-35; }//height: 500 }
        }

    }


        //Add if necessary
        /*! scroll container */
//        LoadScreen{
//            progress: column && column.viewer ? column.viewer.progress : 0
//        }



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
}
