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

    height: bkg.height
    objectName: "detail"
    property alias source: img.source

    property alias imageWidth: img.width

    property alias imageHeight: img.height

    property var title//: title.text

    property string whichScreen

    property int imageTimerDuration : 100000000 // Settings.IMAGE_TIMER_DURATION

    property alias imageTimer: image_timer

    readonly property double scaleFactor: 1.0

    signal imageDragged(var image);

    signal finishedDragging(var image);

    signal deleteImage(var image);

//    onVisibleChanged:
//    {
//        if(!visible)
//        {
//            root.destroy();
//        }
//    }


    Image
    {
        id: bkg
        source: "content/POI/_Image_.png"
        x: -20; y:-20
        width: root.imageWidth + 40
        height: root.imageHeight + scroll_bkg.height + 40// + title_bkg.height + description_bkg.height + 40
    }
    Rectangle
    {
        color: "#ffffff"
        anchors.fill: img
    }

    Image
    {
        id: img
        fillMode: Image.PreserveAspectFit

    }
    Image
    {
        id: scroll_bkg
        source: "content/POI/description_bkg.png"
        height: 200
        anchors.top: img.bottom
        anchors.left: root.left
    }

        //primary display item
        //property DetailColumn column

        /*! scroll container */
        OmekaScrollView {
            id: scroll
            anchors.top: img.bottom
            anchors.left: root.left
            anchors.margins: 0
            width: root.imageWidth
            height: 180

            //media display
            DetailColumn { id: display; width: root.imageWidth-35; }//height: 500 }
        }

        //Add if necessary
        /*! scroll container */
//        LoadScreen{
//            progress: column && column.viewer ? column.viewer.progress : 0
//        }


    Image
    {
        id: close
        source: "content/POI/Asset 4.png"
        anchors.bottom: img.top
        anchors.right: img.right
        MultiPointTouchArea
        {
            anchors.fill: parent
            onPressed:
            {
                root.deleteImage(root);
            }
        }
    }
    DropShadow
    {
        id: imageEffect
          anchors.fill: close
          horizontalOffset: 3
          verticalOffset: 0
          radius: 8.0
          samples: 17
          color: "#80000000"
          source: close
    }
    MultiPointPinchArea
    {
        anchors.fill: img

        dragOnPinch: true
        listenForRotation: false
        listenForScale: false

//        maximumScale: 2
//        minimumScale: 0.15

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
            image_timer.restart();
        }
        onScaleUpdated:
        {
            root.scale += delta_scale * root.scaleFactor;
            image_timer.restart();
        }

        debugView: Settings.DEBUG_VIEW
    }

    Rectangle
    {
        anchors.fill: parent
        color: "blue"
        opacity: 0.5
        visible: parent.enabled && Settings.DEBUG_VIEW
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
}
